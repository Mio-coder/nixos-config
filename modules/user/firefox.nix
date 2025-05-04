{
  config,
  pkgs,
  nur ? import <nur> {},
  ...
}: {
  programs = {
    firefox = {
      enable = true;
      languagePacks = ["pl" "en-US"];
      policies = {
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
        DisablePocket = true;
        DNSOverHTTPS = {
          Enabled = true;
          Fallback = true;
        };
        EnableTrackingProtection = {
          Value = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };
        FirefoxHome = {
          Search = true;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = true;
        };
        FirefoxSuggest = {
          WebSuggestions = true;
          SponsoredSuggestion = false;
          ImproveSuggest = false;
        };
        HardwareAcceleration = true;
        NoDefaultBookmarks = true;
        Permissions = {
          Notifications = {
            Block = ["*"];
          };
        };
        ShowHomeButton = false;
        # ExtensionSettings = {
        #   "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        #   # uBlock Origin:
        #   "uBlock0@raymondhill.net" = {
        #     install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        #     installation_mode = "force_installed";
        #     private_browsing = true;
        #   };
        #   # add extensions here...
        #   "ctrl-shift-c-copy@jeffersonsecher.com" = {
        #     url = "https://addons.mozilla.org/firefox/downloads/latest/ctrl-shift-c-should-copy/latest.xpi";
        #     installation_mode = "force_installed";
        #     private_browsing = true;
        #   };
        # };
      };

      profiles = {
        main_profile = {
          id = 0;
          name = "Main profile";
          isDefault = true;
          settings = {
            # specify profile-specific preferences here; check about:config for options
            "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
            "browser.startup.homepage" = "https://duckduckgo.org";
            "browser.newtabpage.pinned" = [
              {
                title = "NixOS";
                url = "https://nixos.org";
              }
            ];
          };
          # add preferences for profile_0 here...
          search = let
            mkEngine = {
              name,
              template,
              params ? [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ],
              icon,
              definedAliases ? null,
              ...
            }: {
              inherit name;
              urls = [{inherit template params;}];
              inherit icon definedAliases;
            };
            mkEngineSet = list:
              builtins.listToAttrs (map (e: {
                  name = e.key;
                  value = mkEngine e;
                })
                list);
          in {
            default = "ddg";
            order = ["ddg" "nix-packages"];
            force = true;
            engines = mkEngineSet (import ./search.nix pkgs);
          };
          #          extensions =
          #             (with nur.repos.rycee.firefox-addons; [
          #              ublock-origin
          #           ])
          #          ++ (with nur.repos.colinsane.pkgs.firefox-extensions; [
          #           i-still-dont-care-about-cookies
          #          ctrl-shift-c-should-copy
          #       ]);
        };
      };
    };
  };
}
