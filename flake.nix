{
  description = "Bibliothèque pédagogique MP2I/MPI";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      environments = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          ocaml = pkgs.ocamlPackages;
          mpi = ocaml.buildDunePackage {
            pname = "mpi-informatique";
            version = "dev";
            duneVersion = "3";
            src = self;
            minimalOCamlVersion = "5.5.2";
            nativeCheckInputs = [ ocaml.mdx ];
            checkInputs = [ ocaml.mdx ];
            doCheck = true;
          };
        in { inherit pkgs ocaml mpi; });
    in {
      packages = forAllSystems (system: { default = environments.${system}.mpi; });
      checks = forAllSystems (system: { mpi = environments.${system}.mpi; });
      devShells = forAllSystems (system:
        let inherit (environments.${system}) pkgs ocaml; in {
          default = pkgs.mkShell {
            packages = [ ocaml.ocaml ocaml.dune_3 ocaml.findlib ocaml.ocaml-lsp ocaml.mdx ocaml.odoc pkgs.graphviz ];
          };
        });
    };
}
