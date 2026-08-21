{ config, pkgs, ... }:

let
    dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
    create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    configs = {
      nvim = "nvim";
      qtile = "qtile";
      rofi = "rofi";
      kitty = "kitty";
      hypr = "hypr";
      waybar = "waybar";
    };
in

{
  # define main user
  home.username = "Jasper";
  home.homeDirectory = "/home/Jasper";
  home.stateVersion = "26.05";
  programs.bash = {
    enable = true;
    shellAliases = {
      nixos-upgrade = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-btw";
    };
  };

  # define config autoimport function
  xdg.configFile = builtins.mapAttrs 
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    }) 
    configs;

  # setup cursor
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.kdePackages.breeze;
    name = "breeze_cursors";
    size = 24;
  };
  home.file.".icons/default".source = "${pkgs.kdePackages.breeze}/share/icons/breeze_cursors";

  # install and configure git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Jasper M-B";
        email = "jaspermackain@gmail.com";
      };
      init.defaultBranch = "main";
    };
    settings.credential = {
      helper = "manager";
      "https://github.com".username = "jjnimbletwit";
      credentialStore = "cache";
    };
  };

  # setup music
  programs.ncspot = {
    enable = true;
    package = (pkgs.ncspot.override {
      withCover = true;
      withMPRIS = true;
    }).overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ./patches/ncspot-kitty-cover.patch
      ];
      postPatch = ''
        substituteInPlace src/ui/cover.rs \
          --replace-fail '@KITTY@' '${pkgs.kitty}/bin/kitty'
      '';
    });
  };

  # configure GTK
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # gnome apps dark theme (file manager)
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # install user packages
  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    rofi
    fastfetch
    git
    pavucontrol
    protontricks
    lutris
    protonup-qt
    overskride
    grim
    slurp
    wl-clipboard
    nautilus
    qview
    heroic
    playerctl
    git-credential-manager
    vesktop
    kitty
    killall
  ];
}
