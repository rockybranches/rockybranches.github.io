{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    hugo
  ];

  shellHook = ''
    echo "Hugo dev server: hugo server --buildDrafts"
  '';
}
