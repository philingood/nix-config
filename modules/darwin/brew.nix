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
      "alt-tab"
      "anydesk"
      "appcleaner"
      "arc"
      "audacity"
      "avidemux"
      "betterdisplay"
      "burp-suite" # TODO: move to home-manager? (burpsuite)
      # "bitwarden" # Using mas vertion
      "calibre"
      # "citrix-workspace"
      "chatgpt"
      # "choosy" # multi-browser url launch selector; see also https://github.com/johnste/finicky
      "cursor"
      "dbeaver-community"
      "discord"
      #"docker" # removed in favor of colima + docker cli
      "balenaetcher"  # tool for make bootable usb drive
      "firefox@developer-edition"
      "freetube" # trying out private youtube browsing after reading about how toxic their algo is
      "ghostty"
      "github"
      "gpg-suite"
      "hammerspoon"
      "heroic"
      "homerow"
      "httpie"
      # "hugin" # does not work on apple silicon
      "inkscape"
      "istat-menus"
      "iterm2"
      "jellyfin-media-player"
      "karabiner-elements"
      "kitty"
      "keycastr"
      "librewolf"
      "lm-studio"
      "macfuse"
      "mactex-no-gui"
      "mathpix-snipping-tool"
      "mpv"
      "nextcloud-vfs"
      "nextcloud-talk"
      "ngrok"
      "ntfstool"
      "obs" # TODO: move to nix version obs-studio when not broke
      "obsidian"
      # "onyx" #TODO: enable when brew will support macOS 26
      "openlens"
      "openvpn-connect"
      "orbstack"
      "outline-manager"
      "qflipper"
      "qutebrowser" # TODO: move over when it builds on arm64 darwin
      "qlmarkdown"
      "qlstephen"
      "qlvideo"
      # "qt-creator"
      "radio-silence"
      "raycast"
      # "simpletex" # Failed to download
      "skim"
      "steam"
      "stolendata-mpv"
      "swiftdefaultappsprefpane"
      "syncthing" # TODO: move to home-manager
      "telegram"
      "termius"
      "the-unarchiver"
      #"topaz-photo-ai"
      #"topaz-video-ai"
      "tor-browser"
      "tradingview"
      "transmission"
      # "$HOME/nix-config/modules/darwin/vscode.rb" # FIXME: this doesn't work. I want to use specific version of vscode. See https://code.visualstudio.com/docs/supporting/faq#_previous-release-versions
      "whisky"
      "yandex-music"

      # Keeping the next three together as they act in concert and are made by the same guy
      # FIXME: This is PAY TO PLAY. So i need an ultimate solution!
      # "kindavim" # ctrl-esc allows you to control an input area as if in vim normal mode
      # "scrolla" # use vim commands to select scroll areas and scroll
      # "wooshy" # use cmd-shift-space to bring up search to select interface elements in current app
    ];
    masApps = {
      # "Apple Configurator 2" = 1037126344;
      # "bitwarden" = 1352778147;
      # "DeTeXt" = 1531906207;
      # "Enchanted LLM" = 6474268307;
      # "Mattermost Desktop" = 1614666244;
      # "Windows app" = 1295203466;
      #"Microsoft Excel" = 462058435;
      #"Microsoft Word" = 462054704;
      #"Microsoft PowerPoint" = 462062816;
      # "ServerCat - SSH Terminal" = 1501532023;
      # "Velja" = 1607635845;
      # "Vimari" = 1480933944;
      # "WireGuard" = 1451685025;
      # "Xcode" = 497799835;
    };
    brews = [
      "adwaita-icon-theme"
      # "aom"
      "ansible"
      "sshpass"
      "aribb24"
      "at-spi2-core"
      "bob"
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
      "teleport"
      "terminal-notifier"
      "whisper-cpp"
      "whisperkit-cli"
      "yt-dlp"
    ];
  };
}
