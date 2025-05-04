{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/user/terminal/home_config.nix
    ../../modules/user/terminal/meta.nix
    ../../modules/user/desktop/term.nix
    ../../modules/user/desktop/firefox.nix
    ../../modules/user/terminal/bash.nix
    ../../modules/user/terminal/tmux.nix
    ../../modules/user/terminal/btop.nix
    ../../modules/user/desktop/fonts.nix
    ../../modules/user/terminal/lofi.nix
    ../../modules/user/terminal/minionki.nix
    ../../modules/user/terminal/starship.nix
    ../../modules/user/terminal/git.nix
  ];

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    fd
    ripgrep
    sl
    uv
    act
    lunarvim
    nixd # for lvim config
    alejandra
    ungoogled-chromium
    man-db
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    ".gdbinit".text = "set debuginfod enabled on";
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };
}
