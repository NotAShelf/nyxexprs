# 🌙 nyxexprs

My personal package overlay for sharing my most commonly used derivations.

## 📦 Packages

There are several packages exposed by this flake. Each directory in `pkgs`
contains a description of the package inside its README.

| Package          |                                           Description                                            |
| :--------------- | :----------------------------------------------------------------------------------------------: |
| alejandra-custom | A patched version of the **Alejandra** Nix formatter, without the pesky ads and spacing patches  |
| ani-cli          |            An up-to-date, auto updated version of ani-cli following auto-updated pins            |
| cloneit          |                   A CLI tool to download specific GitHub directories or files                    |
| foot-transparent |   A patched version of the foot terminal emulator that brings back fullscreen transparency[^1]   |
| headscale-ui     |            A web frontend for the headscale Tailscale-compatible coordination server             |
| mastodon-bird-ui |                        Mastodon web UI, but strongly inspired by Twitter.                        |
| zsh-stripped     | ZSH with newinstall scripts removed, and patches to handle special characters such as `^` or `#` |

## Usage

### Binary Cache

Regardless of your setup,you may want to add the
[binary cache](https://app.cachix.org/cache/nyx) to your substituters to avoid
building the provided packages on each pull. You may follow the example below to
add the binary cache to your system.

```nix
nix.settings = {
    builders-use-substitutes = true;
    substituters = [
        # other substituters
        "https://nyx.cachix.org"
    ];

    trusted-public-keys = [
        # other trusted keys
        "nyx.cachix.org-1:xH6G0MO9PrpeGe7mHBtj1WbNzmnXr7jId2mCiq6hipE="
    ];
};
```

### NixOS/Home-manager (flakes)

It is as simple as adding a new entry to your inputs with the correct url.

```nix
# flake.nix
inputs = {
    # ...
    nyxexprs.url = "github:notashelf/nyxexprs";
    # ...
};
```

After adding the input, you can consume the [exposed packages](#-packages) in
your system configuration. An example `flake.nix` would be as follows:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    # ↓ add nyxexprs as a flake input
    nyxexprs.url = "github:notashelf/nyxexprs";
  };

  outputs = inputs @ {self, nixpkgs, ...}: {
    # set up for NixOS
    nixosConfigurations.<yourHostName> = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        # ...
      ];
    };

    # or for Home Manager
    homeConfigurations.<yourHostName> = inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {inherit inputs;};

      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      modules = [
        ./home.nix
        # ...
      ];
    }
  };
}
```

Where you can then add the relevant package to your `environment.systemPackages`
or `home.packages`

```nix
{pkgs, inputs, ...}: {
  # in case of home-manager, this will be home.packages
  environment.systemPackages = [
    inputs.nyxexprs.packages.${pkgs.system}.<packageName> # installs a package
  ];
}
```

### Nix

If you are using Nix on a non-NixOS distro, you may `nix run` to try out
packages, or `nix profile install` to install them on your system profile. If
using home-manager on non-NixOS, I recommend using `home.packages` instead.

```console
nix profile install github:notashelf/nyxexprs#<package>
```

### NixOS/Home-manager (no flakes)

If you are not using flakes, the above instructions will not apply. You may
obtain the source as a tarball to consume in your system configuration as
follows:

```nix
{pkgs, ...}: let
  nyxexprs = import (builtins.fetchTarball "https://github.com/notashelf/nyxexprs/archive/main.tar.gz");
in {
  # install packages
  # this can also be home.packages if you are using home-manager
  environment.systemPackages = [
    nyxexprs.packages.${pkgs.hostPlatform.system}.<packageName>
  ];
}
```

## 🔧 Contributing

PRs are always welcome.

## 🫂 Credits

The repository structure is mostly borrowed from
[@fufexan](https://github.com/fufexan)'s
[nix-gaming](https://github.com/fufexan/nix-gaming).

[^1]:
    Foot has broken fullscreen transparency on 1.15, which looks **really**
    ugly with padding. The author is dead set on not fixing it, because it's broken
    on one wayland compositor that a total of 7 people use.
