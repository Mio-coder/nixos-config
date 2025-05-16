{pkgs, ...}: let
  # 1) Build the "toggle-key" script in /nix/store via writeShellScriptBin
  toggleKey = pkgs.writeShellScriptBin "toggle-key" ''
    #!${pkgs.bash}/bin/bash
    KEY=$1
    FLAG=/tmp/hold_$KEY

    if [[ -e $FLAG ]]; then
      ${pkgs.xdotool}/bin/xdotool keyup $KEY
      rm $FLAG
    else
      ${pkgs.xdotool}/bin/xdotool keydown $KEY
      touch $FLAG
    fi
  '';
in {
  environment.etc."xbindkeysrc".text = ''
    # Ctrl+Alt+Fn+W → toggle “w” hold
    "${toggleKey}/bin/toggle-key w"
      Control+Alt+Mod3 + w
  '';

  # 4) Auto-start xbindkeys when GNOME session launches
  services.xserver.enable = true;
  services.xserver.windowManager.gnome.enable = true;
  services.xserver.windowManager.gnome.extraSessionCommands = ''
    ${pkgs.xbindkeys}/bin/xbindkeys -f /etc/xbindkeysrc &
  '';
}
