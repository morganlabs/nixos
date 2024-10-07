{ config, lib, ... }:
with lib;
let
  cfg = config.roles.cmd.zsh;

  defaultPlugins = [
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-syntax-highlighting"
    "zsh-users/zsh-history-substring-search"
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

  finalAliases =
    if cfg.aliases.default.enable then defaultAliases // cfg.aliases.extra else cfg.aliases.extra;
  finalPlugins =
    if cfg.plugins.default.enable then defaultPlugins ++ cfg.plugins.extra else cfg.plugins.extra;
  finalSessionVariables =
    if cfg.sessionVariables.default.enable then
      defaultSessionVariables // cfg.sessionVariables.extra
    else
      cfg.sessionVariables.extra;
in
{
  imports = [
    ./eza.nix
    ./bat.nix
  ];

  options.roles.cmd.zsh = {
    enable = mkEnableOption "Enable ZSH";

    aliases = {
      default.enable = mkOption {
        type = types.bool;
        description = "Include default aliases";
        default = true;
      };

      extra = mkOption {
        type = types.attrs;
        description = "Additional/custom aliases";
        default = { };
      };
    };

    plugins = {
      default.enable = mkOption {
        type = types.bool;
        description = "Include default plugins";
        default = true;
      };

      extra = mkOption {
        type = types.listOf types.str;
        description = "Additional/custom plugins";
        default = [ ];
      };
    };

    sessionVariables = {
      default.enable = mkOption {
        type = types.bool;
        description = "Include default session variables";
        default = true;
      };

      extra = mkOption {
        type = types.attrs;
        description = "Additional/custom session variables";
        default = { };
      };
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
      antidote = {
        enable = true;
        plugins = finalPlugins;
      };
      initExtra = with config.colorScheme.palette; ''
        setopt HIST_FIND_NO_DUPS
        setopt INC_APPEND_HISTORY

        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down

        function mkcdir() {
        	mkdir -p "$1"
        	cd "$1"
        }

        PROMPT="%B%F{#${base0E}}[%n@%m:%3~]%b%{$reset_color%} "
      '';
    };
  };
}
