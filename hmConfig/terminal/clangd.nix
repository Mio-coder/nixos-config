{pkgs, ...}: let
  yaml = pkgs.formats.yaml {};
in {
  xdg.configFile."clangd/config.yaml".source = yaml.generate "clangd-config.yaml" {
    CompileFlags = {
      Compiler = "g++";
      Add = let
        gcc = pkgs.gcc-unwrapped;
        ver = gcc.version;
        triplet = pkgs.stdenv.hostPlatform.config;

        cxxBase = "${gcc}/include/c++/${ver}";
        gccLibBase = "${gcc}/lib/gcc/${triplet}/${ver}";
      in [
        "-xc++"
        "-std=c++23"
        "-O3"

        "-Wall"
        "-Wextra"
        "-Wpedantic"
        "-Weffc++"

        "-DDEBUG"
        "-ggdb3"
        "-g"

        "-I${cxxBase}/"
        "-I${cxxBase}/${triplet}"
        "-I${cxxBase}/backward"
        "-I${gcc}/include"
        "-I${gccLibBase}/include"
        "-I${gccLibBase}/include-fixed"
        "-I${pkgs.glibc.dev}/include"
      ];
    };
    Index.Background = "Skip";
  };
}
