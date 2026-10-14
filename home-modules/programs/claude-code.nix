{ config, pkgs, lib, ... }:

let
  unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  }) {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "claude-code"
      ];
    };
  };

  # Fetch plugins from GitHub
  ecc-src = builtins.fetchGit {
    url = "https://github.com/affaan-m/ecc";
    ref = "main";
  };

  # ecc hooks require() npm deps (js-yaml, ajv, ...), so ship node_modules with the source
  ecc-plugin = pkgs.buildNpmPackage {
    pname = "ecc-plugin";
    version = "main";
    src = ecc-src;
    # shortcut: ref = "main" is unpinned, so this hash breaks when upstream changes package-lock.json; replace with the "got:" hash from the error
    npmDepsHash = "sha256-7LlvomrqaKVpNF87F/i2foPpsJA4MTo+o4Jhorl/hBw=";
    npmInstallFlags = [ "--omit=dev" ];
    dontNpmBuild = true;
    installPhase = "cp -r . $out";
  };

  ponytail-plugin = builtins.fetchGit {
    url = "https://github.com/dietrichgebert/ponytail";
    ref = "main";
  };
in
{
  home.packages = [
    unstable.claude-code
    # ecc plugin hooks shell out to `node`
    pkgs.nodejs
  ];

  # ~/.claude.json must stay writable (Claude stores onboarding/trust state there),
  # so merge managed keys into it on activation instead of symlinking it.
  home.activation.claudeJson = lib.hm.dag.entryAfter [ "linkGeneration" ] (
    let
      managed = builtins.toJSON {
        theme = "dark";
        hasCompletedOnboarding = true;
        mcpServers = {
          codegraph = {
            type = "stdio";
            command = "bunx";
            args = [ "-y" "@colbymchenry/codegraph" "serve" "--mcp" ];
          };
        };
      };
      trustedRoots = [ "/opt/projects/Conio" "${config.home.homeDirectory}/dev" ];
    in ''
      claude_json="$HOME/.claude.json"
      if [ -L "$claude_json" ]; then
        content="$(cat "$claude_json")"
        rm "$claude_json"
        printf '%s' "$content" > "$claude_json"
      fi
      [ -s "$claude_json" ] || echo '{}' > "$claude_json"

      trusted=()
      for root in ${lib.escapeShellArgs trustedRoots}; do
        [ -d "$root" ] || continue
        trusted+=("$root")
        for d in "$root"/*/; do
          [ -d "$d" ] && trusted+=("''${d%/}")
        done
      done

      tmp="$(mktemp)"
      ${pkgs.jq}/bin/jq --argjson managed ${lib.escapeShellArg managed} '
        (. + $managed)
        | reduce $ARGS.positional[] as $p (.;
            .projects[$p] = ((.projects[$p] // {}) + { hasTrustDialogAccepted: true }))
      ' "$claude_json" --args "''${trusted[@]}" > "$tmp"
      mv "$tmp" "$claude_json"
      chmod 600 "$claude_json"
    ''
  );

  # Settings: theme, output style, permissions, and plugins
  home.file.".claude/settings.json".text = builtins.toJSON {
    theme = "dark";
    outputStyle = "Concise";
    permissions = {
      allow = [];
      deny = [];
    };
    # Plugin ids are "<plugin>@<marketplace>". Both repos ship a marketplace.json,
    # so register the nix-fetched checkouts as local marketplaces and let Claude Code
    # manage ~/.claude/plugins/installed_plugins.json itself (it must stay writable).
    extraKnownMarketplaces = {
      ecc.source = { source = "directory"; path = "${ecc-plugin}"; };
      ponytail.source = { source = "directory"; path = "${ponytail-plugin}"; };
    };
    enabledPlugins = {
      "ecc@ecc" = true;
      "ponytail@ponytail" = true;
    };
  };
}
