{
  config,
  pkgs,
  ...
}: {
  services.tailscale.enable = true;

  #   services.resolved.enable = true;

  #   systemd.services."split-dns-sio2" = {
  #     description = "Split DNS for sio2.staszic.waw.pl via router DNS on wlo1";
  #     after = [
  #       "network-online.target"
  #       "systemd-resolved.service"
  #       "tailscaled.service"
  #     ];
  #     wants = ["network-online.target"];
  #     serviceConfig = {
  #       Type = "oneshot";
  #     };
  #     script = ''
  #       set -euo pipefail

  #       IFACE="wlo1"
  #       DOMAIN="sio2.staszic.waw.pl"

  #       # Use the IPv4 default gateway on wlo1 as "router DNS" (common home/office setup).
  #       # If your router provides a different DNS IP than its gateway address,
  #       # replace ROUTER_DNS assignment with a fixed IP.
  #       ROUTER_DNS="$(${pkgs.iproute2}/bin/ip -4 route show default dev "$IFACE" 2>/dev/null | ${pkgs.gawk}/bin/awk '{print $3; exit}')"

  #       if [ -z "''${ROUTER_DNS:-}" ]; then
  #         echo "split-dns-sio2: no default gateway found on $IFACE; nothing to do."
  #         exit 0
  #       fi

  #       echo "split-dns-sio2: routing ''${DOMAIN} to DNS ''${ROUTER_DNS} on ''${IFACE}"

  #       # Set per-link DNS server (used only when a routing domain matches).
  #       ''${pkgs.systemd}/bin/resolvectl dns "$IFACE" "$ROUTER_DNS"

  #       # Route only this domain (and its subdomains) to that link's DNS.
  #       # The "~" makes it a routing-only domain (split DNS), not a search domain.
  #       ''${pkgs.systemd}/bin/resolvectl domain "$IFACE" "~$DOMAIN"

  #       # Optional: ensure we don't keep stale answers around.
  #       ''${pkgs.systemd}/bin/resolvectl flush-caches || true
  #     '';
  #   };

  #   # Re-apply periodically to survive wifi reconnects / DHCP changes.
  #   systemd.timers."split-dns-sio2" = {
  #     description = "Periodically enforce split DNS for sio2.staszic.waw.pl";
  #     wantedBy = ["timers.target"];
  #     timerConfig = {
  #       OnBootSec = "30s";
  #       OnUnitActiveSec = "5m";
  #       Unit = "split-dns-sio2.service";
  #     };
  #   };
}
