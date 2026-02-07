{ ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-q";
    baseIndex = 0;
    
    extraConfig = ''
      # New pane in current directory
      bind c new-window -c "#{pane_current_path}"

      # Pane split in current directory
      bind 3 split-window -h -c "#{pane_current_path}"
      bind 2 split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Disable mouse
      set -g mouse off
      set-option -g detach-on-destroy off
      set-option -g allow-rename off

      # Plugins
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'tmux-plugins/tmux-sensible'
      set -g @plugin 'tmux-plugins/tmux-resurrect'
      set -g @plugin 'tmux-plugins/tmux-continuum'
      set -g @plugin 'catppuccin/tmux'
      set -g @catppuccin_status_default "off"
      set -g @plugin 'laktak/extrakto'
      set -g @extrakto_fzf_tool "fzf"

      # Initialize TPM (keep at bottom)
      run '~/.tmux/plugins/tpm/tpm'
    '';
  };
}
