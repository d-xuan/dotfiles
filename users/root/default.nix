{ config, lib, pkgs, globals, ... }:

{
  users.users.root.openssh.authorizedKeys.keys =
    globals.secrets.authorizedKeysRoot;
}
