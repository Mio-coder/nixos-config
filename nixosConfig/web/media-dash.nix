{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.my.media.enable {
    services.nginx.virtualHosts."homer" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 8080;
        }
      ];
    };
    services.homer = {
      enable = true;
      virtualHost = {
        nginx.enable = true; # nextcloud already uses nginx
        domain = "homer";
      };
      settings = {
        title = "Media Dashboard";
        subtitle = "Arr Stack";
        documentTitle = "Media";
        header = true;
        footer = false;
        columns = "3";
        connectivityCheck = true;
        defaults = {
          layout = "columns";
          colorTheme = "auto";
        };
        theme = "default";
        links = [
          {
            name = "Jellyfin";
            icon = "fas fa-tv";
            url = "http://localhost:8096";
            target = "_blank";
          }
          {
            name = "qBittorrent";
            icon = "fas fa-download";
            url = "http://localhost:5252";
            target = "_blank";
          }
        ];
        services = [
          {
            name = "Media";
            icon = "fas fa-photo-video";
            items = [
              {
                name = "Jellyfin";
                subtitle = "Media server";
                icon = "fas fa-tv";
                tag = "media";
                tagstyle = "is-info";
                url = "http://localhost:8096";
                target = "_blank";
                keywords = "jellyfin media movies shows tv";
              }
            ];
          }
          {
            name = "Arr Stack";
            icon = "fas fa-film";
            items = [
              {
                name = "Sonarr";
                subtitle = "TV series management";
                icon = "fas fa-video";
                tag = "arr";
                tagstyle = "is-success";
                url = "http://localhost:8989";
                target = "_blank";
                keywords = "sonarr tv shows series arr";
              }
              {
                name = "Radarr";
                subtitle = "Movie management";
                icon = "fas fa-film";
                tag = "arr";
                tagstyle = "is-success";
                url = "http://localhost:7878";
                target = "_blank";
                keywords = "radarr movies films arr";
              }
              {
                name = "Prowlarr";
                subtitle = "Indexer management";
                icon = "fas fa-search";
                tag = "arr";
                tagstyle = "is-warning";
                url = "http://localhost:9696";
                target = "_blank";
                keywords = "prowlarr indexers trackers arr";
              }
              {
                name = "Bazarr";
                subtitle = "Subtitle management";
                icon = "fas fa-closed-captioning";
                tag = "arr";
                tagstyle = "is-success";
                url = "http://localhost:6767";
                target = "_blank";
                keywords = "bazarr subtitles arr";
              }
            ];
          }
          {
            name = "Downloads";
            icon = "fas fa-download";
            items = [
              {
                name = "qBittorrent";
                subtitle = "Torrent client";
                icon = "fas fa-download";
                tag = "downloads";
                tagstyle = "is-danger";
                url = "http://192.168.15.1:5252";
                target = "_blank";
                keywords = "qbittorrent torrent downloads";
              }
            ];
          }
          {
            name = "Virtal Machines";
            icon = "fas fa-server";
            items = [
              {
                name = "Windows";
                subtitle = "Windows vpn";
                icon = "fab fa-windows";
                tag = "host";
                tagstyle = "is-info";
                url = "http://172.30.0.2:8006/";
                target = "_blank";
                keywords = "windows host";
              }
            ];
          }
        ];
      };
    };
  };
}
