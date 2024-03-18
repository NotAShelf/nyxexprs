{gnome-control-center, ...}:
gnome-control-center.overrideAttrs (prev: let
  gwrapperArgs = ''
    # gnome-control-center does not start without XDG_CURRENT_DESKTOP=gnome
    gappsWrapperArgs+=(
      --set XDG_CURRENT_DESKTOP "gnome"
    );
  '';
in {
  pname = "gnome-control-center-wrapped";
  preFixup =
    (prev.preFixup or "") + gwrapperArgs;
})
