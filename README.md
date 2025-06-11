# 🌙 nyxexprs

Welcome to nyxexprs! This is my personal package overlay, for derivations I use
from time to time when they do not fit my "monorepo" use case. This repository
holds things I've packages, as well as derivations and a binary cache for most
of my personal projects. It also contains packages and modules I've refactored
out of my personal NixOS configuration, Nyx (hence the name "nyxexprs.")

Kept up to date with Github workflows and npins. Contributions welcome.

## Usage

All packages in Nyxexprs are exposed in the flake outputs, under `packages`. An
overlay is also provided through [flake-parts](https://flake.parts)'
[easy-overlay module](https://flake.parts/options/flake-parts-easyoverlay)

### Flakes

```nix
# In your flake.nix

{
  inputs = {
    # Your Nixpkgs input
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";


    # Add an input as such. Do NOT add the "follows" line (a typical flakes
    # pattern) if you intend to use the binary cache.
    nyxexprs.url = "github:notashelf/nyxexprs";
    
    # Other inputs
    # ...
  };
}
```

Then get the package you need directly from inputs

```nix
{ 
  inputs,
  ...
}: {
  # For this to be valid, you need `inputs` in the argset above and nyxexprs
  # to be in your `inputs`, as demonstrated in the flake.nix example
  environment.systemPackages = [
    # `pkgs.stdenv.hostPlatform.system` is an explicit way of replacing
    # `pkgs.system`. It is especially important on systems with aliases
    # disabled in their nixpkgs config. Nixpkgs also likes enjoying changing
    # things around every once in a while, so being explicit is good.
    inputs.nyxexprs.packages.${pkgs.stdenv.hostPlatform.system}.tempus # example
  ];
}
```

### Overlay

An overlay is provided. Once added, it may be consumed as follows:

```nix
{
  inputs, # needs to be in scope, e.g., with `specialArgs`
  pkgs,
  ...
}: {
  nixpkgs.overlays = [inputs.nyxexprs.overlays.default];

  # Overlays modify the `pkgs` instance. If consumed, all
  # of my packages will be appended directly to your pkgs
  # at which point you can consume them as `pkgs.package`
  environment.systemPackages = [
    pkgs.tempus # example package
  ];
}
```

> [!TIP]
> If you are using Nix on a non-NixOS distro, you may nix run to try out
> packages, or `nix profile install` to install them on your system profile. If
> using home-manager on non-NixOS, I recommend using `home.packages` instead.

## Binary Cache

[binary cache]: https://app.cachix.org/cache/nyx

Regardless of your setup, you may want to add the [binary cache] to your
substituters to avoid building the provided packages on each pull. You may
follow the example below to add the binary cache to your system.

```nix
{ 
  nix.settings = {
    builders-use-substitutes = true;
    substituters = [
        # Add the Nyx cache
        "https://nyx.cachix.org"
    ];

    trusted-public-keys = [
        # And the trusted public key for Nyx
        "nyx.cachix.org-1:xH6G0MO9PrpeGe7mHBtj1WbNzmnXr7jId2mCiq6hipE="

        # Other trusted public keys
        # ...
    ];
  };
}
```

## 🫂 Credits

[@fufexan]: https://github.com/fufexan
[nix-gaming]: https://github.com/fufexan/nix-gaming
[@diniamo]: https://github.com/diniamo
[niqspkgs]: https://github.com/diniamo/niqspkgs

The repository structure is mostly borrowed from [@fufexan] 's [nix-gaming]
repository. Thank you fuf!

I've also borrowed some CI logic around detecting uncached packages from
[@diniamo], which uses GitHub workflows in [niqspkgs] to build and cache
packages missing in Cachix.

## 📜 License

This repository (Nix codee, patches, etc.) is released under EUPL v1.2. Please
see the [license file](./LICENSE) for more details.
