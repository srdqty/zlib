# Compiling a haskell project that requires zlib with nix

## Initialization

This script generates the information necessary for pinning nixpkgs to a known
commit. Useful for reproducible builds. This tends to take a while because
the nixpkgs repo is pretty large. Should only need to run this once unless you
want to change to a different commit sha.

```
nix-shell --pure nix/scripts/generate-nixpkgs-json.nix
```


This script generates default.nix file from the cabal file.
Rerun this whenever you update the cabal file.

```
nix-shell --pure nix/scripts/generate-nix-file.nix
```

## Development

The purpose of this environment is to make available everything that your project
needs to compile, while leaving the project itself unbuilt. Then you can work on
your project and build it using cabal.

```
# Enter the development environment

nix-shell --pure nix/development.nix
```

```
cabal build
```

### Repl

```
# Enter the development environment

nix-shell --pure nix/development.nix
```

```
# In the context of the library build target

cabal repl lib:zlib
```

### Running Tests

```
# Enter the development environment

nix-shell --pure nix/development.nix
```

```
cabal test
```

### Without entering the development environment

```
nix-shell --pure nix/development.nix --run 'cabal build'
nix-shell --pure nix/development.nix --run 'cabal repl lib:zlib'
nix-shell --pure nix/development.nix --run 'cabal test'
```

## Release Build

```
# Build the package

nix-build nix/release.nix

The built executable and library will be placed in ./result
```

## Different compiler versions

You can either edit `nix/ghc.nix` or specify a compiler version at the command
line as demonstrated below.

```
nix-shell --pure nix/development.nix --argstr compiler ghc802
nix-shell --pure nix/release.nix --argstr compiler ghc802
```
