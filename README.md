# My NixOS Configurations

I use NixOS - and honestly it's my favourite Linux distro/idea ever. Compeltely
reproducible systems, all managed with a few config files and modules. Here's
the little flake that manages all of my NixOS systems!

## Manual Setup (I know...)

There's a bit of manual setup and I wish I could avoid it, but I can't (to my
knowledge). But it's only a tiny little bit!!

### Fixing 1Password

If using the 1Password module, GNOME keyring and Seahorse are also installed.
For 1Password to save your 2FA token, you must go into Seahorse, create a new
keyring, name it Default or whatever, right click on it and make it the default.

Now, when you log in to 1Password, your 2FA token should be saved with no
issues.

### Cider2

I use Apple Music (read my
[blog post](https://morganlabs.dev/blog/why-i-love-apple-music)?), and there's no
official client for it, unfortunately. Therefore I use the Cider2 client. I
know of the controversies of the creators, but I had already bought the software
before this, so I may as well use it.

All you have to do is go to https://cidercollective.itch.io/cider and dowload
the AppImage version of Cider2. Then, run
`nix-store --add-fixed sha256 Cider-linux-appimage-x64.AppImage` to add the
package to the Nix store. After this, any configurations with Cider2 enabled
should build succesfully.
