NIX_CONFIG="$HOME/.config/nix"

mkdir -p "$NIX_CONFIG"
echo "experimental-features = nix-command flakes" >> "$NIX_CONFIG/nix.conf"
echo "build-users-group = nixbld" >> "$NIX_CONFIG/nix.conf"
