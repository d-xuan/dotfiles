{ modulesPath, config, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  services.openssh.enable = true;
  # Make /boot root-readable only so users are unable to read random-seed.
  fileSystems."/boot" = {
    options = [ "uid=0" "gid=0" "fmask=0077" "dmask=0077" ];
  };

  environment.systemPackages = map lib.lowPrio [ pkgs.curl pkgs.gitMinimal ];

  users.users.root.openssh.authorizedKeys.keys =
    import ./secrets/authorized-keys.nix;

  system.stateVersion = "23.11";
}
