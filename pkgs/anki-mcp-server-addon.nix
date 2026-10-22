{
  anki,
  anki-utils,
  fetchFromGitHub,
}: let
  pythonEnv = anki.python.withPackages (ps:
    with ps; [
      mcp
      pydantic
      starlette
      uvicorn
      anyio
      httpx
      websockets
      packaging
    ]);
in
  anki-utils.buildAnkiAddon (finalAttrs: {
    pname = "anki-mcp-server-addon";
    version = "v0.27.0";
    src = fetchFromGitHub {
      owner = "ankimcp";
      repo = "anki-mcp-server-addon";
      rev = finalAttrs.version;
      sparseCheckout = ["/anki_mcp_server"];
      hash = "sha256-mpKhl/VBVRikqyOgkEYbUg9q7gP6gjT3hUaNMzcSvIQ=";
    };
    sourceRoot = "${finalAttrs.src.name}/anki_mcp_server";

    # The source archive omits vendor/. Use dependencies built for Anki's Python.
    postPatch = ''
      substituteInPlace __init__.py \
        --replace-fail 'from pathlib import Path' \
          'from pathlib import Path; sys.path.insert(0, "${pythonEnv}/${anki.python.sitePackages}")'
    '';
  })
