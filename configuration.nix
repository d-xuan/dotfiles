{ modulesPath, config, lib, pkgs, ... }: {
  imports = [ ./hardware ./user ./display-server ];

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [ pkgs.curl pkgs.gitMinimal ];

  system.stateVersion = "23.11";
}
