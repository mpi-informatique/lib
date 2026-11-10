{
  description = "Bibliothèque pédagogique MP2I/MPI";

  inputs.environnement.url = "github:mpi-informatique/tp-environnement";
  inputs.nixpkgs.follows = "environnement/nixpkgs";

  outputs = { self, nixpkgs, environnement }:
    let
      systems = environnement.lib.systems;
      forAllSystems = nixpkgs.lib.genAttrs systems;
      environments = forAllSystems (system:
        let
          inherit (environnement.legacyPackages.${system}) pkgs ocaml;
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
        let inherit (environments.${system}) ocaml; in {
          default = environnement.lib.mkShell system {
            packages = [ ocaml.mdx ocaml.odoc ];
          };
        });
    };
}
