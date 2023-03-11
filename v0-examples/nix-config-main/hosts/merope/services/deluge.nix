{ lib, config, ... }: {
  services = {
    deluge = {
      enable = true;
      web = {
        enable = true;
      };
    };
    nginx.virtualHosts = {
      "deluge.m7.rs" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://localhost:${toString config.services.deluge.web.port}";
      };
    };
  };

  networking.firewall = {
    # Remote control port (not port forwarded)
    allowedTCPPorts = [ 58846 ];
    allowedUDPPorts = [ 58846 ];
    # Torrent connection ports (port forwarded)
    allowedTCPPortRanges = [{ from = 6880; to = 6890; }];
    allowedUDPPortRanges = [{ from = 6880; to = 6890; }];
  };

  environment.persistence = {
    "/persist".directories = [
      "/var/lib/deluge"
      "/srv/torrents"
    ];
  };
}
