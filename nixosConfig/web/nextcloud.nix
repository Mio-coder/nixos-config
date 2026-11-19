{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.nextcloud.enable = lib.mkEnableOption "Nextcloud";

  config = lib.mkIf config.my.nextcloud.enable {
    services.nextcloud = {
      enable = true;
      hostName = "localhost";
      config.dbtype = "sqlite";
      database.createLocally = true;
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) richdocuments whiteboard notes;
      };
      configureRedis = true;
      package = pkgs.nextcloud34;
      settings.trusted_domains = ["localhost" "omen-nixos.reindeer-kettle.ts.net"];
    };
  };
}
