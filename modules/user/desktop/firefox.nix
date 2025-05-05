{
  pkgs,
  ...
}: let 
  nur = if builtins.hasAttr "nur" pkgs then pkgs.nur else import <nur> {};
in {
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
      };

      profiles = {
        main_profile = {
          id = 0;
          name = "Main profile";
          isDefault = true;
          settings = {
            "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
            "browser.startup.homepage" = "https://start.duckduckgo.org";

            # Fully disable Pocket. See
            # https://www.reddit.com/r/linux/comments/zabm2a.
            "extensions.pocket.enabled" = false;
            "extensions.pocket.api" = "0.0.0.0";
            "extensions.pocket.loggedOutVariant" = "";
            "extensions.pocket.oAuthConsumerKey" = "";
            "extensions.pocket.onSaveRecs" = false;
            "extensions.pocket.onSaveRecs.locales" = "";
            "extensions.pocket.showHome" = false;
            "extensions.pocket.site" = "0.0.0.0";
            "browser.newtabpage.activity-stream.pocketCta" = "";
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "services.sync.prefs.sync.browser.newtabpage.activity-stream.section.highlights.includePocket" =
              false;
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
          extensions.packages = with nur.repos.rycee.firefox-addons; [
            link-cleaner
            darkreader
            cookie-autodelete
            privacy-badger
            refined-github
            consent-o-matic
            sponsorblock
            to-google-translate
            ublock-origin
            terms-of-service-didnt-read
            polish-dictionary
            copy-selection-as-markdown
            skip-redirect
          ];
        };
      };
    };
  };
}
