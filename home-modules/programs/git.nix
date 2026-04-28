{ pkgs, ... }:

{
  programs.git = {
    settings = {
      alias = {
        amend = "commit --amend";
        authors = "!\"${pkgs.git}/bin/git log --pretty=format:%aN"
                + " | ${pkgs.coreutils}/bin/sort"
                + " | ${pkgs.coreutils}/bin/uniq -c"
                + " | ${pkgs.coreutils}/bin/sort -rn\"";
      };
      user = {
        email = "iskyd@proton.me";
        name = "iskyd";
      };
      rerere = {
        enabled = true;
        autoUpdate = true;
      };
      "url \"git@bitbucket.org:\"" = {
        insteadOf = "https://bitbucket.org";
      };
      push.autoSetupRemote = true;
      pull.rebase = true;
      rebase.autoStash = true;
    };
    enable = true;
     signing = {
      signByDefault = true;
      key = "991C76DCAA073547";
    };
    ignores = [
     "\\#*#"
     "*~"
    ];
    includes = [
      {
        path = "~/.config/.gitconfig-conio";
        condition = "gitdir:/opt/projects/Conio/";
      }
    ];
  };

  home.file.".config/.gitconfig-conio".text = ''
    [user]
        name = "mattia"
        email = "mattia.careddu@conio.com"
        signingKey =
        signbydefault = false
    [commit]
        gpgSign = false
    [tag]
        gpgSign = false
    [url "git@bitbucket.org:"]
        insteadOf = https://bitbucket.org
  '';
}
