{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # enable NTFS for games drive
  boot.supportedFilesystems = [ "ntfs" ];

  # mount the games drive
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/261E431A1E42E303";
    fsType = "ntfs3";
    options = [ "rw" "uid=1000" "nofail" ];
  };

  # allow for closed-source pkgs such as steam
  nixpkgs.config.allowUnfreePredicate = _: true;

  # enable XDG (dependecy for certain features)
  xdg.portal.enable = true;
  xdg.portal.config.common.default = "*";

  # allow flatpak packages to be installed
  services.flatpak.enable = true;

  # configure bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # setup graphics drivers (RTX 3070)
  hardware = {
    graphics.enable = true;
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # setup internet and local networking
  networking.hostName = "nixos-btw"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";


  # setup desktop environment
  services.xserver = {
  	enable = true;
	autoRepeatDelay = 200;
	autoRepeatInterval = 35;
	windowManager.qtile.enable = true;
  };
  services.displayManager.ly.enable = true;

  # Configure keymap in X11 (DEFAULT LAYOUT MATCHES HOME KB)
  services.xserver.xkb.layout = "us";

  # Enable CUPS to print documents (NO PRINTER AT HOME UNNECESSARY)
  # services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.Jasper = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # configure steam
  programs.steam= {
    enable = true;
    extraPackages = with pkgs; [
      kdePackages.breeze
    ];
  };

  # configure proper cursor in steam
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraEnv = {
        XCURSOR_THEME = "breeze_cursors";
        XCURSOR_SIZE = "24";
      };
    };
  };
  hardware.steam-hardware.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    alacritty
    kdePackages.breeze
    kdePackages.breeze-icons
    firefox
  ];

  # fonts for final system
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # enable the firewall
  networking.firewall.enable = true;

  # Original NixOS version
  system.stateVersion = "26.05";

  # enable kernel controller support
  boot.kernelModules = [ "uinput" ];
  
  # enable bluetooth support
  hardware.bluetooth = {
    package = pkgs.bluez;
    enable = true;
    powerOnBoot = true;
    settings.General.AutoConnect = true;
    settings.General.Enable = "Source,Sink,Media,Socket";
  };

  # install flatpak packages
  services.flatpak.uninstallUnmanaged = true;
  services.flatpak.update.onActivation = true;
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly";
  };
  services.flatpak.packages = [
    "org.vinegarhq.Sober"
  ];
}
