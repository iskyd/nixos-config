{ config, pkgs, lib, ... }:

{
  home.file.".p10k.zsh".source = ../../dotfiles/p10k.zsh;

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    
    initExtra = lib.mkMerge [
      (lib.mkBefore ''
        # Link powerlevel10k before oh-my-zsh loads
        if [ ! -d ~/.config/zsh/custom/themes/powerlevel10k ]; then
          mkdir -p ~/.config/zsh/custom/themes
          ln -sf ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k ~/.config/zsh/custom/themes/powerlevel10k
        fi
      '')
      ''
        # Powerlevel10k instant prompt
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        # Start tmux automatically
        if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
          case "$TERM" in
            screen*|tmux*) ;;
            *) exec tmux ;;
          esac
        fi

        # Fastfetch on new shell (not in tmux)
        LIVE_COUNTER=$(ps a | awk '{print $2}' | grep -vi "tty*" | uniq | wc -l);
        if [ $LIVE_COUNTER -lt 3 ]; then
          fastfetch
        fi

        # p10k config
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        # direnv
        eval "$(direnv hook zsh)"
      ''
    ];

    oh-my-zsh = {
      enable = true;
      theme = "powerlevel10k/powerlevel10k";
      plugins = [ "git" "history-substring-search" ];
      custom = "$HOME/.config/zsh/custom";
    };

    envExtra = ''
      export ZSH="$HOME/.oh-my-zsh"
      export CDPATH="$CDPATH:/opt/projects/Conio:/home/iskyd/dev"
      export FZF_DEFAULT_OPTS="--height 40% --tmux bottom,40% --layout reverse --tmux"
    '';

    shellAliases = {
      bat = "bat --paging=never";
      e = "emacs -nw";
      f = "find . -type f | fzy";
      starts = "sudo systemctl start";
      restarts = "sudo systemctl restart";
      stops = "sudo systemctl stop";
      reloads = "sudo systemctl reload";
      stats = "sudo systemctl status";
      kills = "sudo systemctl kill";
      copy = "rsync -ah --progress";
      ports = "lsof -i -P -n";
      gg = "git graph";
      nxg = "nix-collect-garbage --delete-older-than 14d";
      ls = "eza --color auto --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --group-directories-first --no-quotes";
      ll = "eza --color auto --long --git --icons=always --group-directories-first --no-quotes";
      sudo = "sudo ";
    };
  };
}
