{ config, lib, pkgs, globals, ... }:

{
  home-manager.users.${globals.username} = {
    xdg.configFile."emacs".source = builtins.fetchGit {
      url = "https://github.com/doomemacs/doomemacs.git";
      rev = "42ae401deb7c39a72c6e24bd899abab9c10a687c";
    };

    xdg.configFile."doom".source = ./doom;
  };
}
