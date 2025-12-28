let
  Unbreaking = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINa3l41K2EBQWNVho9TCeM8+thMAbZW+dp/n9iRU6Nnz";
in
{
  "Unbreaking/user-password.age".publicKeys = [ Unbreaking ];
  "Unbreaking/root-password.age".publicKeys = [ Unbreaking ];

  "Unbreaking/minio-username.age".publicKeys = [ Unbreaking ];
  "Unbreaking/minio-password.age".publicKeys = [ Unbreaking ];

  "Unbreaking/minecraft-rcon-password.age".publicKeys = [ Unbreaking ];
  "Unbreaking/minecraft-rcon-user-password.age".publicKeys = [ Unbreaking ];

  "Unbreaking/usenet-server.age".publicKeys = [ Unbreaking ];
  "Unbreaking/usenet-username.age".publicKeys = [ Unbreaking ];
  "Unbreaking/usenet-password.age".publicKeys = [ Unbreaking ];
}
