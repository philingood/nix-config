{
  inputs,
  config,
  pkgs,
  ...
}: {
  # environment setup
  environment = {
    # loginShell = pkgs.zsh;
    pathsToLink = ["/Applications"];
    systemPath = ["/opt/homebrew/bin" "/opt/homebrew/sbin"];
    etc = {
      darwin.source = "${inputs.darwin}";
    };
    # Use a custom configuration.nix location.
    # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix

    # packages installed in system profile
    systemPackages = with pkgs; [
      git
      curl
      coreutils
      gnused
      pam-reattach
      zoxide
    ];

    # Fix "Too many open files" problems. Based on this:
    # https://medium.com/mindful-technology/too-many-open-files-limit-ulimit-on-mac-os-x-add0f1bfddde
    # Needs reboot to take effect
    # Changes default from 256 to 524,288 (probably a bigger jump than is really necessary)
    launchDaemons.ulimitMaxFiles = {
      enable = true;
      target = "limit.maxfiles"; # suffix .plist
      text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
                  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>Label</key>
            <string>limit.maxfiles</string>
            <key>ProgramArguments</key>
            <array>
              <string>launchctl</string>
              <string>limit</string>
              <string>maxfiles</string>
              <string>524288</string>
              <string>524288</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>ServiceIPC</key>
            <false/>
          </dict>
        </plist
      '';
    };
  };

  # Many of these taken from https://github.com/mathiasbynens/dotfiles/blob/master/.macos
  system = {
    activationScripts = {
      extraActivation = {
        enable = true;
        text = ''
          echo "Activating extra preferences..."
          # Close any open System Preferences panes, to prevent them from overriding
          # settings we’re about to change
          osascript -e 'tell application "System Preferences" to quit'

          # Show the ~/Library folder
          #chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

          # Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
          # defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

          # Display emails in threaded mode, sorted by date (newest at the top)
          defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
          defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "no"
          defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

          # Doesn't seem to matter in the global domain so trying this
          defaults write "/Library/Preferences/com.apple.SoftwareUpdate" ScheduleFrequency 1

          defaults write com.apple.spotlight orderedItems -array \
            '{"enabled" = 1;"name" = "APPLICATIONS";}' \
            '{"enabled" = 1;"name" = "DIRECTORIES";}' \
            '{"enabled" = 1;"name" = "PDF";}' \
            '{"enabled" = 1;"name" = "DOCUMENTS";}' \
            '{"enabled" = 1;"name" = "PRESENTATIONS";}' \
            '{"enabled" = 1;"name" = "SPREADSHEETS";}' \
            '{"enabled" = 1;"name" = "MENU_OTHER";}' \
            '{"enabled" = 1;"name" = "CONTACT";}' \
            '{"enabled" = 1;"name" = "IMAGES";}' \
            '{"enabled" = 1;"name" = "MESSAGES";}' \
            '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
            '{"enabled" = 1;"name" = "EVENT_TODO";}' \
            '{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
            '{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
            '{"enabled" = 0;"name" = "FONTS";}' \
            '{"enabled" = 0;"name" = "BOOKMARKS";}' \
            '{"enabled" = 0;"name" = "MUSIC";}' \
            '{"enabled" = 0;"name" = "MOVIES";}' \
            '{"enabled" = 0;"name" = "SOURCE";}' \
            '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
            '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
            '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

          echo "Turning on verbose boot startup"
          sudo nvram boot-args="-v"

        '';
        # to create an importable plist, see export-plists.sh
      };
      activateSettings.text = ''
        # Following line should allow us to avoid a logout/login cycle
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  documentation.enable = true; # temp disable 2024-07-06 to workaround issue
  # documentation.doc.enable = false;
  # documentation.man.enable = false;
  # documentation.man.generateCaches.enable = false;
  # documentation.nixos.enable = false;

  networking.knownNetworkServices = [ "Wi-Fi" ];
  # networking.dns = [ "192.168.90.250" "10.0.30.2" "8.8.4.4" "1.1.1.1" ];

  fonts.packages = with pkgs; [
    # powerline-fonts
    # source-code-pro
    # roboto-slab
    # source-sans-pro
    # montserrat
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    nerd-fonts.inconsolata-lgc
    nerd-fonts.symbols-only
  ];
  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}" "darwin=/etc/${config.environment.etc.darwin.target}"];
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  # auto manage nixbld users with nix darwin
  # nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # allow touchid to auth sudo -- this comes from pam.nix, which needs to be loaded before this
  # it's now standard to nix-darwin, but without the special sauch needed for tmux, so we
  # will continue using our custom script
}
