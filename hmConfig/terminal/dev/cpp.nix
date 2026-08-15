{
  pkgs,
  lib,
  ...
}: {
  xdg.configFile."clangd/config.yaml".source = let
    yaml = pkgs.formats.yaml {};
  in
    yaml.generate "clangd-config.yaml" {
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
  home.file.".clang-format".text = ''
    IndentWidth: 4
  '';
  home.packages = [
    (
      let
        libcxxLinkerScript = "${pkgs.llvmPackages_18.libcxx}/lib/libc++${pkgs.clangStdenv.hostPlatform.extensions.sharedLibrary}";
        libcxxSharedObject = "${libcxxLinkerScript}.1.0";
        flags =
          map (
            flag:
              if flag == libcxxLinkerScript
              then libcxxSharedObject
              else flag
          )
          pkgs.cling.flags;
        wrappedFlags =
          ["-I" "${placeholder "out"}/include"]
          ++ flags;
      in
        pkgs.cling.overrideAttrs (oldAttrs: {
          flags = wrappedFlags;
        })
    )
  ];
}
