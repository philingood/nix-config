# Nix config

## Start

### Pre

```bash
softwareupdate --install-rosetta --agree-to-license
```

### Build

```bash
nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.HackerBook.system
```

```bash
./result/sw/bin/darwin-rebuild switch --flake .#HackerBook
```

### Post
