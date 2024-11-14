_: {
  system.defaults = {
    #
    # `man configuration.nix` on mac is useful in seeing available options
    # `defaults read -g` on mac is useful to see current settings
    LaunchServices = {
      # quarantine downloads until approved
      LSQuarantine = true;
    };
    loginwindow = {
      GuestEnabled = false;
      SHOWFULLNAME = false;
      # Disables the ability for a user to access the console by typing “>console” for a 
      # username at the login window.
      DisableConsoleAccess = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      QuitMenuItem = true;
      # Use column view in all Finder windows by default
      FXPreferredViewStyle = "clmv";
      NewWindowTarget = "Home";
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXSortFoldersFirst = true;
    };

    hitoolbox.AppleFnUsageType = "Change Input Source";
    menuExtraClock.IsAnalog = true;

    trackpad = {
      ActuationStrength = 0; # silent clicking = 0, default = 1
      Clicking = true; # enable tap to click
      Dragging = false; # tap and a half to drag
      TrackpadThreeFingerDrag = false; # three finger click and drag
    };

    # firewall settings
    alf = {
      # 0 = disabled 1 = enabled 2 = blocks all connections except for essential services
      globalstate = 1;
      loggingenabled = 0;
      stealthenabled = 1;
    };

    spaces.spans-displays = false; # separate spaces on each display

    dock = {
      autohide = true; # auto show and hide dock
      autohide-delay = 0.0; # remove delay for showing dock
      autohide-time-modifier = 0.2; # how fast is the dock showing animation
      expose-animation-duration = 0.2;
      tilesize = 48;
      launchanim = false;
      static-only = false;
      showhidden = true;
      show-process-indicators = true;
      orientation = "bottom";
      mru-spaces = false;
      persistent-apps = [
        "/System/Library/CoreServices/Finder.app"
      ];
    };

    NSGlobalDomain = {
      # 2 = heavy font smoothing; if text looks blurry, back this down to 1
      AppleFontSmoothing = 2;
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark"; # Dark mode
      AppleInterfaceStyleSwitchesAutomatically = false; # auto switch light/dark
      "com.apple.sound.beep.feedback" = 1;
      "com.apple.sound.beep.volume" = 4723665; # 25%
      "com.apple.mouse.tapBehavior" = 1; # tap to click
      "com.apple.swipescrolldirection" = true; # "natural" scrolling
      "com.apple.keyboard.fnState" = false;
      "com.apple.springing.enabled" = false;
      "com.apple.trackpad.scaling" = 1.0;
      "com.apple.trackpad.enableSecondaryClick" = true;
      # enable full keyboard control
      # (e.g. enable Tab in modal dialogs)
      AppleKeyboardUIMode = 3;
      AppleTemperatureUnit = "Celsius";
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      ApplePressAndHoldEnabled = false; # no popup menus when holding down letters
      InitialKeyRepeat = 14; # delay before repeating keystrokes
      KeyRepeat = 1; # delay between repeated keystrokes upon holding a key
      AppleShowScrollBars = "Automatic";
      NSScrollAnimationEnabled = true; # smooth scrolling
      NSAutomaticCapitalizationEnabled = true;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = true; # no automatic smart quotes
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSWindowResizeTime = 0.001; # speed up animation on open/save boxes (default:0.2)
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
    };

    # Stage Manager
    WindowManager = {
      AppWindowGroupingBehavior = false;
      AutoHide = true;
      EnableStandardClickToShowDesktop = false; # only in SM
    };

    controlcenter = {
      # 18 - show in menu bar, 24 - hide
      NowPlaying = 24;
      Sound = 24;
    };

    CustomUserPreferences = {
      NSGlobalDomain = {
        # Add a context menu item for showing the Web Inspector in web views
        WebKitDeveloperExtras = true;
        AppleMiniaturizeOnDoubleClick = false;
        NSAutomaticTextCompletionEnabled = true;
        "com.apple.sound.beep.flash" = false;
      };
      "com.apple.finder" = {
        OpenWindowForNewRemovableDisk = true;
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
        _FXSortFoldersFirst = true;
        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";
        FXInfoPanesExpanded = {
          General = true;
          OpenWith = true;
          Privileges = true;
        };
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.screensaver" = {
        # Require password immediately after sleep or screen saver begins
        askForPassword = 1;
        askForPasswordDelay = 0;
      };
      "com.apple.screencapture" = {
        location = "~/Pictures/Screenshots";
        type = "png";
      };
      "com.apple.ActivityMonitor" = {
        OpenMainWindow = true;
        IconType = 5; # visualize cpu in dock icon
        ShowCategory = 0; # show all processes
        SortColumn = "CPUUsage";
        SortDirection = 0;
      };
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.print.PrintingPrefs" = {
        # Automatically quit printer app once the print jobs complete
        "Quit When Finished" = true;
      };
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        # Check for software updates daily, not just once per week
        # Except it doesn't seem to be doing this. And in some guides, it shows referencing a prefs file
        # Going to cover my bases and add this a second time in a second place directly in the activation script
        ScheduleFrequency = 1;
        # Download newly available updates in background
        AutomaticDownload = 0;
        # Install System data files & security updates
        CriticalUpdateInstall = 1;
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      # Prevent Photos from opening automatically when devices are plugged in
      "com.apple.ImageCapture".disableHotPlug = true;
      # Turn on app auto-update
      "com.apple.commerce".AutoUpdate = true;
      "mo.com.sleeplessmind.Wooshy" = {
        # "KeyboardShortcuts_toggleWith" = "{\"carbonModifiers\":768,\"carbonKeyCode\":49}";
        SUEnableAutomaticChecks = 0;
        SUUpdateGroupIdentifier = 3425398139;
        allowCyclingThroughTargets = 1;
        "com_apple_SwiftUI_Settings_selectedTabIndex" = 4;
        fuzzyMatchingFlavor = "wooshyClassic";
        hazeOverWindowStyle = "fadeOutExceptDockMenuBarAndFrontmostApp";
        inputPosition = "aboveWindow";
        inputPreset = "custom";
        inputTextSize = 20;
        searchIncludesTrafficLightButtons = 1;
      };
      "mo.com.sleeplessmind.Scrolla" = {
        "KeyboardShortcuts_toggleWith" = "{\"carbonModifiers\":4352,\"carbonKeyCode\":49}";
        "NSStatusItem Preferred Position Item-0" = 6276;
        SUEnableAutomaticChecks = 0;
        SUUpdateGroupIdentifier = 3756402529;
        "com_apple_SwiftUI_Settings_selectedTabIndex" = 0;
        ignoreAreasWithoutScrollBars = 0;
      };
    };
  };
  system.keyboard = {
    nonUS.remapTilde = true;
    remapCapsLockToEscape = true;
  };
}
