{
  services.k3s = {
    enable = true;
    role = "server";

    nodeIP = "192.168.1.100";

    disable = [
      "traefik"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    22 # SSH
    53 # Pi-hole DNS TCP
    443 # Pi-hole HTTPS
    6443 # Kubernetes API
  ];

  networking.firewall.allowedUDPPorts = [
    53 # Pi-hole DNS UDP
    67
    8472 # Flannel VXLAN
  ];
}
