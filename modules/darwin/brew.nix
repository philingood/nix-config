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
      # "homebrew-zathura/zathura" # fallback tap for zathura, in case pkgs.stable.zathura (home-manager) ever breaks too.
      # Also needs registering in flake.nix's nix-homebrew.taps to reactivate (mutableTaps = false there).
    ];
    casks = [
      #"alt-tab"
      #"anydesk"
      "appcleaner"
      #"arc"
      "audacity"
      "avidemux"
      "betterdisplay"
      "burp-suite" # TODO: move to home-manager? (burpsuite)
      # "bitwarden" # Using mas vertion
      "calibre"
      # "citrix-workspace"
      "chatgpt"
      # "choosy" # multi-browser url launch selector; see also https://github.com/johnste/finicky
      "claude"
      "claude-code"
      "cursor"
      "dbeaver-community"
      "discord"
      #"docker" # removed in favor of colima + docker cli
      "balenaetcher"  # tool for make bootable usb drive
      #"firefox@developer-edition"
      "freecad"
      #"freetube" # trying out private youtube browsing after reading about how toxic their algo is
      "ghostty"
      #"github"
      "gpg-suite"
      "hammerspoon"
      "heroic"
      "homerow"
      #"httpie-desktop"
      # "hugin" # does not work on apple silicon
      "inkscape"
      #"istat-menus"
      "iterm2"
      "font-liberation"
      #"jellyfin-media-player"
      "karabiner-elements"
      #"kitty"
      "keycastr"
      "librewolf"
      "lm-studio"
      # "macfuse"
      # "mactex-no-gui"
      "mathpix-snipping-tool"
      "nextcloud-vfs"
      "nextcloud-talk"
      "ngrok"
      "ntfstool"
      "obs" # TODO: move to nix version obs-studio when not broke
      "obsidian"
      # "onyx" #TODO: enable when brew will support macOS 26
      #"openlens"
      "openvpn-connect"
      "orbstack"
      #"outline-manager"
      "qflipper"
      #"qutebrowser" # TODO: move over when it builds on arm64 darwin
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
      "syncthing-app" # TODO: move to home-manager
      "telegram"
      "termius"
      "the-unarchiver"
      #"topaz-photo-ai"
      #"topaz-video-ai"
      "tor-browser"
      #"tradingview"
      #"transmission"
      "whisky"
      "yandex-music"
      # "zotero"
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
      "goreleaser"
      "hashcat"
      "helm"
      "hydra"
      "ical-buddy"
      "latexindent"
      "node"
      "p0f"
      "qt"
      "qwen-code"
      "recon-ng"
      "spoofdpi"
      "teleport"
      "terminal-notifier"
      "tesseract"
      "tesseract-lang"
      "tree-sitter-cli"
      "typst"
      "uv"
      "whisper-cpp"
      "whisperkit-cli"
      "yt-dlp"
      # "homebrew-zathura/zathura/zathura" # fallback for zathura, see taps above
      # "homebrew-zathura/zathura/zathura-pdf-mupdf"
    ];
  };
}
