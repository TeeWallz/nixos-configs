{ config, lib, pkgs, ... }:
with lib;
let cfg = config.my.per-user.yc.modules.home-manager;
in {
  options.my.per-user.yc.modules.home-manager = {
    enable = mkOption {
      type = types.bool;
      default = config.my.per-user.yc.enable;
    };
  };
  config = mkIf cfg.enable {
    # have a clean home
    my.fileSystems.datasets = { "rpool/nixos/home" = "/oldroot/home"; };
    fileSystems."/home/yc" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "rw" "size=1G" "uid=yc" "gid=users" "mode=1700" ];
    };
    programs.gnupg.agent = {
      enable = true;
      pinentryFlavor = (if config.programs.sway.enable then "qt" else "tty");
    };

    home-manager.users.yc = {
      home.packages = with pkgs; [ ];

      gtk = {
        enable = true;
        font = { name = "Noto Sans Display 14"; };
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome.gnome-themes-extra;
        };
        iconTheme = {
          package = pkgs.gnome.adwaita-icon-theme;
          name = "Adwaita";
        };
      };
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          enable-animations = false;
          document-font-name = "Noto Sans Display 12";
          monospace-font-name = "Source Code Pro 10";
          gtk-key-theme = "Emacs";
          cursor-size = 48;
        };
      };
      programs.bash = {
        enable = true;
        initExtra =
          "if [ -f ~/.config/yc.sh ]; then source ~/.config/yc.sh; fi";
      };
      programs = {
        git = {
          enable = true;
          userEmail = "jasper@apvc.uk";
          userName = "Maurice Zhou";
        };
        mbsync.enable = true;
        msmtp.enable = true;
        notmuch.enable = true;
      };
      accounts.email = {
        maildirBasePath = "Maildir"; # relative to user home
        accounts = {
          "apvc.uk" = {
            aliases = [ "gyc@apvc.uk" ];
            address = "yuchen@apvc.uk";
            passwordCommand = "pass show email/email-gycAtapvc.uk | head -n1";
            primary = true;
            userName = "gyc@apvc.uk";
            realName = "Yuchen Guo";
            imap = {
              host = "mail.gandi.net";
              port = 993;
            };
            smtp = {
              host = "mail.gandi.net";
              port = 465;
            };
            mbsync = {
              enable = true;
              create = "both";
              remove = "both";
              expunge = "both";
            };
            msmtp = {
              enable = true;
              extraConfig = { auth = "plain"; };
            };
            notmuch.enable = true;
            gpg = {
              key = "gyc@apvc.uk";
              encryptByDefault = false;
              signByDefault = true;
            };
          };
        };
      };
      programs.mpv = {
        enable = true;
        config = {
          gpu-context = "wayland";
          hwdec = "vaapi";
          player-operation-mode = "pseudo-gui";
          audio-pitch-correction = "no";
        };
      };
      programs.yt-dlp = {
        enable = true;
        settings = { format-sort = "codec:h264"; };
      };
      programs.zathura = {
        enable = true;
        mappings = {
          "[normal] <C-b>" = "scroll left";
          "[normal] <C-n>" = "scroll down";
          "[normal] <C-p>" = "scroll up";
          "[normal] <C-f>" = "scroll right";
          "[normal] <C-g>" = "abort";
          "[insert] <C-g>" = "abort";
          "[normal] <C-[>" = "abort";
          "[normal] <A-\\<>" = "goto top";
          "[normal] <A-\\>>" = "goto bottom";
          "[normal] a" = "adjust_window best-fit";
          "[normal] s" = "adjust_window width";
          "[normal] F" = "display_link";
          "[normal] <C-c>" = "copy_link";
          "[normal] f" = "follow";
          "[normal] m" = "mark_add";
          "[normal] \\'" = "mark_evaluate";
          "[normal] \\," = "navigate next";
          "[normal] \\." = "navigate previous";
          "[normal] <A-Right>" = "navigate next";
          "[normal] <A-Left>" = "navigate previous";
          "[normal] <C-P>" = "print";
          "[normal] c" = "recolor";
          "[normal] R" = "reload";
          "[normal] v" = "rotate rotate_cw";
          "[normal] V" = "rotate rotate_ccw";
          "[normal] <Left>" = "scroll left";
          "[normal] <Up>" = "scroll up";
          "[normal] <Down>" = "scroll down";
          "[normal] <Right>" = "scroll right";
          "[normal] <A-a>" = "scroll half-left";
          "[normal] <C-V>" = "scroll half-down";
          "[normal] <A-V>" = "scroll half-up";
          "[normal] <A-e>" = "scroll half-right";
          "[normal] <C-a>" = "scroll full-left";
          "[normal] <C-v>" = "scroll full-down";
          "[normal] <Return>" = "scroll full-down";
          "[normal] <A-v>" = "scroll full-up";
          "[normal] <C-e>" = "scroll full-right";
          "[normal] <Space>" = "scroll full-down";
          "[normal] <A-Space>" = "scroll full-up";
          "[normal] <C-h>" = "scroll full-up";
          "[normal] <BackSpace>" = "scroll full-up";
          "[normal] <S-Space>" = "scroll full-up";
          "[normal] l" = "jumplist backward";
          "[normal] r" = "jumplist forward";
          "[normal] <A-r>" = "bisect forward";
          "[normal] <A-l>" = "bisect backward";
          "[normal] <C-s>" = "search forward";
          "[normal] <C-r>" = "search backward";
          "[normal] p" = "snap_to_page";
          "[normal] <C-i>" = "toggle_index";
          "[normal] i" = "toggle_index";
          "[normal] <Tab>" = "toggle_index";
          "[normal] <A-s>" = "toggle_statusbar";
          "[normal] <A-i>" = "focus_inputbar";
          "[normal] d" = "toggle_page_mode";
          "[normal] q" = "quit";
          "[normal] +" = "zoom in";
          "[normal] -" = "zoom out";
          "[normal] <C-+>" = "zoom in";
          "[normal] <C-->" = "zoom out";
          "[normal] =" = "zoom in";
          "[normal] <A-P>" = "toggle_presentation";
          "[normal] <A-F>" = "toggle_fullscreen";
          "[normal] j" = "toggle_fullscreen";
          "[fullscreen] j" = "toggle_fullscreen";
          "[fullscreen] q" = "toggle_fullscreen";
          "[fullscreen] <C-b>" = "scroll left";
          "[fullscreen] <C-n>" = "scroll down";
          "[fullscreen] <C-p>" = "scroll up";
          "[fullscreen] <C-f>" = "scroll right";
          "[fullscreen] <C-g>" = "abort";
          "[fullscreen] <C-[>" = "abort";
          "[fullscreen] <A-\\<>" = "goto top";
          "[fullscreen] <A-\\>>" = "goto bottom";
          "[fullscreen] a" = "adjust_window best-fit";
          "[fullscreen] s" = "adjust_window width";
          "[fullscreen] F" = "display_link";
          "[fullscreen] <C-c>" = "copy_link";
          "[fullscreen] f" = "follow";
          "[fullscreen] m" = "mark_add";
          "[fullscreen] \\'" = "mark_evaluate";
          "[fullscreen] \\," = "navigate next";
          "[fullscreen] \\." = "navigate previous";
          "[fullscreen] <A-Right>" = "navigate next";
          "[fullscreen] <A-Left>" = "navigate previous";
          "[fullscreen] <C-P>" = "print";
          "[fullscreen] c" = "recolor";
          "[fullscreen] R" = "reload";
          "[fullscreen] v" = "rotate rotate_cw";
          "[fullscreen] V" = "rotate rotate_ccw";
          "[fullscreen] <Left>" = "scroll left";
          "[fullscreen] <Up>" = "scroll up";
          "[fullscreen] <Down>" = "scroll down";
          "[fullscreen] <Right>" = "scroll right";
          "[fullscreen] <A-a>" = "scroll half-left";
          "[fullscreen] <C-V>" = "scroll half-down";
          "[fullscreen] <A-V>" = "scroll half-up";
          "[fullscreen] <A-e>" = "scroll half-right";
          "[fullscreen] <C-a>" = "scroll full-left";
          "[fullscreen] <C-v>" = "scroll full-down";
          "[fullscreen] <Return>" = "scroll full-down";
          "[fullscreen] <A-v>" = "scroll full-up";
          "[fullscreen] <C-e>" = "scroll full-right";
          "[fullscreen] <Space>" = "scroll full-down";
          "[fullscreen] <A-Space>" = "scroll full-up";
          "[fullscreen] <C-h>" = "scroll full-up";
          "[fullscreen] <BackSpace>" = "scroll full-up";
          "[fullscreen] <S-Space>" = "scroll full-up";
          "[fullscreen] l" = "jumplist backward";
          "[fullscreen] r" = "jumplist forward";
          "[fullscreen] <A-r>" = "bisect forward";
          "[fullscreen] <A-l>" = "bisect backward";
          "[fullscreen] <C-s>" = "search forward";
          "[fullscreen] <C-r>" = "search backward";
          "[fullscreen] p" = "snap_to_page";
          "[fullscreen] i" = "toggle_index";
          "[fullscreen] <C-i>" = "toggle_index";
          "[fullscreen] <Tab>" = "toggle_index";
          "[fullscreen] <A-s>" = "toggle_statusbar";
          "[fullscreen] <A-i>" = "focus_inputbar";
          "[fullscreen] d" = "toggle_page_mode";
          "[fullscreen] +" = "zoom in";
          "[fullscreen] -" = "zoom out";
          "[fullscreen] =" = "zoom in";
          "[index] <A-s>" = "toggle_statusbar";
          "[index] q" = "toggle_index";
          "[index] i" = "toggle_index";
          "[index] <C-p>" = "navigate_index up";
          "[index] <C-h>" = "navigate_index up";
          "[index] <BackSpace>" = "navigate_index up";
          "[index] <C-n>" = "navigate_index down";
          "[index] <A-v>" = "navigate_index up";
          "[index] <C-v>" = "navigate_index down";
          "[index] \\<" = "navigate_index top";
          "[index] \\>" = "navigate_index bottom";
          "[index] <A-\\<>" = "navigate_index top";
          "[index] <A-\\>>" = "navigate_index bottom";
          "[index] <C-b>" = "navigate_index collapse";
          "[index] <C-f>" = "navigate_index expand";
          "[index] <C-i>" = "navigate_index expand-all";
          "[index] <A-i>" = "navigate_index collapse-all";
          "[index] <Up>" = "navigate_index up";
          "[index] <Down>" = "navigate_index down";
          "[index] <Left>" = "navigate_index collapse";
          "[index] <Right>" = "navigate_index expand";
          "[index] <C-m>" = "navigate_index select";
          "[index] <Space>" = "navigate_index select";
          "[index] <Return>" = "navigate_index select";
          "[index] <C-j>" = "navigate_index select";
          "[index] <Esc>" = "toggle_index";
          "[index] <C-[>" = "toggle_index";
          "[index] <C-g>" = "toggle_index";
          "[index] <C-c>" = "toggle_index";
          "[presentation] i" = "toggle_index";
          "[presentation] r" = "navigate next";
          "[presentation] <Down>" = "navigate next";
          "[presentation] <Right>" = "navigate next";
          "[presentation] <PageDown>" = "navigate next";
          "[presentation] <Space>" = "navigate next";
          "[presentation] l" = "navigate previous";
          "[presentation] <Left>" = "navigate previous";
          "[presentation] <Up>" = "navigate previous";
          "[presentation] <PageUp>" = "navigate previous";
          "[presentation] <S-Space>" = "navigate previous";
          "[presentation] <BackSpace>" = "navigate previous";
          "[presentation] <F5>" = "toggle_presentation";
          "[presentation] q" = "toggle_presentation";
          "[presentation] <C-h>" = "navigate previous";
          "[presentation] <M-v>" = "navigate previous";
          "[presentation] <C-v>" = "navigate next";
          "[presentation] <A-\\<>" = "goto top";
          "[presentation] <A-\\>>" = "goto bottom";

        };
        options = {
          selection-clipboard = "clipboard";
          window-title-basename = true;
          adjust-open = "width";
          scroll-page-aware = false;
          scroll-full-overlap = "0.1";
          statusbar-home-tilde = true;
          synctex = true;
          font = "Monospace bold 16";
          guioptions = "hv";
          zoom-step = 3;
        };
      };
      programs.firefox = {
        enable = true;
        profiles = {
          default = {
            settings = {
              # https://raw.githubusercontent.com/pyllyukko/user.js/master/user.js
              "toolkit.zoomManager.zoomValues" = "1,1.7,2,2.3";
              "browser.urlbar.quicksuggest.enabled" = false;
              "browser.backspace_action" = 0;
              "browser.search.suggest.enabled" = false;
              "browser.urlbar.suggest.searches" = false;
              "browser.casting.enabled" = false;
              "media.gmp-gmpopenh264.enabled" = false;
              "media.gmp-manager.url" = "";
              "network.http.speculative-parallel-limit" = 0;
              "browser.aboutHomeSnippets.updateUrl" = "";
              "browser.search.update" = false;
              "browser.topsites.contile.enabled" = false;
              "browser.newtabpage.activity-stream.feeds.topsites" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" =
                false;
              "network.dns.blockDotOnion" = true;
              "browser.uidensity" = 1;
              "dom.security.https_only_mode" = true;
              "general.smoothScroll" = false;
              "media.ffmpeg.vaapi.enabled" = true;
              "media.ffmpeg.low-latency.enabled" = true;
              "media.navigator.mediadatadecoder_vpx_enabled" = true;
              "browser.chrome.site_icons" = false;
              "browser.tabs.firefox-view" = false;
              "browser.contentblocking.category" = "strict";
              "apz.allow_double_tap_zooming" = false;
              "apz.allow_zooming" = false;
              "apz.gtk.touchpad_pinch.enabled" = false;
              "privacy.resistFingerprinting" = true;
              "webgl.min_capability_mode" = true;
              "dom.serviceWorkers.enabled" = false;
              "dom.webnotifications.enabled" = false;
              "dom.enable_performance" = false;
              "dom.enable_user_timing" = false;
              "dom.webaudio.enabled" = false;
              "geo.enabled" = false;
              "geo.wifi.uri" =
                "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
              "geo.wifi.logging.enabled" = false;
              "dom.mozTCPSocket.enabled" = false;
              "dom.netinfo.enabled" = false;
              "dom.network.enabled" = false;
              "media.peerconnection.ice.no_host" = true;
              "dom.battery.enabled" = false;
              "dom.telephony.enabled" = false;
              "beacon.enabled" = false;
              "dom.event.clipboardevents.enabled" = false;
              "dom.allow_cut_copy" = false;
              "media.webspeech.recognition.enable" = false;
              "media.webspeech.synth.enabled" = false;
              "device.sensors.enabled" = false;
              "browser.send_pings" = false;
              "browser.send_pings.require_same_host" = true;
              "dom.gamepad.enabled" = false;
              "dom.vr.enabled" = false;
              "dom.vibrator.enabled" = false;
              "dom.archivereader.enabled" = false;
              "webgl.disabled" = true;
              "webgl.disable-extensions" = true;
              "webgl.disable-fail-if-major-performance-caveat" = true;
              "webgl.enable-debug-renderer-info" = false;
              "javascript.options.wasm" = false;
              "camera.control.face_detection.enabled" = false;
              "browser.search.countryCode" = "US";
              "browser.search.region" = "US";
              "browser.search.geoip.url" = "";
              "intl.accept_languages" = "en-US = en";
              "intl.locale.matchOS" = false;
              "browser.search.geoSpecificDefaults" = false;
              "clipboard.autocopy" = false;
              "javascript.use_us_english_locale" = true;
              "browser.urlbar.trimURLs" = false;
              "browser.fixup.alternate.enabled" = false;
              "browser.fixup.hide_user_pass" = true;
              "network.proxy.socks_remote_dns" = true;
              "network.manage-offline-status" = false;
              "security.mixed_content.block_active_content" = true;
              "security.mixed_content.block_display_content" = true;
              "network.jar.open-unsafe-types" = false;
              "security.xpconnect.plugin.unrestricted" = false;
              "javascript.options.asmjs" = false;
              "gfx.font_rendering.opentype_svg.enabled" = false;
              "browser.urlbar.filter.javascript" = true;
              "media.video_stats.enabled" = false;
              "general.buildID.override" = "20100101";
              "browser.startup.homepage_override.buildID" = "20100101";
              "browser.display.use_document_fonts" = 0;
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr" =
                false;
              "devtools.webide.enabled" = false;
              "devtools.webide.autoinstallADBHelper" = false;
              "devtools.webide.autoinstallFxdtAdapters" = false;
              "devtools.debugger.remote-enabled" = false;
              "devtools.chrome.enabled" = false;
              "devtools.debugger.force-local" = true;
              "dom.flyweb.enabled" = false;
              "privacy.userContext.enabled" = true;
              "privacy.resistFingerprinting.block_mozAddonManager" = true;
              "extensions.webextensions.restrictedDomains" = "";
              "network.IDN_show_punycode" = true;
              "browser.urlbar.autoFill" = false;

            };
          };
        };
      };
      programs.ssh = {
        enable = true;
        hashKnownHosts = true;
        matchBlocks = let
          dotSshPath =
            "${config.home-manager.users.yc.home.homeDirectory}/.ssh/";
        in {
          "github.com" = {
            # github.com:ne9z
            user = "git";
            identityFile = dotSshPath + "yc";
          };
          "gitlab.com" = {
            # gitlab.com:john8931
            user = "git";
            identityFile = dotSshPath + "tub_latex_repo_key";
          };
          "tl.yc" = {
            user = "yc";
            identityFile = dotSshPath + "yc";
            port = 65222;
          };
          "3ldetowqifu5ox23snmoblv7xapkd26qyvex6fwrg6zpdwklcatq.b32.i2p" = {
            user = "yc";
            identityFile = dotSshPath + "yc";
            port = 65222;
            proxyCommand = "${pkgs.libressl.nc}/bin/nc -x localhost:4447 %h %p";
          };
        };
      };
      programs.foot = {
        enable = true;
        server.enable = true;
        settings = {
          main = {
            term = "xterm-256color";
            font = "monospace:size=15";
            dpi-aware = "yes";
          };

          url = { launch = "wl-copy \${url}"; };
          mouse = { hide-when-typing = "yes"; };
          cursor = { color = "000000 ffffff"; };
          colors = {
            alpha = "1.0";
            background = "000000";
            foreground = "ffffff";
          };
        };
      };
      xdg = {
        mimeApps = {
          enable = true;
          defaultApplications = {
            "application/pdf" = "org.pwmt.zathura.desktop";
            "inode/directory" = "emacsclient.desktop";
            "text/plain" = "emacsclient.desktop";
            "text/org" = "emacsclient.desktop";
            "text/x-tex" = "emacsclient.desktop";
            "text/english" = "emacsclient.desktop";
            "text/x-makefile" = "emacsclient.desktop";
            "text/x-c++hdr" = "emacsclient.desktop";
            "text/x-c++src" = "emacsclient.desktop";
            "text/x-chdr" = "emacsclient.desktop";
            "text/x-csrc" = "emacsclient.desktop";
            "text/x-java" = "emacsclient.desktop";
            "text/x-moc" = "emacsclient.desktop";
            "text/x-pascal" = "emacsclient.desktop";
            "text/x-tcl" = "emacsclient.desktop";
            "application/x-shellscript" = "emacsclient.desktop";
            "text/x-c" = "emacsclient.desktop";
            "text/x-c++" = "emacsclient.desktop";
            "x-scheme-handler/mailto" = "emacsclient-mail.desktop";
          };
        };
        configFile = {
          "xournalpp/settings.xml" = {
            source = ./not-nix-config-files/xournalpp-settings.xml;
          };
          "xournalpp/toolbar.ini" = {
            source = ./not-nix-config-files/xournalpp-toolbar.ini;
          };
          "qt5ct/qt5ct.conf" = {
            source = ./not-nix-config-files/xournalpp-toolbar.ini;
          };
          "sway/yc-sticky-keymap" = {
            source = ./not-nix-config-files/sway-yc-sticky-keymap;
          };
          "latexmk/latexmkrc" = { text = ''$pdf_previewer = "zathura"''; };
          "emacs/init.el" = { source = ./not-nix-config-files/emacs-init.el; };
          "yc.sh" = { source = ./not-nix-config-files/bashrc-config.sh; };
          "w3m/bookmark.html" = {
            source = ./not-nix-config-files/w3m-bookmark.html;
          };
          "fuzzel/fuzzel.ini" = {
            text = ''
              [main]
              font=Noto Sans:size=18:weight=bold'';
          };
          "w3m/config" = { source = ./not-nix-config-files/w3m-config; };
          "w3m/keymap" = { source = ./not-nix-config-files/w3m-keymap; };
        };

      };
      programs.password-store = {
        enable = true;
        package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
        settings = {
          PASSWORD_STORE_GENERATED_LENGTH = "8";
          PASSWORD_STORE_CHARACTER_SET = "[:alnum:].,";
          PASSWORD_STORE_DIR = "$HOME/.password-store";
        };
      };
      programs.waybar = {
        enable = true;
        style = ./not-nix-config-files/waybar-style.css;
        systemd = {
          enable = true;
          target = "sway-session.target";
        };
        settings = {
          mainBar = {
            id = "bar-0";
            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                activated = "NOLOCK";
                deactivated = "LOCK";
              };
            };
            ipc = true;
            layer = "bottom";
            modules-center = [ "wlr/taskbar" ];
            modules-left = [ "sway/workspaces" "sway/mode" ];
            modules-right = [
              "idle_inhibitor"
              "pulseaudio"
              "network"
              "backlight"
              "battery"
              "clock"
            ];
            position = "bottom";
            network = {
              format = "{ifname}";
              format-disconnected = "";
              format-ethernet = "{ipaddr}/{cidr}";
              format-wifi = "NET";
              max-length = 50;
              tooltip-format = "{ifname} via {gwaddr}";
              tooltip-format-disconnected = "Disconnected";
              tooltip-format-ethernet = "{ifname}";
              tooltip-format-wifi = "{essid} ({signalStrength}%)";
            };
            pulseaudio = {
              format = "VOL {volume}%";
              format-muted = "MUTED";
              on-click = "amixer set Master toggle";
            };
            backlight = {
              device = "intel_backlight";
              format = "BRI {percent}%";
              on-click-right = "brightnessctl set 100%";
              on-click = "brightnessctl set 1%";
              on-scroll-down = "brightnessctl set 1%-";
              on-scroll-up = "brightnessctl set +1%";
            };
            "wlr/taskbar" = {
              active-first = true;
              format = "{name}";
              on-click = "activate";
            };
            battery = { format = "BAT {capacity}%"; };
            clock = { format-alt = "{:%a, %d. %b  %H:%M}"; };
            "sway/workspaces" = {
              disable-scroll-wraparound = true;
              enable-bar-scroll = true;
            };

          };
        };
      };
      services.swayidle = {
        enable = true;
        events = [
          {
            event = "before-sleep";
            command = "${pkgs.swaylock}/bin/swaylock";
          }
          {
            event = "lock";
            command = "lock";
          }
        ];
        timeouts = [
          {
            timeout = 900;
            command = "${pkgs.swaylock}/bin/swaylock -fF";
          }
          {
            timeout = 910;
            command = "systemctl suspend";
          }
        ];
      };
      programs.swaylock.settings = {
        color = "808080";
        font-size = 24;
        indicator-idle-visible = true;
        indicator-radius = 100;
        line-color = "ffffff";
        show-failed-attempts = true;
      };
      wayland.windowManager.sway = {
        enable = true;
        # this package is installed by NixOS
        # not home-manager
        package = null;
        xwayland = false;
        systemdIntegration = true;
        extraConfig = ''
          mode "default" {
           bindsym --no-warn Mod4+Backspace focus mode_toggle
           bindsym --no-warn Mod4+Control+Shift+Space move left
           bindsym --no-warn Mod4+Control+Space move right
           bindsym --no-warn Mod4+Control+b move left
           bindsym --no-warn Mod4+Control+e focus parent; focus right
           bindsym --no-warn Mod4+Control+f move right
           bindsym --no-warn Mod4+Control+n move down
           bindsym --no-warn Mod4+Control+p move up
           bindsym --no-warn Mod4+Shift+Backspace floating toggle
           bindsym --no-warn Mod4+Shift+Space focus left
           bindsym --no-warn Mod4+Space focus right
           bindsym --no-warn Mod4+b focus left
           bindsym --no-warn Mod4+e focus parent
           bindsym --no-warn Mod4+f focus right
           bindsym --no-warn Mod4+f11 fullscreen
           bindsym --no-warn Mod4+k kill
           bindsym --no-warn Mod4+n focus down
           bindsym --no-warn Mod4+o workspace next
           bindsym --no-warn Mod4+p focus up
           bindsym --no-warn Mod4+w move scratchpad
           bindsym --no-warn Mod4+x workspace back_and_forth
           bindsym --no-warn Mod4+y scratchpad show
           bindsym --no-warn Shift+Print exec ${pkgs.grim}/bin/grim
           bindsym --no-warn Mod4+o exec ${pkgs.foot}/bin/foot ${pkgs.tmux}/bin/tmux attach-session
          }

          mode "resize" {
           bindsym --no-warn b resize shrink width 10px
           bindsym --no-warn f resize grow width 10px
           bindsym --no-warn n resize grow height 10px
           bindsym --no-warn p resize shrink height 10px
           bindsym --no-warn Space mode default
          }
          titlebar_padding 1
          titlebar_border_thickness 0
        '';
        config = {
          modes = {
            default = { };
            resize = { };
          };
          seat = {
            "*" = {
              hide_cursor = "when-typing enable";
              xcursor_theme = "Adwaita 48";
            };
          };
          output = {
            DP-1 = { mode = "2560x1440@60Hz"; };
            DP-2 = { mode = "2560x1440@60Hz"; };
          };
          input = {
            "type:keyboard" =
              (if (config.my.per-user.yc.modules.keyboard.enable) then {
                xkb_file = "$HOME/.config/sway/yc-sticky-keymap";
              } else
                { });
            "type:touchpad" = {
              tap = "enabled";
              natural_scroll = "enabled";
              middle_emulation = "enabled";
              scroll_method = "edge";
              pointer_accel = "0.3";
            };
            "1149:8257:Kensington_Kensington_Slimblade_Trackball" = {
              left_handed = "enabled";
              pointer_accel = "1";
            };
          };
          modifier = "Mod4";
          menu = "${pkgs.fuzzel}/bin/fuzzel";
          startup = [{
            command = "systemctl --user restart waybar";
            always = true;
          }];
          terminal =
            "${pkgs.foot}/bin/foot ${pkgs.tmux}/bin/tmux attach-session";
          window = { hideEdgeBorders = "both"; };
          workspaceAutoBackAndForth = true;
          workspaceLayout = "tabbed";
          focus = {
            followMouse = "always";
            # wrapping = "force";
            forceWrapping = true;
          };
          gaps = {
            smartBorders = "no_gaps";
            smartGaps = true;
          };
          bars = [{
            command = "${pkgs.waybar}/bin/waybar";
            id = "bar-0";
            mode = "hide";
            position = "bottom";
          }];
        };
      };
    };
  };
}
