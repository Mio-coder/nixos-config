{...}: {
  xdg.configFile."matplotlib/matplotlibrc".text = ''
    ## See https://matplotlib.org/stable/users/explain/customizing.html#customizing-with-matplotlibrc-files
    backend: TkAgg
  '';
}
