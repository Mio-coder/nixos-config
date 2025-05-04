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
    extraConfig = ''
      set -s copy-command 'wl-copy'
      set -as terminal-features '*:256'
    '';
    # export __ETC_PROFILE_NIX_SOURCED=1
  };
}
