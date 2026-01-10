{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  colorsheme ? "nord",
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "voidsddm";
  version = "unstable-2026-01-10";

  src = fetchFromGitHub {
    owner = "talyamm";
    repo = "voidsddm";
    # Prefer a fixed rev for reproducibility; replace with a real commit hash
    # you want to pin to.
    rev = "d964069ccdbd7427b9c45e7d11af3c929f744843";
    hash = "sha256-JnIecRb8xgmEDNeg7Y0TAEjnCc/qFAHY0WhxQzr9tg4=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/sddm/themes"
    cp -r . "$out/share/sddm/themes/voidsddm"
    substituteInPlace "$out/share/sddm/themes/voidsddm/metadata.desktop" \
      --replace-fail 'default' '${colorsheme}'

    runHook postInstall
  '';

  meta = {
    description = "VoidSDDM theme for SDDM";
    homepage = "https://github.com/talyamm/voidsddm";
    platforms = lib.platforms.linux;
  };
})
