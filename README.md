# MPI

Bibliothèque pédagogique OCaml pour MP2I/MPI, destinée à accueillir aussi une bibliothèque C.
Modules actuels : `Mpi.Automate` (automates finis avec transitions epsilon) et `Mpi.Dot` (export Graphviz).

## Développement

Avec [Nix](https://nixos.org/download/) et les flakes activés :

<!-- $MDX skip -->
```sh
nix develop
dune build
dune runtest
dune build @doc
```

L'environnement fournit OCaml 5.5.2, Dune, MDX, odoc et Graphviz. `flake.lock` fixe leurs versions.
Les sources OCaml sont dans `ocaml/` ; les futures sources C iront dans `c/`.

## Exemple

Dans `ocaml`, exécuter `#use_output "dune ocaml top";;`, puis :

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
