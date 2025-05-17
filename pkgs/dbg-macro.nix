{
  stdenv,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "dbg-macro";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "dbg-macro";
    rev = "v${version}";
    sha256 = "sha256-wpP31skcgNwbJBLDp83le+pJJtkMhr44B8BlMfze0w4=";
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
