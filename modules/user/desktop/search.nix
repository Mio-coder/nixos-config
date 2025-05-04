pkgs: [
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
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
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
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = ["@no"];
  }
  {
    key = "nix-wiki";
    name = "NixOS Wiki";
    template = "https://search.nixos.org/options";
    params = [
      {
        name = "query";
        value = "{searchTerms}";
      }
    ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = ["@nw"];
  }
  {
    key = "hearch";
    name = "hearch";
    template = "https://hearch.co/search";
    icon = "https://hearch.co/_app/immutable/assets/logo.DDnVPknL.svg";
  }
  {
    key = "ddg";
    name = "DuckDuckGo";
    template = "https://duckduckgo.com/";
    icon = "https://duckduckgo.com/assets/logo_social-media.png";
  }
  {
    key = "pypi";
    name = "PyPI";
    template = "https://pypi.org/search";
    icon = pkgs.fetchurl {
      url = "https://pypi.org/static/images/logo-small.8998e9d1.svg";
      hash = "sha256-nEdP3zE93Wbo7vuG/pnSYzaqCD2+4V7AcEfme2bQXwk=";
    };
  }
  {
    key = "github";
    name = "Github";
    template = "https://github.com/search";
    params = [
      {
        name = "q";
        value = "{searchTerms}";
      }
      {
        name = "type";
        value = "repositories";
      }
    ];
    icon = pkgs.fetchurl {
      url = "https://github.githubassets.com/favicons/favicon.svg";
      hash = "sha256-apV3zU9/prdb3hAlr4W5ROndE4g3O1XMum6fgKwurmA=";
    };
    definedAliases = ["@gh"];
  }
]
