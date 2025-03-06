{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # System settings
  networking.hostName = "nixos";
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "ter-132n";
    keyMap = "us";
  };

  # User configuration
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "user";
  };

  # Enable sudo for wheel group (password required)
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;

  # SSH
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "no";
  };

  # Networking and Firewall
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Packages to install
  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    wget
    btop
    duf
    eza
    yazi
  ];
}
