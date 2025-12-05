{
  stdenv,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation {
  name = "dbg-macro";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "dbg-macro";
    rev = "c2ad2915d0029cf2f38f27ff05acfd6ea57ccdc5";
    hash = "sha256-ZP3Qk3/hfzjO5csohs78PJfBqFY+pR4SiHe28XukEmY=";
  };
  patches = [./dbg_no_type.diff];
  dontBuild = true;

  installPhase = ''
    install -Dm644 dbg.h $out/usr/include/dbg.h
  '';

  meta = with lib; {
    description = "A printf-style debugging macro for C++";
    homepage = "https://github.com/sharkdp/dbg-macro";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.all;
  };
}
