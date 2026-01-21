{
  config,
  lib,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.services.vaultwarden;

  port = 8222;
in
{
  options.modules.services.vaultwarden = {
    enable = mkEnableOption "Enable services.vaultwarden";
    traefik.enable = mkEnableOption "Enable Traefik routing";
  };

  config = mkIf cfg.enable {
    modules.services.vaultwarden.traefik.enable = mkDefault true;

    age.secrets = {
      vaultwarden-admin-token.file = ../../secrets/${vars.hostname}/vaultwarden-admin-token.age;
      vaultwarden-push-id.file = ../../secrets/${vars.hostname}/vaultwarden-push-id.age;
      vaultwarden-push-key.file = ../../secrets/${vars.hostname}/vaultwarden-push-key.age;
      smtp-username.file = ../../secrets/${vars.hostname}/smtp-username.age;
      smtp-password.file = ../../secrets/${vars.hostname}/smtp-password.age;
    };

    age-template.files."vaultwarden.env" = {
      vars = {
        adminToken = config.age.secrets.vaultwarden-admin-token.path;
        pushId = config.age.secrets.vaultwarden-push-id.path;
        pushKey = config.age.secrets.vaultwarden-push-key.path;
        smtpUsername = config.age.secrets.smtp-username.path;
        smtpPassword = config.age.secrets.smtp-password.path;
      };
      content = ''
        ADMIN_TOKEN=$adminToken

        PUSH_ENABLED=true
        PUSH_INSTALLATION_ID=$pushId
        PUSH_INSTALLATION_KEY=$pushKey
        PUSH_RELAY_URI=https://api.bitwarden.eu
        PUSH_IDENTITY_URI=https://identity.bitwarden.eu

        SMTP_HOST=smtp-relay.brevo.com
        SMTP_FROM=noreply@morganlabs.dev
        SMTP_FROM_NAME=Vaultwarden
        SMTP_USERNAME=$smtpUsername
        SMTP_PASSWORD=$smtpPassword
        SMTP_TIMEOUT=15
        SMTP_SECURITY=starttls
        SMTP_PORT=587
        SMTP_EMBED_IMAGES=true
      '';
    };

    services.vaultwarden = {
      enable = mkForce true;
      backupDir = "/var/local/vaultwarden/backup";
      environmentFile = config.age-template.files."vaultwarden.env".path;
      config = {
        DOMAIN = "https://vault.morganlabs.dev";
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = port;
        ROCKET_LOG = "critical";

        SENDS_ALLOWED = true;
        TRASH_AUTO_DELETE_DAYS = 30;

        ORG_ATTACHMENT_LIMIT = 512000;
        USER_ATTACHMENT_LIMIT = 512000;
        USER_SEND_LIMIT = 102400;

        SIGNUPS_VERIFY = true;

        EXPERIMENTAL_CLIENT_FEATURE_FLAGS = "ssh-agent,ssh-key-vault-item,export-attachments,";

      };
    };

    services.traefik.dynamicConfigOptions.http = mkIf cfg.traefik.enable (mkTraefikServices [
      {
        inherit port;
        service = "vaultwarden";
        subdomain = "vault";
      }
    ]);
  };
}
