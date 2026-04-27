{ inputs, config, ... }:

{
  imports = [
    inputs.llmbot.nixosModules.default
  ];

  age.secrets.llmbot-environment = {
    file = ../secrets/llmbot-environment.age;
    owner = "llmbot";
    group = "llmbot";
  };

  services.llmbot = {
    enable = true;
    environmentFile = config.age.secrets.llmbot-environment.path;
    model = "claude-haiku-4-5";
  };

  systemd.services.llmbot.environment = {
    WEBUI_HOST = "127.0.0.1";
    WEBUI_PORT = "8085";
  };

  services.nginx.virtualHosts."llmbot-admin.i.graysonhead.net" = {
    useACMEHost = "llmbot-admin.i.graysonhead.net";
    forceSSL = true;
    extraConfig = ''
      allow 10.5.0.0/16;
      allow 2605:a601:a0a6:6c00::/64;
      deny all;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:8085";
      proxyWebsockets = true;
    };
  };
}
