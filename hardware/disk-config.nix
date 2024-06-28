{ lib, ... }: {
  disko.devices = {
    disk = {
      vdb = {
        device = "/dev/disk/by-id/ata-KINGSTON_SUV400S47120G_50026B776A012FCE";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              end = "-1G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            plainSwap = {
              size = "100%";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
          };
        };
      };
    };
  };

  boot.loader.systemd-boot.enable = true;
  fileSystems."/boot" = {
    options = [ "uid=0" "gid=0" "fmask=0077" "dmask=0077" ];
  };

}
