{ lib, ... }:
{
  options = {
    a = lib.mkOption { type = lib.types.submodule {
      options = {
        aa = lib.mkOption { type = lib.types.str; };
        ab = lib.mkOption { type = lib.types.int; };
      };
    }; };
  };
}
