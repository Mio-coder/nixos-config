{
  anki-utils,
  fetchFromGitHub,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "anki-mcp-server-addon";
  version = "0.27.0";
  src = fetchFromGitHub {
    owner = "ankimcp";
    repo = "anki-mcp-server-addon";
    rev = finalAttrs.version;
    sparseCheckout = [ "/anki_mcp_server" ];
    hash = "sha256-28DJq2l9DP8O6OsbNQCZ0pm4S6CQ3Yz0Vfvlj+iQw8Y=";
  };
  sourceRoot = "${finalAttrs.src.name}/anki_mcp_server";
})
