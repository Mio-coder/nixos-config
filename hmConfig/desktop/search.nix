pkgs: let
  snowflake = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
in [
  {
    key = "nix-packages";
    name = "NixOS Packages";
    template = "https://search.nixos.org/packages";
    params = [
      {
        name = "type";
        value = "packages";
      }
      {
        name = "query";
        value = "{searchTerms}";
      }
    ];
    icon = snowflake;
    definedAliases = ["@np"];
  }
  {
    key = "nix-options";
    name = "NixOS Options";
    template = "https://search.nixos.org/options";
    params = [
      {
        name = "query";
        value = "{searchTerms}";
      }
    ];
    icon = snowflake;
    definedAliases = ["@no"];
  }
  {
    key = "nix-wiki";
    name = "NixOS Wiki";
    template = "https://nixos.wiki/index.php";
    params = [
      {
        name = "search";
        value = "{searchTerms}";
      }
    ];
    icon = snowflake;
    definedAliases = ["@nw"];
  }
  {
    key = "hearch";
    name = "hearch";
    template = "https://hearch.co/search";
    icon = "https://hearch.co/_app/immutable/assets/logo.DDnVPknL.svg";
    definedAliases = ["@he"];
  }
  {
    key = "ddg";
    name = "DuckDuckGo";
    template = "https://duckduckgo.com/";
    icon = "https://duckduckgo.com/assets/logo_social-media.png";
  }
  {
    key = "home-manager-options";
    name = "Home Manager Options";
    template = "https://search.nixos.org/options";
    params = [
      {
        name = "query";
        value = "{searchTerms}";
      }
      {
        name = "source";
        value = "home_manager";
      }
    ];
    definedAliases = ["@hm"];
    icon = pkgs.fetchurl {
      url = "https://home-manager.dev/favicon.png";
      hash = "sha256-gMbZLUUw3MZi1vfw0EkB3CUFiz4Bj/ovKq/N3DDWSbU=";
    };
  }
]
