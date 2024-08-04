{
  lib,
  zsh,
  ...
}:
zsh.overrideAttrs (old: {
  patches =
    (old.patches or [])
    ++ [
      ./0001-globquote.patch

      # From:
      #  <https://github.com/fugidev/nix-config>
      ./0001-remote-complete-files.patch
    ];

  postConfigure =
    (old.postConfigure or "")
    + ''
      # Find all instances of name=zsh/newuser in config.modules
      # remove them.
      sed -i -e '/^name=zsh\/newuser/d' config.modules

      # Also remove the newuser script to try and save some space
      # it doesn't amount to much, but every little bit counts.
      rm Scripts/newuser
    '';

  meta = {
    description = "Patched version of zsh with globquote and remote file completion";
    mainProgram = "zsh";
    maintainers = with lib.maintainers; [NotAShelf];
  };
})
