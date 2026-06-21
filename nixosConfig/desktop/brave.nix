{...}: {
  programs.chromium = {
    enable = true;
    homepageLocation = "https://start.duckduckgo.com";
    defaultSearchProviderEnabled = true;
    defaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
    defaultSearchProviderSuggestURL = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
    extraOpts = {
      # Search
      DefaultSearchProviderName = "DuckDuckGo";
      DefaultSearchProviderKeyword = "duckduckgo.com";

      # Privacy / telemetry
      MetricsReportingEnabled = false;
      SafeBrowsingExtendedReportingEnabled = false;
      BraveP3AEnabled = false;
      BraveStatsPingEnabled = false;
      BraveWebDiscoveryEnabled = false;
      ReportWebsiteTelemetry = [];
      CloudReportingEnabled = false;

      # Security / safe browsing
      SafeBrowsingDeepScanningEnabled = false;
      PasswordLeakDetectionEnabled = false;

      # Brave features
      BraveRewardsDisabled = true;
      BraveRewardsIconHidden = true;
      BraveAIChatEnabled = false;
      BraveNewsDisabled = true;
      BraveTalkDisabled = true;
      BraveWalletDisabled = true;
      BraveVPNDisabled = true;
      BravePlaylistEnabled = false;

      # Sign-in / sync
      BrowserSignin = 0;
      SyncDisabled = true;
      BrowserGuestModeEnabled = false;

      # Autofill / password manager
      AutofillCreditCardEnabled = false;
      PasswordManagerEnabled = false;

      # Site permissions
      DefaultGeolocationSetting = 3;
      DefaultNotificationsSetting = 2;
      DefaultSerialGuardSetting = 2;
      DefaultSensorsSetting = 2;

      # UI / browsing behavior
      AlternateErrorPagesEnabled = false;
      QuickAnswersEnabled = false;
      RelatedWebsiteSetsEnabled = false;
      ShowFullURLs = true;

      # Performance / background
      BackgroundModeEnabled = false;
      HardwareAccelerationModeEnabled = true;
      MemorySaverEnabled = true;
    };
  };
}
