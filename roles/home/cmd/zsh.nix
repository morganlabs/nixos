{
  config,
  lib,
  myLib,
  pkgs,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.cmd.zsh;

  defaultPlugins = with pkgs; [
    "${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    "${zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
  ];

  defaultAliases = {
    # Misc.
    c = "clear";
    l = "ls";
    e = "exit";
    mkdir = "mkdir -p";
    src = "source $HOME/.zshrc";

    # Replaced programs
    cat = "bat";
    ls = "eza";

    # Git
    gi = "git init";
    ga = "git add";
    gaa = "git add .";
    gc = "git commit";
    gca = "git commit --amend --no-edit";
    gcae = "git commit --amend";
    gcall = "git add . && git commit";
    gd = "git diff";
    gs = "git status";
    gp = "git push";
    gl = "git log --oneline";
    gll = "git log";
    gco = "git checkout";
    gfuck = "git reset --hard";
    gbr = "git branch --format=\"'%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:green) (%(committerdate:relative)) [ %(authorname) ]'\"";

    # Vim
    vi = "nvim";
    vim = "nvim";

  };

  defaultSessionVariables = {
    DOTFILES = "$HOME/Config";
    HISTTIMEFORMAT = "[%F %T]";
  };

  finalAliases = mkIfElse cfg.aliases.default.enable (
    defaultAliases // cfg.aliases.extra
  ) cfg.aliases.extra;
  finalPlugins = mkIfElse cfg.plugins.default.enable (
    defaultPlugins ++ cfg.plugins.extra
  ) cfg.plugins.extra;
  finalSessionVariables = mkIfElse cfg.sessionVariables.default.enable (
    defaultSessionVariables // cfg.sessionVariables.extra
  ) cfg.sessionVariables.extra;
in
{
  imports = [
    ./eza.nix
    ./bat.nix
  ];

  options.roles.cmd.zsh = {
    enable = mkEnableOption "Enable ZSH";

    aliases = {
      default.enable = mkOptionBool "Include default aliases" true;
      extra = mkOptionAttrs "Additional/custom aliases" { };
    };

    plugins = {
      default.enable = mkOptionBool "Include default plugins" true;
      extra = mkOptionListOf types.package "Additional/custom plugins" [ ];
    };

    sessionVariables = {
      default.enable = mkOptionBool "Include default session variables" true;
      extra = mkOptionAttrs "Additional/custom session variables" { };
    };
  };

  config = mkIf cfg.enable {
    roles.cmd = {
      eza.enable = true;
      bat.enable = true;
    };

    programs.zsh = {
      enable = true;
      shellAliases = finalAliases;
      sessionVariables = finalSessionVariables;
      autocd = true;

      initExtraBeforeCompInit = concatStringsSep "\n" (map (item: "source \"${item}\"") finalPlugins);

      initExtra =
        with config.colorScheme.palette;
        mkMerge [
          ''
            setopt HIST_FIND_NO_DUPS
            setopt INC_APPEND_HISTORY

            function mkcdir() {
            	mkdir -p "$1"
            	cd "$1"
            }

            PROMPT="%B%F{#${base0E}}[%n@%m:%3~]%b%{$reset_color%} "
          ''
          (mkIfStr cfg.plugins.default.enable ''
            bindkey '^[[A' history-substring-search-up
            bindkey '^[[B' history-substring-search-down
          '')
        ];
    };
  };
}
