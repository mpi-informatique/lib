open Mpi

let contient texte motif =
  let n = String.length texte and m = String.length motif in
  let rec chercher i = i + m <= n && (String.sub texte i m = motif || chercher (i + 1)) in
  chercher 0

let invalide f =
  match f () with
  | _ -> failwith "Invalid_argument attendu"
  | exception Invalid_argument _ -> ()

let () =
  let creer = Automate.creer ~nb_etats:3 in
  let transitions = [(0, Some 'a', 1); (0, Some 'b', 1); (1, None, 1)] in
  let a = creer ~initiaux:[1; 0; 0] ~finaux:[1; 1] ~transitions in
  assert (Automate.nb_etats a = 3);
  assert (Automate.initiaux a = [0; 1]);
  assert (Automate.finaux a = [1]);
  assert (Automate.transitions a = transitions);
  invalide (fun () -> Automate.creer ~nb_etats:(-1) ~initiaux:[] ~finaux:[] ~transitions:[]);
  invalide (fun () -> creer ~initiaux:[-1] ~finaux:[] ~transitions:[]);
  invalide (fun () -> creer ~initiaux:[] ~finaux:[3] ~transitions:[]);
  invalide (fun () -> creer ~initiaux:[] ~finaux:[] ~transitions:[(3, None, 0)]);
  invalide (fun () -> creer ~initiaux:[] ~finaux:[] ~transitions:[(0, None, -1)]);
  let dessin = Dot.automate ~symbole:(String.make 1) a in
  let dot = Dot.to_string dessin in
  List.iter (fun motif -> assert (contient dot motif))
    ["q2 [label=\"2\"];"; "shape=doublecircle"; "initial0 -> q0;"; "initial1 -> q1;";
     "q0 -> q1 [label=\"a\"];"; "q0 -> q1 [label=\"b\"];"; "q1 -> q1 [label=\"ε\"];" ];
  let special = Automate.creer ~nb_etats:1 ~initiaux:[0] ~finaux:[0] ~transitions:[(0, Some "\"\\\n", 0)] in
  let dot_special = Dot.automate ~titre:"\"\\\n" ~etat:(fun _ -> "\"\\\n") ~symbole:Fun.id special |> Dot.to_string in
  assert (contient dot_special "label=\"\\\"\\\\\\n\"");
  let vide = Automate.creer ~nb_etats:0 ~initiaux:[] ~finaux:[] ~transitions:[] in
  assert (not (contient (Dot.to_string (Dot.automate ~symbole:Fun.id vide)) "q0"));
  let chemin = Filename.temp_file "mpi-" ".dot" in
  Fun.protect ~finally:(fun () -> Sys.remove chemin) (fun () ->
    Dot.ecrire chemin dessin;
    assert (In_channel.with_open_text chemin In_channel.input_all = dot))
