{ inputs
, config
, pkgs
, username
, lib
, ...
}:
let
  defaultPkgs =
    (with pkgs; [
      # filesystem
      fd
      ripgrep
      du-dust
      fzy
      curl
      duf # df alternative showing free disk space
      fswatch
      tree
      rsync

      # compression
      atool
      unzip
      gzip
      xz
      zip

      # file viewers
      less
      page # like less, but uses nvim, which is handy for selecting out text and such
      file
      jq
      lynx
      sourceHighlight # for lf preview
      ffmpeg-full.bin
      ffmpegthumbnailer # for lf preview
      pandoc # for lf preview
      imagemagick # for lf preview
      highlight # code coloring in lf
      poppler_utils # for pdf2text in lf
      mediainfo # used by lf
      exiftool # used by lf
      exif
      glow # browse markdown dirs
      mdcat # colorize markdown
      html2text

      # network
      gping
      bandwhich # bandwidth monitor by process
      static-web-server # serve local static files
      aria # cli downloader
      hostname
      trippy # mtr alternative
      xh # rust version of httpie / better curl

      # misc
      neofetch # display key software/version info in term
      vimv # shell script to bulk rename
      vulnix # check for live nix apps that are listed in NVD
      aspell # spell checker
      kalker # cli calculator; alt. to bc and calc
      rink # calculator for unit conversions
      nix-tree # explore dependencies
      asciinema # terminal screencast
      ctags
      catimg # ascii rendering of any image in terminal x-pltfrm
      fortune
      ipcalc
      kondo # free disk space by cleaning project build dirs
      optipng
      procps
      pstree
      pastel # cli for color manipulation
      gnugrep
    ]);

  networkPkgs = with pkgs; [ mtr iftop ];
  guiPkgs =
    [
      # pkgs.element-desktop
      #dbeaver # database sql manager with er diagrams
    ]
    ++ (lib.optionals pkgs.stdenv.isDarwin
      [
        pkgs.colima # command line docker server replacement
        pkgs.docker
        pkgs.utm
        pkgs.raycast
      ]);
