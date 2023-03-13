{ disks ? [ "/dev/vdb" "/dev/vdc" ], ... }: {
  disk = {
    x = {
      type = "disk";
      device = builtins.elemAt disks 0;
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            type = "partition";
            name = "ESP";
            start = "1MiB";
            end = "1GiB";
            fs-type = "fat32";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            type = "partition";
            name = "zfs";
            start = "1GiB";
            end = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          }
        ];
      };
    };
  };
  rpool = {
    rpool = {
      type = "zpool";
      mode = "mirror";
      rootFsOptions = {
        compression = "lz4";
        "com.sun:auto-snapshot" = "false";
      };

      datasets = {
        # Root dataset
        # So that encryption only needs one password entry
        "nixos" = {
          zfs_type = "filesystem";
          options.mountpoint = "none";
          # TODO ENCRYPTION
        }


        # Parent datasets
        ## Data not to be backed up and can be generated
        "nixos/local" = {
          zfs_type = "filesystem";
          options.mountpoint = "none";
        }

        ## Data to keep between boots and can't be generated
        "nixos/persist" = {
          zfs_type = "filesystem";
          options.mountpoint = "/persist";
        }


        # Mountable datasets in local
        ## Wipable root
        "nixos/local/root" = {
          zfs_type = "filesystem";
          options.mountpoint = "none";
        }

        ## Store /nix deperatly from root to cache compilations
        "nixos/local/nix" = {
          zfs_type = "filesystem";
          options.mountpoint = "none";
        }






        local = {
          zfs_type = "filesystem";
          options."com.sun:auto-snapshot" = "true";
        };
        nix = {
          zfs_type = "filesystem";
        };
        root = {
          options.mountpoint = "legacy";
          zfs_type = "filesystem";
          mountpoint = "/zfs_legacy_fs";
        };
        persist = {
          zfs_type = "filesystem";
          options.mountpoint = "legacy";
          mountpoint = "/zfs_legacy_fs";
        };
      };
    };
  };
}
