{
  description = "Rocky Branches website";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
        };
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              hugo
            ];

            shellHook = ''
              echo "Rocky Branches — Hugo dev server: hugo server --buildDrafts"
            '';
          };
        }
      );
    };
}
