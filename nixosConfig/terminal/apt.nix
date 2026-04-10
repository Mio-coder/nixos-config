{pkgs, ...}: {
  environment.etc = {
    "apt.conf".text = ''
      Apt::System "Debian dpkg interface";
      Dir::Bin::dpkg "${pkgs.dpkg}/bin/dpkg";
    '';
  };
  environment.variables = {
    APT_CONFIG = pkgs.lib.trace "/etc/apt.conf";
  };
}
