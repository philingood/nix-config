{ pkgs, username, ... }: {
  users.users.${username} = {
    home =
      if pkgs.stdenvNoCC.isDarwin
      then "/Users/${username}"
      else "/home/${username}";
  };
  imports = [
    ./pam.nix # enableSudoTouchIdAuth is now in nix-darwin, but without the reattach stuff for tmux
    ./core.nix
    ./brew.nix
    ./preferences.nix
  ];
}
