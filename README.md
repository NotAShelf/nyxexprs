# 🌙 nyxexprs

[Nyx]: https://github.com/notashelf/nyx
[Flint]: https://github.com/notashelf/flint

Welcome to Nyxexprs! This is my personal package collection and overlay
containing things that I cannot exactly upstream to Nixpkgs, or sometimes the
things I just don't feel like contributing. This has been extracted from my
personal monorepo, which is my NixOS configuration, for the sake providing a
public cache for my software and a centralized packaging solution to things I
have created or felt like packaging. It also contains packages I've refactored
out of my personal NixOS configuration, [Nyx] (hence the name "nyxexprs.")

> [!NOTE]
> This repository is kept up to date with GitHub workflows, and npins for
> tracking most dependencies. Flakes are used to "re-export" other flakes with a
> unified Nixpkgs. Duplicates are detected via [Flint], which is packaged here
> :)

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
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

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
  # to be in your `inputs`, as demonstrated in the flake.nix example. You 
  # will also need `inputs` to be in your `nixosSystem` call's `specialArgs`
  # or else you will not be able to access `inputs` in your modules.
  environment.systemPackages = [
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

<!-- markdownlint-disable MD059 -->

[here]: https://interoperable-europe.ec.europa.eu/sites/default/files/custom-page/attachment/eupl_v1.2_en.pdf

This project is made available under European Union Public Licence (EUPL)
version 1.2. See [LICENSE](LICENSE) for more details on the exact conditions. An
online copy is provided [here].

Everything in this repository, including derivations and patches, are licensed
under the EUPL v1.2 license **only**.

<!-- markdownlint-enable MD059 -->
