{pkgs, ...}: {
  home.packages = with pkgs; [
    (pkgs.writeScriptBin "lkick" ''
      #!${lib.getExe' pkgs.python314 "python"}
      from subprocess import run
      from pathlib import Path

      url = run(["playerctl", "metadata", "xesam:url"], check=True, capture_output=True, text=True).stdout.strip()
      run(["playerctl", "next"], check=True)
      print(url)
      path = Path.from_uri(url)
      move_to = path.parent.parent / "lofi_kick"
      path.move_into(move_to)
    '')
  ];
}
