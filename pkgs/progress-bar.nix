{
  stdenv,
  fetchFromGitHub,
  lib,
  llvmPackages,
}:
stdenv.mkDerivation {
  pname = "progress-bar";
  version = "unstable-2026-03-17";

  src = fetchFromGitHub {
    owner = "lguedesc";
    repo = "Progress-Bar";
    rev = "97613b873ca7b37e78cf254abffa668fff98eff1";
    hash = "sha256-2gCrZdLdziqDoCi14L31ibA6CdkWAfHExc6sBShQ/9s=";
  };

  buildInputs = [llvmPackages.openmp];

  # Enable OpenMP flags
  NIX_CFLAGS_COMPILE = ["-fopenmp"];
  NIX_LDFLAGS = ["-fopenmp"];

  enableParallelBuilding = true;

  buildPhase = ''
    runHook preBuild
    gcc $NIX_CFLAGS_COMPILE -shared progbar.c -o libprogbar.so
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    make run
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 progbar.h $out/include/progbar.h
    install -Dm755 libprogbar.so $out/lib/libprogbar.so
    runHook postInstall
  '';

  meta = {
    description = "A small C library to display progress bars for single and multi‑thread processes";
    homepage = "https://github.com/lguedesc/Progress-Bar";
    maintainers = [];
    platforms = lib.platforms.all;
  };
}
