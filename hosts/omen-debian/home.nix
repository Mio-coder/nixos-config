{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/user/home_config.nix
    ../../modules/user/meta.nix
    ../../modules/user/term.nix
    ../../modules/user/firefox.nix
    ../../modules/user/bash.nix
    ../../modules/user/tmux.nix
    ../../modules/user/btop.nix
    ../../modules/user/fonts.nix
    ../../modules/user/lofi.nix
    ../../modules/user/minionki.nix
    ../../modules/user/starship.nix
    ../../modules/user/git.nix
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
