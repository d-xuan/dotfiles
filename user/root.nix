let secrets = import ../secrets/secrets.nix;
in { config, lib, pkgs, ... }:

{
  users.users.root.openssh.authorizedKeys.keys = secrets.authorizedKeysRoot;
}
