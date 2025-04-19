# 🌙 nyxexprs

My personal package overlay for sharing my most commonly used derivations. Kept
up to date with Github workflows and npins. Contributions welcome.

## Usage

All packages in Nyxexprs are exposed in the flake outputs.

### Flakes

```nix
# flake.nix
inputs = {
    # Add an input as such. Avoid adding "follows" lines if you would
    # like to benefit from the binary cache.
    nyxexprs.url = "github:notashelf/nyxexprs";
    # ...
};
```

If you are using Nix on a non-NixOS distro, you may nix run to try out packages,
or `nix profile install` to install them on your system profile. If using
home-manager on non-NixOS, I recommend using `home.packages` instead.

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

## 🫂 Credits

[@fufexan]: https://github.com/fufexan
[nix-gaming]: https://github.com/fufexan/nix-gaming

The repository structure is mostly borrowed from [@fufexan] 's [nix-gaming]
repository. Thank you fuf!

## 📜 License

This repository (Nix, patches, ettc.) is released under EUPL v1.2. Please see
the [license file](./LICENSE) for more details.
