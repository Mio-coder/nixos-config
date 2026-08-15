{...}: {
  # https://discourse.nixos.org/t/fix-ssl-sslcertverificationerror-with-uvs-standalone-python/71138
  # Fix uv python ssl.SSLCertVerificationError
  environment.etc.certfile = {
    source = "/etc/ssl/certs/ca-bundle.crt";
    target = "ssl/cert.pem";
  };
}
