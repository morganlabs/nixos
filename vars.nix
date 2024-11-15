{
  git.ssh.pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBNv1xhpJxFP8KP0+ai4+sK6HRu70J6Nq/u4dU27MixM";
  ssh.port = 22; # TODO: Convert to secret, custom port

  user = {
    username = "morgan";
    name = "Morgan Jones";
    email.work = "me@morganlabs.dev";
  };
}
