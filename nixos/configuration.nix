{ config, pkgs, ... }:

{
  # System settings
  imports = [ ./hardware-configuration.nix ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
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

  # Enable sudo for wheel group
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Enable SSH service
  services.openssh.enable = true;

  # Enable NetworkManager
  networking.networkmanager.enable = true;

  # Packages to install
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
  ];

  # Enable the OpenSSH daemon
  services.openssh.enable = true;

  # Firewall configuration
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.enable = true;
}
