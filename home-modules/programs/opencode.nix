{ config, pkgs, lib, ... }:

let
  unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  }) {};
in
{
  programs.opencode = {
    enable = true;
    package = unstable.opencode;
  };
  
  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    plugin = [ "oh-my-openagent" "dietrichgebert/ponytail" ];
    lsp = {};
    mcp = {
      codegraph = {
        type = "local";
        command = [ "bunx" "-y" "@colbymchenry/codegraph" "serve" "--mcp" ];
        enabled = true;
      };
    };
  };

  xdg.configFile."opencode/oh-my-openagent.jsonc".text = builtins.toJSON {
    "$schema" = "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/oh-my-opencode.schema.json";

    sisyphus = {
      max_concurrent_tasks = 2;
    };
    
    agents = {
      sisyphus = {
        model = "opencode/big-pickle";
        fallback_models = [ "opencode/kimi-k2.5-free" ];
      };
      sisyphus-junior = {
        model = "opencode/big-pickle";
        fallback_models = [ "opencode/kimi-k2.5-free" ];
      };
      prometheus = {
        model = "opencode/deepseek-flash";
        fallback_models = [
          "google/gemini-2.5-flash"
          "opencode/big-pickle"
        ];
      };
      metis = {
        model = "opencode/deepseek-flash";
        fallback_models = [
          "opencode/big-pickle"
          "google/gemini-2.5-flash"
        ];
      };
      momus = {
        model = "opencode/deepseek-flash";
        fallback_models = [
          "opencode/big-pickle"
          "google/gemini-2.5-flash"
        ];
      };
      atlas = {
        model = "opencode/big-pickle";
        fallback_models = [ "opencode/kimi-k2.5-free" ];
      };
      oracle = {
        model = "opencode/deepseek-flash";
        fallback_models = [
          "google/gemini-2.5-flash"
          "opencode/big-pickle"
        ];
      };
      multimodal-looker.model = "google/gemini-2.5-flash";
      hephaestus.disabled = true;
    };
  };
}
