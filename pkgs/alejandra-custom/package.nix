{alejandra, ...}:
alejandra.overrideAttrs (prev: {
  pname = "alejandra-custom";
  version = "0-unstable-2024-07-21";

  patches =
    (prev.patches or [])
    ++ [
      ./0001-no-ads.patch
      ./0002-spaced-elements.patch # Courtesy of @soupglasses
    ];

  meta.description = ''
    Patched version of Alejandra that removes ads and adds spaces in attrsets & lists
  '';
})
