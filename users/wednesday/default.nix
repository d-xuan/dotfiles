{ config, lib, pkgs, globals, ... }:

{
  imports = [ ./home ];

  users.users.wednesday = {
    isNormalUser = true;
    home = "/home/wednesday/";
    description = "wednesday";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = globals.secrets.authorizedKeysUser;
    hashedPassword = globals.secrets.hashedPasswordUser;
  };
}
