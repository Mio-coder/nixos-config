{
  pkgs,
  config,
  lib,
  ...
}: {
  options.my.dm =
    (lib.mkEnableOption "display manager")
    // {
      default = true;
    };
  config = lib.mkMerge [
    (lib.mkIf config.my.dm {
      environment.systemPackages = with pkgs; [
        void-sddm
      ];

      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "voidsddm";
      };
    })
    (lib.mkIf (config.my.dm == false) {
      services.greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = "${pkgs.sway}/bin/sway";
            user = "mio";
          };
          default_session = initial_session;
        };
      };
    })
  ];
}
