{ modulesPath, config, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware
    ./user
  ];

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [ pkgs.curl pkgs.gitMinimal ];

  system.stateVersion = "23.11";
}
