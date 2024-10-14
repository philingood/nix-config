{ pkgs, ... }: {
# here go the darwin preferences and config items
  networking.hostName = "9089";
  security.pam.enableSudoTouchIdAuth = true;


  programs.zsh.enable = true;
  environment = {
    shells = with pkgs; [ bash zsh ];
    loginShell = pkgs.zsh;
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/opt/homebrew/bin" ];
    pathsToLink = [ "/Applications" ];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    '';

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  # fonts.fontDir.enable = true; # DANGER
  # fonts.fonts = [ (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; }) ];
  services.nix-daemon.enable = true;

  system.defaults = {
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.InitialKeyRepeat = 14;
    NSGlobalDomain.KeyRepeat = 1;
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
    NSGlobalDomain.InitialKeyRepeat = 10;
    NSGlobalDomain.KeyRepeat = 1;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    NSGlobalDomain.NSTableViewDefaultSizeMode = 2;
    NSGlobalDomain.NSWindowShouldDragOnGesture = true;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;  # 1 - tap to click

    dock.autohide = true;
    dock.expose-animation-duration = 0.25;
    dock.expose-group-by-app = true;
    dock.mru-spaces = false;  # false = do not automatically rearrange spaces based on most recent use
    dock.persistent-apps =
      [
        "/System/Applications/System Settings.app/"
        "/Applications/OnyX.app/"
        "/Applications/nekoray_arm64.app/"
        "/System/Applications/Utilities/Terminal.app"
        "/Applications/iTerm.app/"
        "/Applications/Visual Studio Code.app/"
        "/Applications/Arc.app/"
        "/Applications/Safari.app/"
        "/Applications/Firefox Developer Edition.app/"
        "/System/Applications/Music.app/"
      ];
    dock.persistent-others =
      [
        "~/Downloads/"
        "~/Pictures/Screenshots/"
      ];
    dock.tilesize = 32;
    dock.showhidden = true;
    dock.wvous-bl-corner = 1;
    dock.wvous-br-corner = 4;
    dock.wvous-tl-corner = 10;
    dock.wvous-tr-corner = 1;

    finder.AppleShowAllExtansions = true;
    finder.FXDefaultSearchScope = "SCcf";
    finder.FXPreferredViewStyle = "clmv";

    system.defaults.finder._FXSortFoldersFirst = true;
    loginwindow.GuestEnabled = false;
    menuExtraClock.IsAnalog = true;
    screencapture.location = "~/Pictures/Screenshots/";

    trackpad.Clicking = true;
    trackpad.FirstClickThreshold = 0;
    trackpad.SecondClickThreshold = 1;
    trackpad.TrackpadRightClick = true;

    WindowManager.EnableStandardClickToShowDesktop = false;
    alf.globalstate = 1;
  };

# backwards compat; don't change
  system.stateVersion = 4;
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = { };
    casks = [
      ./casks.txt
    ];
    taps = [  ];
    brews = [  ];
  };
}
{ pkgs, ... }: {
  imports = [
    ../common.nix
    ./pam.nix
    ./core.nix
    ./brew.nix
    ./preferences.nix
  ];
}
