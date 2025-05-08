{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hmModules/terminal/home_config.nix
    ./hmModules/desktop/term.nix
    ./hmModules/desktop/firefox.nix
    ./hmModules/terminal/bash.nix
    ./hmModules/terminal/tmux.nix
    ./hmModules/terminal/btop.nix
    ./hmModules/desktop/fonts.nix
    ./hmModules/terminal/lofi.nix
    ./hmModules/terminal/minionki.nix
    ./hmModules/terminal/starship.nix
    ./hmModules/terminal/git.nix
    ./hmModules/terminal/lvim.nix
    ./hmModules/terminal/nix-index.nix
    ./hmModules/desktop/sway
  ];

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    uv
    act
    alejandra
    ungoogled-chromium
    man-db
    python312Packages.ipython
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
