# Nix config

## Start

### Pre

```bash
softwareupdate --install-rosetta --agree-to-license
xcode-select --install
```

### Build

> [!NOTE]
> First installation
>
> ```bash
> nix run nix-darwin -- --flake github:philingood/nix-config#darwinConfigurations.HackerBook.system
> ```

```bash
nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.HackerBook.system
```

```bash
./result/sw/bin/darwin-rebuild switch --flake .#HackerBook
```

### Post
