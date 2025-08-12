_: {
  my = rec {
    i3 = true;
    kde = false;
    gnome = !kde && !i3;
  };
}
