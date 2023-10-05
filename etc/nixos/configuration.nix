{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdc";
  boot.loader.grub.useOSProber = true;

# Host name / computer name
  networking.hostName = "orangebox"; 

  # Enable networking
  networking.networkmanager.enable = true; 
 # Set your time zone.
  time.timeZone = "Asia/Riyadh";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sahmed011 = {
    isNormalUser = true;
    description = "sahmed011";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      firefox
      cargo
      vscodium
      chezmoi
      git
      krita
      youtube-dl
      zfxtop
      neofetch
      bfg-repo-cleaner
      traceroute
      alejandra
      cava
      cmus
      neovim
      curl
      wget
      latte-dock
      trashy
      cheat
      gparted
      waybar
      unzip
      tuifeed
      vlc
      kate
      speedtest-cli
      kdenlive
      obs-studio
      glow
      ffmpeg
      bat
      prismlauncher
      gh
      zoom-us
      unzip
      lsd
      fd
      github-desktop
      catimg
      gnumake
      krename
      armcord
  ];
  
  # Before changing this value read the documentation for this option
  system.stateVersion = "23.05"; # Did you read the comment?

# Enable flatpak
services.flatpak.enable = true;

# Automatic Garbage Collection
nix.gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 7d";
        };

# All my aliases :D
programs.bash.shellAliases = {
  l = "lsd -alh";
  ll = "lsd -l";
  ls = "lsd";
  confignix="sudo nano /etc/nixos/configuration.nix";
  reloadnix="sudo nixos-rebuild switch";
  ztop="zfxtop";
  editrc="codium /home/sahedm011/Data/Dotfiles/startup.sh";
  startwifi="sudo systemctl start wpa_supplicant";
  gcnix="nix-collect-garbage";
  qq="clear";
  cat="bat";
  tr="trash";
};

# Enable NoiseTorch (real time background noise supression for my mic)
programs.noisetorch.enable = true;

# Set my default KDE  session to Wayland
services.xserver.displayManager.defaultSession = "plasmawayland";

# Set my prompt
# programs.bash.promptInit = '' PS1="\[\e[38;5;214;1;3m\]orange\[\e[23;38;5;199m\]@\[\e[0;38;5;51m\]\w\[\e[38;5;46;1m\]>\[\e[0m\]" '';
programs.starship.enable = true;

#Some dependanciies that were marked insecure, this is here to allow them
nixpkgs.config.permittedInsecurePackages = [
                "openssl-1.1.1v"
                 "electron-12.2.3"
              ];
# Allow unfree packages
nixpkgs.config.allowUnfree = true;

# Enable experimental nix features
nix.settings.experimental-features = [ "nix-command" "flakes" ];

# auto store optimization
nix.settings.auto-optimise-store = true;


}
