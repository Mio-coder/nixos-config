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
    rev = "a94fa67eca61e245cf33bdd340110329ea9f1b05";
    hash = "sha256-q3Podk1QkGS2vA/Zo6amHUihDchlyNIjoQmvbL0MRog=";
  };
  dontBuild = true;

  installPhase = ''
    install -Dm644 dbg.h $out/include/dbg.h
  '';

  meta = with lib; {
    description = "A printf-style debugging macro for C++";
    homepage = "https://github.com/sharkdp/dbg-macro";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.all;
  };
}
