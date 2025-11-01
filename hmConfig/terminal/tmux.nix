{pkgs, ...}: let
  shell = pkgs.writeShellScript "tmux_deafult_shell" ''
    #!/bin/bash
    exec env -u __ETC_PROFILE_NIX_SOURCED bash -l
  '';
in {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    clock24 = true;
    plugins = with pkgs; [
      tmuxPlugins.tokyo-night-tmux
    ];
    terminal = "tmux-256color";
    shell = "${shell}";
    # TODO: move iface to config set in hosts
    extraConfig = ''
      set -s copy-command 'wl-copy'
      set -as terminal-features '*:256'

      set -g @tokyo-night-tmux_window_id_style none
      set -g @tokyo-night-tmux_pane_id_style none
      set -g @tokyo-night-tmux_zoom_id_style none

      set -g @tokyo-night-tmux_show_netspeed 0
      set -g @tokyo-night-tmux_show_battery_widget 0
      set -g @tokyo-night-tmux_show_hostname 0
      set -g @tokyo-night-tmux_show_datetime 0
      set -g @tokyo-night-tmux_show_music 0
      set -g @tokyo-night-tmux_show_wbg 0
      set -g @tokyo-night-tmux_show_git 0
    '';
  };
}
