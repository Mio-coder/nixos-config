{...}: {
  xdg.configFile.".gdbinit".text = ''
    set debuginfod enabled on
    set startup-with-shell off
  '';
}
