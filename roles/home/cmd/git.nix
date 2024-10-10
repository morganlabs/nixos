{
  config,
  user,
  lib,
  myLib,
  pkgs,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.cmd.git;

  defaults = {
    username = user.name;
    email = user.email;
    branch = "main";
  };
in
{
  options.roles.cmd.git = {
    enable = mkEnableOption "Enable Git";

    defaultBranch = mkOption {
      type = types.str;
      description = "Default Branch";
      default = defaults.branch;
    };

    use1PasswordSigning = mkOption {
      type = types.bool;
      description = "Use 1Password Git Signing";
      default = true;
    };

    user = {
      username = mkOption {
        type = types.str;
        description = "Username";
        default = defaults.username;
      };

      email = mkOption {
        type = types.str;
        description = "Email";
        default = defaults.email;
      };
    };

    features = {
      delta.enable = mkOption {
        type = types.bool;
        description = "Enable Delta";
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      mkIf cfg.use1PasswordSigning [
        _1password
        _1password-gui
      ];

    programs.ssh = {
      enable = true;
      extraConfig = mkIfStr cfg.use1PasswordSigning ''
        Host *
          IdentityAgent ~/.1password/agent.sock
      '';
    };

    programs.git = {
      enable = true;
      userName = cfg.user.username;
      userEmail = cfg.user.email;

      delta = mkIf cfg.features.delta.enable {
        enable = true;
        options = {
          core = {
            pager = "delta";
          };
          interactive = {
            diffFilter = "delta --color-only";
          };
          delta = {
            navigate = true;
          };
          merge = {
            conflictstyle = "diff3";
          };
          diff = {
            colorMoved = "default";
          };
        };
      };

      extraConfig = mkMerge [
        {
          init.defaultBranch = cfg.defaultBranch;
        }
        (mkIf cfg.use1PasswordSigning {
          user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBNv1xhpJxFP8KP0+ai4+sK6HRu70J6Nq/u4dU27MixM";
          commit.gpgsign = true;
          gpg = {
            format = "ssh";
            ssh.program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
          };
        })
      ];
    };
  };
}
