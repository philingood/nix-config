{
  inputs,
  config,
  pkgs,
  ...
}: {
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "uninstall"; # should maybe be "zap" - remove anything not listed here
    };
    global = {
      brewfile = true;
      autoUpdate = false;
    };

    taps = [
      "homebrew/core"
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/services"
    ];

    casks = [
      {
        name = "amethyst";
        greedy = true;
      }
      {
        name = "chatgpt";
        greedy = true;
      }
      "choosy" # multi-browser url launch selector; see also https://github.com/johnste/finicky
      {
        name = "discord";
        greedy = true;
      }
      #"docker" # removed in favor of colima + docker cli
      {
        name = "firefox@developer-edition";
        greedy = true;
      }
      "freetube" # trying out private youtube browsing after reading about how how toxic their algo is
      {
        name = "gpg-suite";
        greedy = true;
      }
      {
        name = "istat-menus";
        greedy = false;
      }
      "keycastr"
      "mpv"
      "metasploit" # TODO 2024-07-31 nix version not running on mac
      {
        name = "obs"; # TODO: move to nix version obs-studio when not broken
        greedy = true;
      }
      "qflipper"
      "qutebrowser" # TODO: move over when it builds on arm64 darwin
      {
        name = "qlmarkdown";
        greedy = true;
      }
      "qlstephen"
      "qlvideo"
      # { # moving to nix pkgs version
      #   name = "raycast";
      #   greedy = true;
      # }
      "swiftdefaultappsprefpane"
      {
        name = "syncthing"; # TODO: move to home-manager
        greedy = true;
      }
      {
        name = "tor-browser"; # TODO: move to home-manager (tor-browser-bundle-bin) when it builds
        greedy = true;
      }
      {
        name = "transmission";
        greedy = true;
      }
      "burp-suite" # TODO: move to home-manager? (burpsuite)

      # Keeping the next three together as they act in concert and are made by the same guy
      "kindavim" # ctrl-esc allows you to control an input area as if in vim normal mode
      "scrolla" # use vim commands to select scroll areas and scroll
      "wooshy" # use cmd-shift-space to bring up search to select interface elements in current app
    ];

    masApps = {
      "Apple Configurator 2" = 1037126344;
      "Blurred" = 1497527363; # dim non-foreground windows
      "Microsoft Excel" = 462058435;
      "Microsoft Word" = 462054704;
      "Microsoft PowerPoint" = 462062816;
      "Monodraw" = 920404675; # ASCII drawings
      "Vimari" = 1480933944;
      # "Vinegar" = 1591303229;
      "WireGuard" = 1451685025;
      # "Xcode" = 497799835;
      # "Yubico Authenticator" = 1497506650;
    };
    brews = [
      "ansiweather"
      "brightness"
      "ca-certificates"
      "chkrootkit" # TODO: moved here 2024-03-25 since nix version is broken
      "choose-gui"
      "ciphey"
      "ddcctl"
      "ical-buddy"
      "recon-ng" # TODO nix version doesn't work on mac at last try 2024-07-31
      "whisper-cpp"
      "whisperkit-cli"
      # would rather load these as part of a security shell, but...
      "hashcat" # the nix one only builds on linux
      "hydra" # the nix one only builds on linux
      "p0f" # the nix one only builds on linux
      "yt-dlp" # youtube downloader
    ];
  };
}
