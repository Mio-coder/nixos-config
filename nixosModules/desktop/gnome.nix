{pkgs, ...}: {
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    xclip
  ];
}
