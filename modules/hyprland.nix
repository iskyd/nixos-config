{ ... }:

{
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  security.pam.services.hyprlock = {};
}
