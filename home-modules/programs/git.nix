{ pkgs, ... }:

{
  programs.git = {
    settings = {
      core.sshCommand = "${pkgs.openssh}/bin/ssh -4";
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
      "url \"git@ssh.bitbucket.org:\"" = {
        # Bitbucket Cloud moved SSH to ssh.bitbucket.org; also rewrites existing clones' old remotes
        insteadOf = [ "https://bitbucket.org/" "git@bitbucket.org:" "ssh://git@bitbucket.org/" ];
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
  '';
}
