{ system, ... }: 
{
  nixpkgs.hostPlatform = system;
}