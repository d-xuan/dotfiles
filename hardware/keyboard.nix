{ config, lib, pkgs, ... }:

{
  services.xserver.xkb.options = "ctrl:swapcaps";
  console.useXkbConfig = true;
}
