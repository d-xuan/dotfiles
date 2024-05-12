let secrets = import ../secrets/secrets.nix;
in { config, lib, pkgs, ... }:

{
  users.users.wednesday = {
    isNormalUser = true;
    home = "/home/wednesday/";
    description = "wednesday";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = secrets.authorizedKeysUser;
    hashedPassword = secrets.hashedPasswordUser;
  };
}
