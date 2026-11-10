# MPI

Bibliothèque OCaml et C pour MP2I/MPI.
Modules actuels : `Mpi.Automate` (automates finis avec transitions epsilon) et `Mpi.Dot` (export Graphviz).

[Documentation](https://mpi-informatique.github.io/lib/)

## Utilisation

Avec un switch opam OCaml ≥ 5.5.2 actif :

<!-- $MDX skip -->
```sh
opam install ocamlfind
opam pin add mpi-informatique 'git+https://github.com/mpi-informatique/lib.git#main'
opam upgrade mpi-informatique # Pour les mises à jour suivantes.
```

Compiler un fichier `main.ml` :

<!-- $MDX skip -->
```sh
ocamlfind ocamlopt -package mpi-informatique -linkpkg main.ml -o main
./main
```

Dans `utop` (installé avec `opam install utop`), charger le paquet puis ouvrir son module :

<!-- $MDX skip -->
```ocaml
# #require "mpi-informatique";;
# open Mpi;;
```

Avec Dune, ajouter `(libraries mpi-informatique)` à l'exécutable. Les modules restent accessibles sous `Mpi`.

## Développement

Avec [Nix](https://nixos.org/download/) et les flakes activés :

<!-- $MDX skip -->
```sh
nix develop
dune build
dune runtest
dune build @doc
```

Le [socle commun](https://github.com/mpi-informatique/tp-environnement) fournit OCaml, `utop`, Dune, les outils C, Graphviz et opam ; ce dépôt ajoute MDX et odoc. `flake.lock` fixe leurs versions.
Dans les sources, `dune utop ocaml/lib` ouvre un interpréteur avec `Mpi` déjà chargé.
Pour actualiser le socle : `nix flake update environnement`.
Les sources OCaml sont dans `ocaml/` ; les futures sources C iront dans `c/`.

## Exemple

Dans `ocaml`, exécuter `#use "topfind";;` puis `#require "mpi-informatique";;`.
Depuis les sources, utiliser `#use_output "dune ocaml top";;` à la place.

```ocaml
# let a = Mpi.Automate.creer ~nb_etats:2 ~initiaux:[0] ~finaux:[1] ~transitions:[(0, Some 'a', 1); (1, Some 'b', 1)] in
  Mpi.Dot.ecrire "automate.dot" (Mpi.Dot.automate ~symbole:(String.make 1) a);;
- : unit = ()
```

<!-- $MDX skip -->
```sh
dot -Tsvg automate.dot -o automate.svg
```

Autre exemple : `dune exec ocaml/exemples/automate.exe > automate.dot`.
L'export DOT utilise seulement la bibliothèque standard ; Graphviz intervient uniquement pour le rendu.
