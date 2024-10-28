{ pkgs, username, ... }: {
  users.users.${username} = {
    home =
      if pkgs.stdenvNoCC.isDarwin
      then "/Users/${username}"
      else "/home/${username}";
  };
  imports = [
    ./core.nix
    ./brew.nix
  ];
}
