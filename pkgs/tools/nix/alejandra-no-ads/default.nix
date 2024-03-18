{alejandra, ...}:
alejandra.overrideAttrs (prev: {
  patches = (prev.patches or []) ++ [./0001-no-ads.patch];
})
