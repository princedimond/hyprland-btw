{
  pkgs,
  lib,
  ...
}: let
  # Define the logic once so it's easy to toggle
  dockerEnabled = true;
  podmanEnabled = !dockerEnabled; # Automatically stays opposite of docker
in {
  # Only enable either docker or podman -- Not both
  virtualisation = {
    docker = {
      enable = dockerEnabled;
    };

    podman = {
      enable = podmanEnabled;
      dockerCompat = true;
    };

    libvirtd = {
      enable = true;
    };
  };

  programs = {
    virt-manager.enable = false;
  };

  environment.systemPackages = with pkgs;
    [
      ctop
      docker-client
      docker-compose
      dry
      lazydocker
      lazyjournal
      oxker
      virt-viewer
    ]
    ++ lib.optional podmanEnabled pkgs.podman-docker;
}
