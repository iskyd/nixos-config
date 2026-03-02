{ pkgs, config, ... }:

{
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets.gptel_gemini_key = {
      owner = config.users.users.iskyd.name;
    };
    defaultSopsFile = ./../secrets/secrets.yaml;
  };
}
