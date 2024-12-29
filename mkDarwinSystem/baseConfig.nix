{ system }:
{ lib, ... }:
with lib;
{
  modules = {
    base.user.enable = mkForce true;
    decoration.fonts.enable = true;

    programs = {
      nvim.enable = true;
      kitty.enable = true;
    };
  };

  # Basic Settings
  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = mkDefault [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.hostPlatform = system;

  # Copy all Nix Apps to /Applications
  # This allows Spotlight to pick them up, since they're no longer Symlinks
  system.activationScripts.applications.text = mkForce ''
    #!/usr/bin/env bash
    set -euo pipefail

    # Directory where Nix stores system profiles
    generations_dir="/nix/var/nix/profiles"

    # Determine the newest generation (the one being built)
    newest_generation="$(find "$generations_dir" | grep "system-" | sort -V | tail -n 1)"

    if [ -z "$newest_generation" ]; then
        echo "Error: Could not determine the newest system generation." >&2
        exit 1
    fi

    # Path to the /Applications folder in the newest generation
    newest_applications_dir="$newest_generation/Applications"

    # System-wide /Applications directory
    system_applications_dir="/Applications"

    # Ensure the Applications directory exists
    if [ ! -d "$system_applications_dir" ]; then
        echo "Creating $system_applications_dir..."
        mkdir -p "$system_applications_dir"
    fi

    # Copy applications from the newest generation
    if [ -d "$newest_applications_dir" ]; then
        echo "Processing applications in $newest_applications_dir..."

        # Iterate over all symlinks in the newest /Applications folder
        find "$newest_applications_dir/" -type l -name "*.app" | while read -r symlink_path; do
            # Resolve the symlink to the original application path
            original_path=$(readlink "$symlink_path")
            app_name=$(basename "$symlink_path")

            # Target path in the system-wide /Applications directory
            target_path="$system_applications_dir/$app_name"

            if [ -e "$target_path" ]; then
                echo "Skipping existing application: $app_name"
            else
                echo "Copying $app_name to $system_applications_dir..."
                cp -r "$original_path" "$target_path"
            fi
        done
    else
        echo "No /Applications folder found in $newest_generation."
    fi

    echo "Applications have been copied to $system_applications_dir."
  '';
}
