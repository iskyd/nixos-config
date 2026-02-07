{ ... }:

{
  programs.emacs.enable = true;
  
  home.file.".emacs.d/init.el".source = ../../dotfiles/init.el;

  services.emacs = {
    enable = true;
    client.enable = true;
    socketActivation.enable = false;
    startWithUserSession = true;
  };
}
