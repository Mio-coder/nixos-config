{pkgs, ...}: {
  home.packages = with pkgs; [
    uv
    act
    alejandra
    python313Packages.ipython
    valgrind
    gcc
    gnumake
    oiejq
    lldb_21
    llvmPackages_21.clang-tools
    just
    dbg-macro
    rsync
    gh
  ];
}
