# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let 
  clashConfigPath = "/etc/myconfig/clash";
  zshConfigPath = "/etc/myconfig/zsh";
  dockerConfigPath = "/etc/myconfig/docker-compose";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.network.ssh.enable = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  ##### KDE config #####
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    gwenview
    okular
    oxygen
    khelpcenter
    #konsole
    plasma-browser-integration
    print-manager
  ];
  ##### KDE config #####

  ###### user config #####
  users.users.yly = {
    isNormalUser = true;
    home = "/home/yly";
    extraGroups = [ "audio" "networkmanager" "network" "wheel" "video" "libvirt" "docker" "vboxusers" ];
    hashedPassword = "$6$MHD44lZkFNlW9/xd$SO8ZIZB/jRtT1T86IjdEZ8PNfEKErDguozNeC.5LDk9yz0UJPz4gy1QGUIPBKmYVil7m0c76oeWnSkbZLThYK/";
  };
  ###### user config #####
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  ###### sound config ######
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  ###### sound config ######
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  ###### nvidia config ######
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  ###### nvidia config ######

  ###### font config ######
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-han-sans
    source-han-serif
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  ###### font config ######

  ###### oh my zhs config ######
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    shellInit = ''
    export ZDOTDIR=${zshConfigPath}
    export http_proxy="http://127.0.0.1:7890"
    export https_proxy="http://127.0.0.1:7890"
    '';
    ohMyZsh = {
      enable = true;
      plugins = ["git" "man"];
      theme = "robbyrussell";
    };
  };
  ###### oh my zhs config ######

  ###### proxychains config #####
  programs.proxychains.enable = true;
  programs.proxychains.proxies = {
    x1 = {
      type = "socks4";
      host = "127.0.0.1";
      port = 7891;
      enable = true;
    };
    y1 = {
      type = "socks5";
      host = "127.0.0.1";
      port = 7891;
      enable = true;
    };
    x2 = {
      type = "http";
      host = "127.0.0.1";
      port = 7890;
      enable = true;
    };
  };
  ###### proxychains config #####

  ###### unfree ######
  nixpkgs.config.allowUnfree = true;
  ###### unfree ######

  ###### input method config ######
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-chinese-addons ];
  environment.variables = {
    GTK_IM_MODULE="fcitx";
    QT_IM_MODULE="fcitx";
    XMODIFIERS="@im=fcitx";
    SDL_IM_MODULE="fcitx";
    GLFW_IM_MODULE="ibus";
  };
  ###### input method config ######

  ###### nixos feature config ######
  nix.extraOptions = ''
  experimental-features = nix-command flakes
  '';
  ###### nixos feature config ######

  ###### docker config ######
  virtualisation = {
    docker.enable = true;
  };
  ###### docker config ######

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    vim wget
    git git-crypt
    gnupg clash
    firefox yesplaymusic
    docker-compose
    gcc
    qq
    ###### vscode config ######
    (vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions; [
      #aaron-bond.better-comments 
      alefragnani.bookmarks 
      alefragnani.project-manager 
      #antfu.iconify 
      bbenoist.nix 
      bradlc.vscode-tailwindcss 
      christian-kohler.path-intellisense 
      #clinyong.vscode-css-modules 
      codezombiech.gitignore 
      #cschlosser.doxdocgen 
      #csstools.postcss 
      davidanson.vscode-markdownlint 
      dbaeumer.vscode-eslint 
      #donjayamanne.python-environment-manager 
      #dsznajder.es7-react-js-snippets 
      eamodio.gitlens 
      editorconfig.editorconfig 
      edonet.vscode-command-runner 
      #elemefe.vscode-element-helper 
      #eriklynd.json-tools 
      esbenp.prettier-vscode 
      #felipecaputo.git-project-manager 
      formulahendry.auto-close-tag 
      formulahendry.code-runner 
      golang.go 
      gruntfuggly.todo-tree 
      #hbenl.vscode-test-explorer 
      humao.rest-client 
      #jingwang37.element-plus-snippets 
      johnpapa.vscode-peacock 
      #leetcode.vscode-leetcode 
      lokalise.i18n-ally 
      #mgmcdermott.vscode-language-babel 
      mhutchie.git-graph 
      mikestead.dotenv 
      ms-azuretools.vscode-docker 
      ms-ceintl.vscode-language-pack-zh-hans 
      #ms-python.isort 
      ms-python.python 
      ms-python.vscode-pylance 
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap 
      ms-toolsai.jupyter-renderers 
      ms-toolsai.vscode-jupyter-cell-tags 
      ms-toolsai.vscode-jupyter-slideshow 
      ms-vscode.cmake-tools 
      #ms-vscode.cpptools-extension-pack 
      #ms-vscode.cpptools-themes 
      ms-vscode.cpptools
      #ms-vscode.remote-explorer 
      ms-vscode-remote.remote-ssh 
      naumovs.color-highlight 
      #nickdemayo.vscode-json-editor 
      njpwerner.autodocstring 
      oderwat.indent-rainbow 
      pkief.material-icon-theme 
      redhat.vscode-yaml 
      ritwickdey.liveserver 
      #sachinb94.css-tree 
      shd101wyy.markdown-preview-enhanced 
      #steoates.autoimport 
      #stylelint.vscode-stylelint 
      #syler.sass-indented 
      #tomasvergara.vscode-fontawesome-gallery 
      twxs.cmake 
      #tyriar.lorem-ipsum 
      #voorjaar.windicss-intellisense 
      vscode-icons-team.vscode-icons 
      vscodevim.vim 
      #vue.volar
      #vue.vscode-typescript-vue-plugin 
      #wayou.vscode-todo-highlight 
      #yzdel2000.uni-app-devtools 
      yzhang.markdown-all-in-one 
      zhuangtongfa.material-theme
    ] ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "multi-command";
            publisher = "ryuta46";
            version = "1.6.0";
            sha256 = "sha256-AnHN1wvyVrZRlnOgxBK7xKLcL7SlAEKDcw6lEf+2J2E=";
          }
          ###### java ext config ######
          {
            name = "vscode-java-pack";
            publisher = "vscjava";
            version = "0.25.2023052400";
            sha256 = "sha256-9Fboo740U5MfaPDGMbwmoW+Du8iK2t6547olfmKdvgE=";
          }
          {
            name = "vscode-boot-dev-pack";
            publisher = "vmware";
            version = "0.2.1";
            sha256 = "sha256-3l9M0wai9aYqZNka7a+AY1YyfYHaiDfd6MYzFmsuG9g=";
          }
          ###### java ext config ######
        ];
    })
    ###### vscode config ######
  ];
  environment.etc= {
    clashconfig = { source = ./config/clash; target = "./myconfig/clash"; };
    zshconfig = { source = ./config/zsh; target = "./myconfig/zsh"; };
    dockerconfig = { source = ./config/docker-compose; target = "./myconfig/docker-compose"; } ;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # services.openssh.extraConfig = ''PermitRootLogin "yes"'';
  services.openssh.settings.PermitRootLogin = "yes";
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
    
  systemd.services.clash = {
    description = "auto started clash";
    serviceConfig.ExecStart = ''
    /run/current-system/sw/bin/clash -d ${clashConfigPath}
    '';
    wantedBy = ["multi-user.target"];
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

