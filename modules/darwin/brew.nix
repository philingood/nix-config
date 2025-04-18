{ ...
}: {
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall"; # should maybe be "zap" - remove anything not listed here
    };
    global = {
      brewfile = true;
      autoUpdate = true;
    };
    taps = [
      "homebrew/core"
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/services"
    ];
    casks = [
      {
        name = "alt-tab";
        greedy = true;
      }
      {
        name = "appcleaner";
        greedy = true;
      }
      {
        name = "arc";
        greedy = true;
      }
      {
        name = "audacity";
        greedy = true;
      }
      {
        name = "avidemux";
        greedy = true;
      }
      {
        name = "betterdisplay";
        greedy = true;
      }
      "burp-suite" # TODO: move to home-manager? (burpsuite)
      #"bitwarden" # Using mas vertion
      {
        name = "chatgpt";
        greedy = true;
      }
      "choosy" # multi-browser url launch selector; see also https://github.com/johnste/finicky
      {
        name = "dbeaver-community";
        greedy = true;
      }
      {
        name = "discord";
        greedy = true;
      }
      #"docker" # removed in favor of colima + docker cli
      {
        name = "balenaetcher";  # tool for make bootable usb drives
        greedy = true;
      }
      {
        name = "firefox@developer-edition";
        greedy = true;
      }
      "freetube" # trying out private youtube browsing after reading about how toxic their algo is
      {
        name = "ghostty";
        greedy = true;
      }
      {
        name = "github";
        greedy = true;
      }
      {
        name = "gpg-suite";
        greedy = true;
      }
      {
        name = "heroic";
        greedy = true;
      }
      {
        name = "httpie";
        greedy = true;
      }
      {
        name = "istat-menus";
        greedy = false;
      }
      {
        name = "iterm2";
        greedy = true;
      }
      {
        name = "karabiner-elements";
        greedy = true;
      }
      {
        name = "kitty";
        greedy = true;
      }
      "keycastr"
      {
        name = "librewolf";
        greedy = true;
      }
      {
        name = "lm-studio";
        greedy = true;
      }
      {
        name = "macfuse";
        greedy = true;
      }
      {
        name = "mactex-no-gui";
        greedy = true;
      }
      {
        name = "mathpix-snipping-tool";
        greedy = true;
      }
      "mpv"
      {
        name = "nextcloud";
        greedy = true;
      }
      {
        name = "ngrok";
        greedy = true;
      }
      {
        name = "ntfstool";
        greedy = true;
      }
      {
        name = "obs"; # TODO: move to nix version obs-studio when not broken
        greedy = true;
      }
      {
        name = "obsidian";
        greedy = true;
      }
      {
        name = "onyx";
        greedy = true;
      }
      {
        name = "openlens";
        greedy = true;
      }
      {
        name = "orbstack";
        greedy = true;
      }
      {
        name = "outline-manager";
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
      # "qt-creator"
      {
        name = "radio-silence";
        greedy = true;
      }
      "raycast"
      # "simpletex" # Failed to download
      "skim"
      {
        name = "stolendata-mpv";
        greedy = true;
      }
      "swiftdefaultappsprefpane"
      {
        name = "syncthing"; # TODO: move to home-manager
        greedy = true;
      }
      {
        name = "telegram";
        greedy = true;
      }
      {
        name = "termius";
        greedy = true;
      }
      "the-unarchiver"
      #"topaz-photo-ai"
      #"topaz-video-ai"
      {
        name = "tor-browser";
        greedy = true;
      }
      {
        name = "tradingview";
        greedy = true;
      }
      {
        name = "transmission";
        greedy = true;
      }
      # "$HOME/nix-config/modules/darwin/vscode.rb" # FIXME: this doesn't work. I want to use specific version of vscode. See https://code.visualstudio.com/docs/supporting/faq#_previous-release-versions
      {
        name = "whisky";
        greedy = true;
      }
      {
        name = "yandex-music";
        greedy = true;
      }

      # Keeping the next three together as they act in concert and are made by the same guy
      # FIXME: This is PAY TO PLAY. So i need an ultimate solution!
      # "kindavim" # ctrl-esc allows you to control an input area as if in vim normal mode
      # "scrolla" # use vim commands to select scroll areas and scroll
      # "wooshy" # use cmd-shift-space to bring up search to select interface elements in current app
    ];
    masApps = {
      "Apple Configurator 2" = 1037126344;
      "bitwarden" = 1352778147;
      "DeTeXt" = 1531906207;
      "Enchanted LLM" = 6474268307;
      "Mattermost Desktop" = 1614666244;
      "Windows app" = 1295203466;
      #"Microsoft Excel" = 462058435;
      #"Microsoft Word" = 462054704;
      #"Microsoft PowerPoint" = 462062816;
      "ServerCat - SSH Terminal" = 1501532023;
      "Velja" = 1607635845;
      "Vimari" = 1480933944;
      "WireGuard" = 1451685025;
      "Xcode" = 497799835;
    };
    brews = [
      "adwaita-icon-theme"
      "aom"
      "ansible"
      "sshpass"
      "aribb24"
      "at-spi2-core"
      "brightness"
      "ca-certificates"
      "chkrootkit"
      "choose-gui"
      "ddcctl"
      "hashcat"
      "helm"
      "hydra"
      "ical-buddy"
      "latexindent"
      "node"
      "p0f"
      "qt"
      "recon-ng"
      "whisper-cpp"
      "whisperkit-cli"
      "yt-dlp"
    ];
  };
}
