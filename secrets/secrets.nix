let
  # MendingOld = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGGrz9BTF/SPv3/ioaUv6pMt13pPz6w3qOZA2C8+cdlS";
  Mending = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBkMa6B8nVxQ2guCO2sOPNm9zITJ9chcPPcavCaZJTXi";
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

  "Mending/user-password.age".publicKeys = [ Mending ];
  "Mending/root-password.age".publicKeys = [ Mending ];

  "Mending/weather-api-key.age".publicKeys = [ Mending ];
}
