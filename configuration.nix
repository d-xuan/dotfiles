{ inputs, lib, pkgs, ... }: {
  imports = [ ./hardware ./users ./display-server ];

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [ pkgs.curl pkgs.gitMinimal ];

  system.stateVersion = "23.11";
}