in
{
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
  home.packages = defaultPkgs ++ guiPkgs ++ networkPkgs;

  home.file =
    {
      ".inputrc".text = ''
        set show-all-if-ambiguous on
        set completion-ignore-case on
        set mark-directories on
        set mark-symlinked-directories on

        # Do not autocomplete hidden files unless the pattern explicitly begins with a dot
        set match-hidden-files off

        # Show extra file information when completing, like `ls -F` does
        set visible-stats on

        # Be more intelligent when autocompleting by also looking at the text after
        # the cursor. For example, when the current line is "cd ~/src/mozil", and
        # the cursor is on the "z", pressing Tab will not autocomplete it to "cd
        # ~/src/mozillail", but to "cd ~/src/mozilla". (This is supported by the
        # Readline used by Bash 4.)
        set skip-completed-text on

        # Allow UTF-8 input and output, instead of showing stuff like $'\0123\0456'
        set input-meta on
        set output-meta on
        set convert-meta off

        # Use Alt/Meta + Delete to delete the preceding word
        "\e[3;3~": kill-word

        set keymap vi
        set editing-mode vi-insert
        "\e\C-h": backward-kill-word
        "\e\C-?": backward-kill-word
        "\eb": backward-word
        "\C-a": beginning-of-line
        "\C-l": clear-screen
        "\C-e": end-of-line
        "\ef": forward-word
        "\C-k": kill-line
        "\C-y": yank
        # Go up a dir with ctrl-n
        "\C-n":"cd ..\n"
        set editing-mode vi
      '';
    };

  programs.bat = {
    enable = true;
    #extraPackages = with pkgs.bat-extras; [ batman batgrep ];
    config = {
      theme = "Dracula"; # I like the TwoDark colors better, but want bold/italic in markdown docs
      #pager = "less -FR";
      pager = "page -WO -q 90000";
      italic-text = "always";
      style = "plain"; # no line numbers, git status, etc... more like cat with colors
    };
  };
  programs.nix-index.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = false;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
    tmux.enableShellIntegration = false;
    defaultCommand = "\fd --type f --hidden --exclude .git";
    fileWidgetCommand = "\fd --exclude .git --type f"; # for when ctrl-t is pressed
    changeDirWidgetCommand = "\fd --type d --hidden --follow --max-depth 3 --exclude .git";
  };
  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    includes = [ "*.conf" ];
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
  programs.gh = {
    enable = true;
    package = pkgs.gh;
    # Ones I have installed that aren't available in pkgs 2024-07-31:
    #inputs.gh-feed
    settings = { git_protocol = "ssh"; };
  };
  programs.mpv = {
    enable = true;
    # TODO: Same problem as below when using unstable
    package = pkgs.mpv;
    # TODO: Commenting out scripts 2024-07-09 because they are causing an error
    # around swift-wrapper-5.8 being broken
    # scripts = with pkgs.stable.mpvScripts; [thumbnail sponsorblock];
    config = {
      # disable on-screen controller -- else I get a message saying I have to add this
      osc = false;
      # Use a large seekable RAM cache even for local input.
      cache = true;
      save-position-on-quit = false;
      #x11-bypass-compositor = true;
      #no-border = true;
      msg-color = true;
      pause = true;
      # This will force use of h264 instead vp8/9 so hardware acceleration works
      ytdl-format = "bv*[ext=mp4]+ba/b";
      #ytdl-format = "bestvideo+bestaudio";
      # have mpv use yt-dlp instead of youtube-dl
      script-opts-append = "ytdl_hook-ytdl_path=${pkgs.yt-dlp}/bin/yt-dlp";
      autofit-larger = "100%x95%"; # resize window in case it's larger than W%xH% of the screen
      input-media-keys = "yes"; # enable/disable OSX media keys
      hls-bitrate = "max"; # use max quality for HLS streams

      user-agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:57.0) Gecko/20100101 Firefox/58.0";
    };
    defaultProfiles = [ "gpu-hq" ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    # let's the terminal track current working dir but only builds on linux
    enableVteIntegration =
      if pkgs.stdenvNoCC.isDarwin
      then false
      else true;

    history = {
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      save = 10000; # save 10,000 lines of history
    };
    defaultKeymap = "viins";
    # things to add to .zshenv
    sessionVariables = { };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];
    shellAliases =
      {
        c = "clear";
        ls = "ls --color=auto -F";
        l = "eza --icons --git-ignore --git -F";
        la = "eza --icons --git-ignore --git -F -a";
        ll = "eza --icons --git-ignore --git -F --extended -l";
        lt = "eza --icons --git-ignore --git -F -T";
        llt = "eza --icons --git-ignore --git -F -l -T";
        fd = "\\fd -H -t d"; # default search directories
        f = "\\fd -H"; # default search this dir for files ignoring .gitignore etc
        lf = "~/.config/lf/lfimg";
        nixflakeupdate1 = "nix run github:vimjoyer/nix-update-input"; # does `nix flake lock --update-input` with relevant fuzzy complete. Though actually, our tab completion does the same
        qp = ''
          qutebrowser --temp-basedir --set content.private_browsing true --set colors.tabs.bar.bg "#552222" --config-py "$HOME/.config/qutebrowser/config.py" --qt-arg name "qp,qp"'';
        calc = "kalker";
        df = "duf";
        # search for a note and with ctrl-n, create it if not found
        # add subdir as needed like "n meetings" or "n wiki"
        n = "zk edit --interactive";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        # These options increase compatibility (with quicktime), but decrease resolution :(
        # when the mp4 resolution available is not the highest resolution available
        # -S '+vcodec:avc,+acodec:m4a'
        # -S 'codec:h264:m4a'
        "yt" = "yt-dlp -f 'bv*+ba/b' --remux-video mp4 --embed-subs --write-auto-sub --embed-thumbnail --write-subs --sub-langs 'en.*,en-orig,en' --embed-chapters --sponsorblock-mark default --sponsorblock-remove default --no-prefer-free-formats --check-formats --embed-metadata --cookies-from-browser brave --user-agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36'";
        "yt-fix" = "convert_vid_to_h264";
        "yt-fix-curdir" = "convert_v9_vids_to_h264";
        "syncm" = "rsync -avhzP --progress \"$HOME/Sync/Private/PW Projects/Magic/\" pwalsh@synology1.savannah-basilisk.ts.net:/volume1/video/Magic/";
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
        tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
        # Figure out the uniform type identifiers and uri schemes of a file (must specify the file)
        # for use in SwiftDefaultApps
        checktype = "mdls -name kMDItemContentType -name kMDItemContentTypeTree -name kMDItemKind";
        # dwupdate = "pushd ~/.config/nixpkgs ; nix flake update ; /opt/homebrew/bin/brew update; popd ; dwswitch ; /opt/homebrew/bin/brew upgrade ; /opt/homebrew/bin/brew upgrade --cask --greedy; dwshowupdates; popd";
        # brew update should no longer be needed; and brew upgrade should just happen, I think, but I might need to specify greedy per package
        dwupdate = "pushd ~/.config/nixpkgs ; nix flake update ; popd ; dwswitchx ; dwshowupdates; popd";
        # Cachix on my whole nix store is burning unnecessary bandwidth and time -- slowing things down rather than speeding up
        # From now on will just use for select personal flakes and things
        #dwswitch = "pushd ~; cachix watch-exec zmre darwin-rebuild -- switch --flake ~/.config/nixpkgs/.#$(hostname -s) ; popd";
        dwswitchx = "pushd ~; darwin-rebuild switch --flake ~/.config/nixpkgs/.#$(hostname -s) ; popd";
        dwclean = "pushd ~; sudo nix-env --delete-generations +7 --profile /nix/var/nix/profiles/system; sudo nix-collect-garbage --delete-older-than 30d ; nix store optimise ; popd";
        dwupcheck = "pushd ~/.config/nixpkgs ; nix flake update ; darwin-rebuild build --flake ~/.config/nixpkgs/.#$(hostname -s) && nix store diff-closures /nix/var/nix/profiles/system ~/.config/nixpkgs/result; popd"; # todo: prefer nvd?
        # i use the zsh shell out in case anyone blindly copies this into their bash or fish profile since syntax is zsh specific
        dwshowupdates = ''
          zsh -c "nix store diff-closures /nix/var/nix/profiles/system-*-link(om[2]) /nix/var/nix/profiles/system-*-link(om[1])"'';
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
        hmswitch = ''
          nix-shell -p home-manager --run "home-manager switch --flake ~/.config/nixpkgs/.#$(hostname -s)"'';
        noupdate = "pushd ~/.config/nixpkgs; nix flake update; popd; noswitch";
        noswitch = "pushd ~; sudo cachix watch-exec zmre nixos-rebuild -- switch --flake ~/.config/nixpkgs/.# ; popd";
      };
  };

  programs.eza.enable = true; # replacement for "exa" which is now archived
  /*
    programs.pistol = {
    # I've gone back to my pv.sh script for now
    enable = false;
    associations = [
    {
    mime = "text/*";
    command = "bat --paging=never --color=always %pistol-filename%";
    }
    {
    mime = "image/*";
    command = "kitty +kitten icat --silent --transfer-mode=stream --stdin=no %pistol-filename%";
    }
    ];
    };
  */
  # my preferred file explorer; mnemonic: list files

  # Nice shell history https://atuin.sh -- experimenting with this 2024-07-26
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      update_check = false;
      search_mode = "fuzzy";
      inline_height = 33;
      common_prefix = [ "sudo" ];
      dialect = "us";
      workspaces = true;
      filter_mode = "host";
      filter_mode_shell_up_key_binding = "session"; # pointless now that I've disabled up arrow
      history_filter = [
        "^ "
        # "^innocuous-cmd .*--secret=.+"
      ];
    };
  };
  programs.starship = {
    enable = true;
    enableNushellIntegration =
      false; # I've manually integrated because of bugs 2023-04-05
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      format = pkgs.lib.concatStrings [
        "$os"
        "$shell"
        "$username"
        "$hostname"
        "$singularity"
        "$kubernetes"
        "$directory"
        "$vcsh"
        "$fossil_branch"
        "$git_branch"
        # "$git_commit"
        # "$git_state"
        # "$git_status"
        # "$git_metrics"
        "$hg_branch"
        "$pijul_channel"
        "$sudo"
        "$jobs"
        "$line_break"
        "$battery"
        "$time"
        "$status"
        "$container"
        "$character"
      ];
      right_format = pkgs.lib.concatStrings [
        "$cmd_duration"
        "$shlvl"
        "$docker_context"
        "$package"
        "$c"
        "$cmake"
        "$daml"
        "$dart"
        "$deno"
        "$dotnet"
        "$elixir"
        "$elm"
        "$erlang"
        "$fennel"
        "$golang"
        "$guix_shell"
        "$haskell"
        "$haxe"
        "$helm"
        "$java"
        "$julia"
        "$kotlin"
        "$gradle"
        "$lua"
        "$nim"
        "$nodejs"
        "$ocaml"
        "$opa"
        "$perl"
        "$php"
        "$pulumi"
        "$purescript"
        "$python"
        "$raku"
        "$rlang"
        "$red"
        "$ruby"
        "$rust"
        "$scala"
        "$swift"
        "$terraform"
        "$vlang"
        "$vagrant"
        "$zig"
        "$buf"
        "$nix_shell"
        "$conda"
        "$meson"
        "$spack"
        "$memory_usage"
        "$aws"
        "$gcloud"
        "$openstack"
        "$azure"
        "$env_var"
        "$crystal"
        "$custom"
      ];
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vicmd_symbol = "[❮](green)";
      };
      scan_timeout = 30;
      add_newline = true;
      gcloud.disabled = true;
      aws.disabled = true;
      os.disabled = false;
      os.symbols.Macos = "";
      kubernetes = {
        disabled = false;
        context_aliases = {
          "gke_.*_(?P<var_cluster>[\\w-]+)" = "$var_cluster";
        };
      };
      git_status.style = "blue";
      git_metrics.disabled = false;
      git_branch.style = "bright-black";
      git_branch.format = "[  ](bright-black)[$symbol$branch(:$remote_branch)]($style) ";
      time.disabled = true;
      directory = {
        format = "[    ](bright-black)[$path]($style)[$read_only]($read_only_style)";
        truncation_length = 4;
        truncation_symbol = "…/";
        style = "bold blue"; # cyan
        truncate_to_repo = false;
      };
      directory.substitutions = {
        # Documents = " ";
        # Downloads = " ";
        # Music = " ";
        # Pictures = " ";
        "Library/Containers/co.noteplan.NotePlan3/Data/Library/Application Support/co.noteplan.NotePlan3" = "Notes";
      };
      package.disabled = true;
      package.format = "version [$version](bold green) ";
      nix_shell.symbol = " ";
      rust.symbol = " ";
      shell = {
        disabled = false;
        format = "[$indicator]($style)";
        style = "bright-black";
        bash_indicator = " bsh";
        nu_indicator = " nu";
        fish_indicator = " ";
        zsh_indicator = ""; # don't show when in my default shell type
        unknown_indicator = " ?";
        powershell_indicator = " _";
      };
      cmd_duration = {
        format = "[$duration]($style)   ";
        style = "bold yellow";
        min_time_to_notify = 5000;
      };
      jobs = {
        symbol = "";
        style = "bold red";
        number_threshold = 1;
        format = "[$symbol]($style)";
      };
    };
  };

  programs.alacritty = {
    enable = pkgs.stdenv.isLinux; # only install on Linux
    #package =
    #pkgs.alacritty; # switching to unstable so i get 0.11 with undercurl support
    settings = {
      window.decorations = "full";
      window.dynamic_title = true;
      #background_opacity = 0.9;
      window.opacity = 0.9;
      scrolling.history = 3000;
      # scrolling.smooth = true;
      font.normal.family = "MesloLGS Nerd Font Mono";
      font.normal.style = "Regular";
      font.bold.style = "Bold";
      font.italic.style = "Italic";
      font.bold_italic.style = "Bold Italic";
      font.size =
        if pkgs.stdenvNoCC.isDarwin
        then 16
        else 9;
      shell.program = "${pkgs.zsh}/bin/zsh";
      live_config_reload = true;
      cursor.vi_mode_style = "Underline";
      colors.draw_bold_text_with_bright_colors = true;
      keyboard.bindings = [
        {
          key = "Escape";
          mods = "Control";
          mode = "~Search";
          action = "ToggleViMode";
        }
        # cmd-{ and cmd-} and cmd-] and cmd-[ will switch tmux windows
        # {
        #   key = "LBracket";
        #   mods = "Command";
        #   # \x02 is ctrl-b so sequence below is ctrl-b, h
        #   chars = "\\x02h";
        # }
        # {
        #   key = "RBracket";
        #   mods = "Command";
        #   chars = "\\x02l";
        # }
      ];
    };
  };

}
