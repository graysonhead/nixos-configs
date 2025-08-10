{ inputs, config, ... }:

{
  imports = [
    inputs.llmbot.nixosModules.default
  ];

  age.secrets.llmbot-discord-token = {
    file = ../secrets/llmbot-discord-token.age;
  };

  age.secrets.llmbot-openwebui-api-key = {
    file = ../secrets/llmbot-openwebui-api-key.age;
  };

  services.llmbot = {
    enable = true;
    serverUrl = "http://hal.i.graysonhead.net:8125/ollama/v1";
    discordTokenFile = config.age.secrets.llmbot-discord-token.path;
    openwebuiApiKeyFile = config.age.secrets.llmbot-openwebui-api-key.path;
  };
}
