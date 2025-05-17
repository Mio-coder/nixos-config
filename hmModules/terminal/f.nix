{...}: {
  programs.thefuck.enable = true;
  xdg.configFile."thefuck/settings.py".text = ''
    exclude_rules = [ 'sl_ls' ]
  '';
}
