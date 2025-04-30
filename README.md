# Nix config

## Setup

### Nix

### Darwin

#### Pre

```bash
softwareupdate --install-rosetta --agree-to-license
xcode-select --install && cd && git clone --recurse-submodules https://github.com/philingood/nix-config.git
```

#### Build

> [!NOTE]
> First installation
>
> ```bash
> nix run nix-darwin -- --flake github:philingood/nix-config#darwinConfigurations.$(hostname -s).system
> ```

```bash
nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.$(hostname -s).system
```

```bash
./result/sw/bin/darwin-rebuild switch --flake .#$(hostname -s)
```

#### Post
