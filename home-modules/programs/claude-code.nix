{ config, pkgs, lib, ... }:

let
  unstable = import (builtins.fetchTarball {
    # pinned: bump rev + sha256 (nix-prefetch-url --unpack <url>) to update
    url = "https://github.com/NixOS/nixpkgs/archive/3ec636362e1816bc2f0888fa0fa2c69f1bc9e504.tar.gz";
    sha256 = "177diqkiwphjyqpk2n6nisayx840x28ksvq99kkyi2xsn37fp4md";
  }) {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "claude-code"
      ];
    };
  };

  # Fetch plugins from GitHub, pinned: bump rev (git ls-remote <url> main) to update
  ecc-src = builtins.fetchGit {
    url = "https://github.com/affaan-m/ecc";
    rev = "25278e7d7b6cf6e6a4e7a6c8e10f14ff22f0eb5b";
  };

  # ecc hooks require() npm deps (js-yaml, ajv, ...), so ship node_modules with the source
  ecc-plugin = pkgs.buildNpmPackage {
    pname = "ecc-plugin";
    version = "main";
    src = ecc-src;
    # deps come from package-lock.json integrity hashes, so no npmDepsHash to bump with rev
    npmDeps = pkgs.importNpmLock {
      npmRoot = ecc-src;
      # deps get rewritten to file: paths, so overrides of direct deps must use npm's "$dep" form or npm fails with EOVERRIDE
      package = let p = lib.importJSON "${ecc-src}/package.json"; in
        lib.recursiveUpdate p {
          overrides = lib.mapAttrs (n: v: "$" + n) (lib.intersectAttrs p.dependencies p.overrides);
        };
    };
    npmConfigHook = pkgs.importNpmLock.npmConfigHook;
    npmInstallFlags = [ "--omit=dev" ];
    dontNpmBuild = true;
    installPhase = "cp -r . $out";
  };

  ponytail-plugin = builtins.fetchGit {
    url = "https://github.com/dietrichgebert/ponytail";
    rev = "09c434ab73ca43761c5d8b0c5d341926c2fba710";
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
