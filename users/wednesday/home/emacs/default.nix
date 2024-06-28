{ config, inputs, globals, lib, pkgs, ... }: {

  imports = [ ./doom.nix ];

  nixpkgs.overlays = [
    (final: prev: {
      emacs-wednesday = prev.emacs.overrideAttrs (oldAttrs: rec {
        name = "emacs-30.0.50";
        version = "30.0.50";

        src = prev.fetchFromGitHub {
          owner = "emacs-mirror";
          repo = "emacs";
          rev = "42fba8f36b19536964d6deb6a34f3fd1c02b43dd";
          sha256 = "sha256-73IXekYzgYNuYeFGAQBJHuO16AfDrhFI1CCpw+UhJl8=";
        };

        configureFlags = oldAttrs.configureFlags
          ++ [ "--with-json" "--with-tree-sitter" "--with-native-compilation" ];

        buildInputs = oldAttrs.buildInputs
          ++ (with final; [ jansson tree-sitter ]);
      });
    })
  ];

  home-manager.users.${globals.username} = {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-wednesday;
    };

  };
}
