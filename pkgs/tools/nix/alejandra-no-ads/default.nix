{alejandra, ...}:
alejandra.overrideAttrs (prev: {
  patches = (prev.patches or []) ++ [../patches/0003-alejandra-remove-ads.patch];
})
