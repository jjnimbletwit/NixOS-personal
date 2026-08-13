{ config, pkgs, ... }:

let
    dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
    create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    configs = {
      nvim = "nvim";
      qtile = "qtile";
      alacritty = "alacritty";
      rofi = "rofi";
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

  # install user packages
  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    alacritty
    rofi
    fastfetch
    git
    pavucontrol
    protontricks
    lutris
    protonup-qt
    overskride
    prismlauncher
    grim
    slurp
    wl-clipboard
    nautilus
    qview
    heroic
    ncspot
    playerctl
    git-credential-manager
  ];
}
