{ config, lib, pkgs, globals, ... }:

{
  home-manager.users.${globals.username} = {
    home.sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      EMACSDIR = "${config.xdg.configHome}/emacs";
      DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
      DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles.load.el";
    };
    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

    # Note! This must correspond to $EMACSDIR
    xdg.configFile."emacs".source = builtins.fetchGit {
      url = "https://github.com/doomemacs/doomemacs.git";
      rev = "42ae401deb7c39a72c6e24bd899abab9c10a687c";
    };

    xdg.configFile."doom".source = ./doom;
  };
}
