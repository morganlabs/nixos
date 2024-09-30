{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.roles.zsh;

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
    cat = "bat -n --theme gruvbox-dark";
    ls = "eza --long --icons --colour=always --all -T --level 1 --group-directories-first -b -h --git";

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

  finalAliases = if cfg.alias.includeDefault then defaultAliases // cfg.alias.aliases else cfg.alias.aliase;
  finalPlugins = if cfg.plugin.includeDefault then defaultPlugins ++ cfg.plugin.plugins else cfg.plugin.plugins;
  finalSessionVariables =
    if cfg.sessionVariables.includeDefault then
      defaultSessionVariables // cfg.sessionVariables.sessionVariables
    else
      cfg.sessionVariables.sessionVariables;
in
{
  options.roles.zsh = {
    enable = mkEnableOption "Enable ZSH";

    alias = {
      includeDefault = mkOption {
        type = types.bool;
        description = "Include default aliases";
        default = true;
      };

      aliases = mkOption {
        type = types.attrs;
        description = "Additional/custom aliases";
        default = { };
      };
    };

    plugin = {
      includeDefault = mkOption {
        type = types.bool;
        description = "Include default plugins";
        default = true;
      };

      plugins = mkOption {
        type = types.listOf types.str;
        description = "Additional/custom plugins";
        default = [ ];
      };
    };

    sessionVariables = {
      includeDefault = mkOption {
        type = types.bool;
        description = "Include default session variables";
        default = true;
      };

      sessionVariables = mkOption {
        type = types.attrs;
        description = "Additional/custom session variables";
        default = { };
      };
    };
  };

  # config.programs.zsh.enable = mkIf cfg.enable true;

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      eza
      bat
    ];

    programs.zsh = {
      enable = true;
      shellAliases = finalAliases;
      sessionVariables = finalSessionVariables;
      autocd = true;
      antidote = {
        enable = true;
        plugins = finalPlugins;
      };
      initExtra = ''
        setopt HIST_FIND_NO_DUPS
        setopt INC_APPEND_HISTORY

        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down

        function mkcdir() {
        	mkdir -p "$1"
        	cd "$1"
        }

        PROMPT="%B%F{orange}[%n@%m:%3~]%b%{$reset_color%} "
      '';
    };
  };
}
