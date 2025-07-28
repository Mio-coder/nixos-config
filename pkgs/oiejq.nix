{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  bash,
  coreutils,
}:
stdenvNoCC.mkDerivation {
  pname = "oiejq";
  version = "2023";

  src = fetchurl {
    url = "https://oij.edu.pl/zawodnik/srodowisko/oiejq.tar.gz";
    sha256 = "sha256-HXxfzLEHaIq7QDVvb8ROTO2dix4xKHe/tVbEYU1SbI4=";
  };

  nativeBuildInputs = [makeWrapper];

  postPatch = ''
    patchShebangs oiejq.sh
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 oiejq.sh "$out/bin/oiejq"
    install -Dm755 sio2jail "$out/bin/sio2jail"

    wrapProgram "$out/bin/oiejq" \
      --prefix PATH : "${lib.makeBinPath [bash coreutils]}" \
      --set SELF_DIR "$out/bin"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool for executing and measuring programs in a controlled environment";
    homepage = "https://oij.edu.pl/zawodnik/srodowisko/";
    license = licenses.mit;
    platforms = ["x86_64-linux"];
  };
}
