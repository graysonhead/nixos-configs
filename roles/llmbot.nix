{ inputs, config, ... }:

{
  imports = [
    inputs.llmbot.nixosModules.default
  ];

  age.secrets.llmbot-discord-token = {
    file = ../secrets/llmbot-discord-token.age;
  };

  age.secrets.llmbot-system-message = {
    file = ../secrets/llmbot-system-message.age;
    owner = "llmbot";
    group = "llmbot";
  };

  services.llmbot = {
    enable = true;
    discordTokenFile = config.age.secrets.llmbot-discord-token.path;
    searxngUrl = "https://search.graysonhead.net/search";
    systemMessageFile = config.age.secrets.llmbot-system-message.path;
  };
}
