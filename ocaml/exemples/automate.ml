open Mpi

let () =
  let a = Automate.creer
    ~nb_etats:3 ~initiaux:[0] ~finaux:[2]
    ~transitions:[(0, Some 'a', 0); (0, Some 'b', 1); (1, None, 2); (2, Some 'b', 2)]
  in
  Dot.automate ~symbole:(String.make 1) a |> Dot.to_string |> print_string
