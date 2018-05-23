{ compiler ? import ./ghc.nix }:

let
  pkgs = import ./nixpkgs-pinned {};

  project-root = import ./project-root.nix;

  hlib = pkgs.haskell.lib;

  withTestAndBench = drv: hlib.doCheck (hlib.doBenchmark drv);

  release = import ./release.nix { inherit compiler; };

  development = withTestAndBench release;
in
  development.env.overrideAttrs (old: rec {
    name = compiler + "-" + old.name;

    # Needed for cabal repl lib:zlib to find the library
    LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.zlib.out}/lib";

    buildInputs = [
      pkgs.zlib.dev # Needed for cabal build to find headers
      pkgs.git
      pkgs.vim
      pkgs.ncurses # Needed by the bash-prompt.sh script
      pkgs.haskellPackages.cabal-install
    ];

    shellHook = old.shellHook + builtins.readFile ./bash-prompt.sh + ''
      source ${pkgs.git.out}/etc/bash_completion.d/git-prompt.sh
      source ${pkgs.git.out}/etc/bash_completion.d/git-completion.bash
    '';
  })
