## 1. Create package
```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.tofi.overrideAttrs (oldAttrs: {
  src = ./.;
})
```
```sh
nix-build
```

## 2. Create devshell

```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  inputsFrom = [
    pkgs.tofi
  ];
}
```
