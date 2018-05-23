{ compiler ? import ./ghc.nix }:

let
  pkgs = import ./nixpkgs-pinned { };

  haskellPackages = pkgs.haskell.packages."${compiler}".override {
    overrides = new: old: {
      # Tests won't build because of tasty version requirements
      zlib-with-nix = pkgs.haskell.lib.dontCheck (old.callPackage ./.. {
        zlib = pkgs.zlib;
      });
    };
  };
in
  haskellPackages.zlib-with-nix
