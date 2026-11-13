{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  gcc,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "toster";
  version = "1.2.1-unstable-2026-11-13";

  src = fetchFromGitHub {
    owner = "Mio-coder";
    repo = "toster";
    rev = "master";
    hash = "sha256-4rStigbGAtWtm1F2Xx6UZT0iEi9vVkylEErGaO4oZ+s=";
  };
  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";

  nativeBuildInputs = [makeWrapper];

  postPatch = ''
    substituteInPlace src/executor/sio2jail.rs \
      --replace-fail \
        'let result = executable_dir.join("sio2jail");' \
        'let result = PathBuf::from("${placeholder "out"}/libexec/toster/sio2jail");'
  '';

  postInstall = ''
    wrapProgram "$out/bin/toster" \
      --prefix PATH : ${lib.makeBinPath [gcc]}
    install -Dm755 sio2jail "$out/libexec/toster/sio2jail"
  '';

  meta = {
    description = "Tester for C++ solutions to competitive programming exercises";
    homepage = "https://github.com/MikolajKolek/toster";
    license = lib.licenses.mit;
    mainProgram = "toster";
    platforms = lib.platforms.linux;
  };
})
