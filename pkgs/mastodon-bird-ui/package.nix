{
  mastodon,
  applyPatches,
  fetchFromGitHub,
  ...
}:
(mastodon.override {
  patches = [
    # Redone based on:
    # <https://codeberg.org/rheinneckar.social/nixos-config/src/branch/main/patches/mastodon-bird-ui.patch>
    ./patches/mastodon-bird-ui.patch
  ];
}).overrideAttrs (oldAttrs: let
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "ronilaukkarinen";
      repo = "mastodon-bird-ui";
      tag = "2.3.3";
      hash = "sha256-ddx9P8eOtUzTDFMF0ZRKyIRujjLL6rFppUswJn40nFU=";
    };

    # based on:
    # https://github.com/ronilaukkarinen/mastodon-bird-ui#make-mastodon-bird-ui-as-optional-by-integrating-it-as-site-theme-in-settings-for-all-users
    postPatch = ''
      mkdir mastodon-bird-ui
      mv layout-single-column.css mastodon-bird-ui/layout-single-column.scss
      mv layout-multiple-columns.css mastodon-bird-ui/layout-multiple-columns.scss

      echo -e "@use 'application';
      @use 'mastodon-bird-ui/layout-single-column.scss';
      @use 'mastodon-bird-ui/layout-multiple-columns.scss';" > mastodon-bird-ui-dark.scss
    '';
  };
in {
  mastodonModules = oldAttrs.mastodonModules.overrideAttrs (oldAttrs: {
    pname = "mastodon-birdui-theme";

    postPatch =
      oldAttrs.postPatch or ""
      + ''
        cp -r ${src}/*.scss ${src}/mastodon-bird-ui/ app/javascript/styles/
      '';
  });
})
