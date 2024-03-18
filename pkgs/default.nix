{inputs, ...}: {
  systems = ["x86_64-linux"];

  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  perSystem = {
    config,
    system,
    pkgs,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    packages = let
      pins = import ../npins;

      inherit (pkgs) callPackage;
      mkPackage = path: {__functor = self: self.override;} // (callPackage path {inherit pins;});
    in
      import ./top-level.nix {inherit pkgs callPackage mkPackage;};
  };
}
