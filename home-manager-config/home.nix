{
  config,
  pkgs,
  ...
}: {
  imports = [
    ..//home_config.nix
    ./homeModules/meta.nix
    ./homeModules/term.nix
    ./homeModules/firefox.nix
    ./homeModules/bash.nix
    ./homeModules/tmux.nix
    ./homeModules/btop.nix
    ./homeModules/fonts.nix
    ./homeModules/lofi.nix
    ./homeModules/minionki.nix
    ./homeModules/starship.nix
    ./homeModules/git.nix
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
