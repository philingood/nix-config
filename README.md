# Nix config

## Setup

### Nix

### Darwin

#### Pre

```bash
softwareupdate --install-rosetta --agree-to-license
```

```bash
xcode-select --install
```

Install Nix (flakes aren't enabled by default, hence `--extra-experimental-features` below):

```bash
sh <(curl -L https://nixos.org/nix/install)
```

Must match a `darwinConfigurations` entry in `flake.nix` (currently `9089`, `9099`) — add a new one for a new machine:

```bash
sudo scutil --set HostName <hostname>
```

```bash
cd
git clone https://github.com/philingood/nix-config.git
```

```bash
git clone https://github.com/philingood/dotfiles.git
```

> [!NOTE]
> Easy to forget, not managed by nix:
> - SSH key added to your GitHub account (needed to `git push`, both repos above are cloned over https so this isn't a hard blocker yet)
> - GPG key imported (`gpg-suite` gets installed, but the key itself isn't)
> - Nextcloud client logged in and synced to `~/nc` (see Local config below — screenshot location depends on it)
> - create `~/.config/nix-config-local.nix`, see Local config below

#### Build

```bash
cd ~/nix-config
```

`darwin-rebuild` isn't installed/in PATH yet on a fresh machine — building first and invoking it straight out of `./result` sidesteps that, so this works for both first install and every switch after:

```bash
nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.$(hostname -s).system
```

```bash
./result/sw/bin/darwin-rebuild switch --flake .#$(hostname -s) --impure
```

#### Post

```bash
sudo xcodebuild -license accept
```

```bash
nix-index
```

### Local config (per-machine, not in git)

Private per-machine values (currently just screenshot location) live in `~/.config/nix-config-local.nix`, read by `modules/darwin/preferences.nix`. Not part of the repo, so it has to be recreated on each machine:

```nix
{
  screenshotLocation = "~/nc/Photos/Screenshots/";
}
```

Requires `--impure` (baked into the `dwsw` alias, but needed manually on first switch, see above).

### dotfiles

Karabiner and Ghostty configs are *not* managed by this repo — they're frequently live-edited (Karabiner via its own GUI), so they're stowed from [dotfiles](https://github.com/philingood/dotfiles) instead (cloned in Pre above):

```bash
cd ~/dotfiles
```

```bash
./setup.sh
```
