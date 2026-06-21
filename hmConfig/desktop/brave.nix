{pkgs, ...}: let
  chromiumPolish = pkgs.hunspellDictsChromium.mkDictFromChromium {
    shortName = "pl-pl";
    dictFileName = "pl-PL-3-0.bdic";
    shortDescription = "Polish (Poland)";
  };
in {
  programs.brave = {
    enable = true;
    package = pkgs.brave;
    dictionaries = [
      chromiumPolish
      pkgs.hunspellDictsChromium.en_US
    ];
    commandLineArgs = [
      "--disable-background-networking"
      "--disable-breakpad"
      "--disable-component-update"
    ];
    extensions = [
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # Dark Reader
      {id = "fhcgjolkccmbidfldomjliifgaodjagh";} # Cookie AutoDelete
      {id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp";} # Privacy Badger
      {id = "hlepfoohegkhhmjieoechaddaejaokhf";} # Refined GitHub
      {id = "mdjildafknihdffpkfmmpnpoiajfjnjd";} # Consent-O-Matic
      {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # SponsorBlock
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # uBlock Origin
      {id = "jaoafjdoijdconemdmodhbfpianehlon";} # Skip Redirect
    ];
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "x-scheme-handler/about" = "brave-browser.desktop";
    "x-scheme-handler/unknown" = "brave-browser.desktop";
  };
}
