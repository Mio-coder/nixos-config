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
  version = "1.2.1-unstable-2024-12-07";

  src = fetchFromGitHub {
    owner = "MikolajKolek";
    repo = "toster";
    rev = "90b0b2981d58baead0906a6baa8be8443484f504";
    hash = "sha256-4rStigbGAtWtm1F2Xx6UZT0iEi9vVkylEErGaO4oZ+s=";
  };
  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";

  nativeBuildInputs = [makeWrapper];

  postPatch =
    ''
      # Upstream build.rs copies sio2jail into the user's home directory.
      # Install it into the Nix output instead.
      printf 'fn main() {}\n' > build.rs

      substituteInPlace src/args.rs \
        --replace-fail \
          'g++ -std=c++20 -O3 -static <IN> -o <OUT>' \
          'g++ -std=c++20 -O3 <IN> -o <OUT>'
    ''
    + lib.optionalString stdenv.hostPlatform.isx86_64 ''
      substituteInPlace src/executor/sio2jail.rs \
        --replace-fail \
          'let result = executable_dir.join("sio2jail");' \
          'let result = PathBuf::from("${placeholder "out"}/libexec/toster/sio2jail");'
    '';

  postInstall =
    ''
      wrapProgram "$out/bin/toster" \
        --prefix PATH : ${lib.makeBinPath [gcc]}
    ''
    + lib.optionalString stdenv.hostPlatform.isx86_64 ''
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
