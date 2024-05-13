{ config, lib, pkgs, inputs, globals, ... }:

{

  home-manager.users.${globals.username} = {
    home.username = globals.username;
    home.homeDirectory = config.users.users.${globals.username}.home;

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
  };
}
