{
  mastodon,
  yq-go,
  fetchurl,
  ...
}:
mastodon.overrideAttrs (_: {
  mastodonModules = mastodon.mastodonModules.overrideAttrs (oldAttrs: let
    # https://github.com/ronilaukkarinen/mastodon-bird-ui
    birdui-version = "1.8.5";

    birdui-single-column = fetchurl {
      url = "https://raw.githubusercontent.com/ronilaukkarinen/mastodon-bird-ui/${birdui-version}/layout-single-column.css";
      sha256 = "sha256-h3cb0ZiXIUEbx+8CDXPHqKe4u3ZquE90wUr/cmKkhK8=";
    };

    birdui-multi-column = fetchurl {
      url = "https://raw.githubusercontent.com/ronilaukkarinen/mastodon-bird-ui/${birdui-version}/layout-multiple-columns.css";
      sha256 = "sha256-NMiBkJUR+HEf+ooJwoBIMiMOKna3odZYF6h4QLIdS84=";
    };
  in {
    pname = "${oldAttrs.pname}+themes";

    postPatch = ''
      # Import theme
      local styleDir=$PWD/app/javascript/styles
      local birduiDir=$styleDir/mastodon-bird-ui

      mkdir -p $birduiDir
      cat ${birdui-single-column} > $birduiDir/layout-single-column.scss
      cat ${birdui-multi-column} > $birduiDir/layout-multiple-columns.scss

      sed -i 's/theme-contrast/theme-mastodon-bird-ui-contrast/g' $birduiDir/layout-single-column.scss
      sed -i 's/theme-mastodon-light/theme-mastodon-bird-ui-light/g' $birduiDir/layout-single-column.scss

      sed -i 's/theme-contrast/theme-mastodon-bird-ui-contrast/g' $birduiDir/layout-multiple-columns.scss
      sed -i 's/theme-mastodon-light/theme-mastodon-bird-ui-light/g' $birduiDir/layout-multiple-columns.scss

      echo -e "@import 'contrast/variables';\n@import 'application';\n@import 'contrast/diff';\n@import 'mastodon-bird-ui/layout-single-column.scss';\n@import 'mastodon-bird-ui/layout-multiple-columns.scss';" >$styleDir/mastodon-bird-ui-contrast.scss

      echo -e "@import 'mastodon-light/variables';\n@import 'application';\n@import 'mastodon-light/diff';\n@import 'mastodon-bird-ui/layout-single-column.scss';\n@import 'mastodon-bird-ui/layout-multiple-columns.scss';" >$styleDir/mastodon-bird-ui-light.scss

      echo -e "@import 'application';\n@import 'mastodon-bird-ui/layout-single-column.scss';\n@import 'mastodon-bird-ui/layout-multiple-columns.scss';" >$styleDir/mastodon-bird-ui-dark.scss

      # Build theme
      echo "mastodon-bird-ui-dark: styles/mastodon-bird-ui-dark.scss" >> $PWD/config/themes.yml
      echo "mastodon-bird-ui-light: styles/mastodon-bird-ui-light.scss" >> $PWD/config/themes.yml
      echo "mastodon-bird-ui-contrast: styles/mastodon-bird-ui-contrast.scss" >> $PWD/config/themes.yml
    '';
  });

  nativeBuildInputs = [yq-go];

  postBuild = ''
    # Make theme available
    echo "mastodon-bird-ui-dark: styles/mastodon-bird-ui-dark.scss" >> $PWD/config/themes.yml
    echo "mastodon-bird-ui-light: styles/mastodon-bird-ui-light.scss" >> $PWD/config/themes.yml
    echo "mastodon-bird-ui-contrast: styles/mastodon-bird-ui-contrast.scss" >> $PWD/config/themes.yml

    yq -i '.en.themes.mastodon-bird-ui-dark = "Mastodon Bird UI (Dark)"' $PWD/config/locales/en.yml
    yq -i '.en.themes.mastodon-bird-ui-light = "Mastodon Bird UI (Light)"' $PWD/config/locales/en.yml
    yq -i '.en.themes.mastodon-bird-ui-contrast = "Mastodon Bird UI (High contrast)"' $PWD/config/locales/en.yml
  '';
})
