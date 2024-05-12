{ config, lib, ... }: {
  imports = [ ./root.nix ./user.nix ];

  users.mutableUsers = false;
}
