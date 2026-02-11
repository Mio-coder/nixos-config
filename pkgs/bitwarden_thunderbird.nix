{
  pkgs,
  fetchFromGitHub,
  ...
}: let
  bitwarden_firefox_xpi = pkgs.fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4664623/type:attachment/bitwarden_password_manager-2025.12.1.xpi";
    sha256 = pkgs.lib.fakeHash;
  };

  bitwarden_for_thunderbird_patches = fetchFromGitHub {
    owner = "dtrail";
    repo = "Bitwarden-Extension-for-Thunderbird";
    rev = "7208d0d086410d9e4ec58f381d4eb4c7c4114558";
    hash = "sha256-DHwjLU74ZTwBG4tkCaHBTdxHphxdHEX1B/mpAQP62aQ=";
  };
in
  pkgs.stdenvNoCC.mkDerivation {
    pname = "bitwarden-thunderbird-xpi";
    version = "2025.12.1";

    src = bitwarden_firefox_xpi;

    nativeBuildInputs = [
      pkgs.unzip
      pkgs.zip
    ];

    unpackPhase = ''
      runHook preUnpack
      mkdir -p work
      unzip -q "$src" -d work
      runHook postUnpack
    '';

    patchPhase = ''
      runHook prePatch

      bg="work/background.js"
      patch="${bitwarden_for_thunderbird_patches}/background_patch.js"
      new_manifest="${bitwarden_for_thunderbird_patches}/manifest.json"

      if [ ! -f "$bg" ]; then
        echo "ERROR: expected $bg to exist in the XPI"
        echo "Maybe Bitwarden changed the file layout?"
        exit 1
      fi

      if [ ! -f "$patch" ]; then
        echo "ERROR: expected patch file at $patch"
        exit 1
      fi

      if [ ! -f "$new_manifest" ]; then
        echo "ERROR: expected manifest.json at $new_manifest"
        exit 1
      fi

      # Prepend patch + newline + original background.js (do NOT delete original code)
      tmp="$(mktemp)"
      cat "$patch" > "$tmp"
      printf "\n" >> "$tmp"
      cat "$bg" >> "$tmp"
      mv "$tmp" "$bg"

      # Replace manifest.json
      cp -f "$new_manifest" "work/manifest.json"

      runHook postPatch
    '';

    buildPhase = ''
      runHook preBuild
      ( cd work && zip -qrX ../bitwarden-thunderbird.xpi . )
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -v bitwarden-thunderbird.xpi "$out/bitwarden-thunderbird.xpi"
      runHook postInstall
    '';
  }
