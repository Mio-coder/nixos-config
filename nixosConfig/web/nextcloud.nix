{
  config,
  pkgs,
  ...
}: {
  age.secrets.pass.file = ../../secrets/pass.age;
  environment.etc."nextcloud-admin-pass".source = config.age.secrets.pass.path;
  services.nextcloud = {
    enable = true;
    hostName = "localhost";
    config = {
      adminpassFile = "/etc/nextcloud-admin-pass";
      dbtype = "sqlite";
    };
    database.createLocally = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) richdocuments whiteboard;
    };
    configureRedis = true;
    package = pkgs.nextcloud34;
    settings.trusted_domains = ["localhost" "omen-nixos.reindeer-kettle.ts.net"];
  };
}
