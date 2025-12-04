{pkgs, ...}: {
  services.clipcat = {
    enable = true;
    daemonSettings = {
      daemonize = true;
      max_history = 50;
      primary_threshold_ms = 5000;
      log = {
        emit_journald = true;
        emit_stdout = true;
        emit_stderr = false;
        level = "INFO";
      };
      watcher = {
        enable_clipboard = true;
        enable_primary = true;
        sensitive_mime_types = ["x-kde-passwordManagerHint"];
        # Ignore text clips that match any of the provided regular expressions.
        # The regular expression engine is powered by https://github.com/rust-lang/regex.
        denied_text_regex_patterns = [];
        filter_text_min_length = 1;
        filter_text_max_length = 1000000000; # 1GB
        capture_image = true;
        filter_image_max_size = 1000000000; # 1GB
      };
      grpc = {
        # Enable gRPC over Unix domain socket.
        enable_local_socket = true;
      };
      dbus = {
        enable = true;
      };
      desktop_notification = {
        enable = true;
        icon = pkgs.fetchurl {
          url = "https://upload.wikimedia.org/wikipedia/commons/5/59/Empty.png";
          hash = "sha256-fp3BahkoX8bJQk+R8XHRUhLIzNzXm0hag75gkr98Cwk=";
        };
        timeout_ms = 2000;
        long_plaintext_length = 2000;
      };
    };
    ctlSettings = {
      log = {
        emit_journald = true;
        emit_stdout = true;
        emit_stderr = false;
        level = "INFO";
      };
    };
    menuSettings = {
      finder = "custom";
      log = {
        emit_journald = true;
        emit_stdout = false;
        emit_stderr = false;
        level = "INFO";
      };
      custom_finder = {
        program = "tofi";
        args = [
          "--prompt-text"
          "clipboard"
        ];
      };
    };
  };
  wayland.windowManager.sway.extraConfig = ''
    bindsym $mod+c exec clipcat-menu
  '';
}
