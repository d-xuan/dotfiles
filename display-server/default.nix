{ config, lib, pkgs, ... }:

{
  programs.sway.enable = true;
  xdg.portal.wlr.enable = true;
  environment.systemPackages = [ pkgs.foot ];
}
