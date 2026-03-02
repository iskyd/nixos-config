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

   systemd.user.services.emacs = {
    Service.Environment = "GPTEL_GEMINI_KEY_FILE=/run/secrets/gptel_gemini_key";
  };
}
