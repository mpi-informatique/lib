type t = string

let citer texte =
  let b = Buffer.create (String.length texte + 2) in
  Buffer.add_char b '"';
  String.iter (function
    | '"' -> Buffer.add_string b "\\\""
    | '\\' -> Buffer.add_string b "\\\\"
    | '\n' -> Buffer.add_string b "\\n"
    | '\r' -> Buffer.add_string b "\\r"
    | c -> Buffer.add_char b c) texte;
  Buffer.add_char b '"';
  Buffer.contents b

let automate ?titre ?(etat = string_of_int) ~symbole a =
  let b = Buffer.create 512 in
  let ligne format = Printf.ksprintf (fun s -> Buffer.add_string b s; Buffer.add_char b '\n') format in
  ligne "digraph automate {";
  ligne "  rankdir=LR;";
  ligne "  graph [bgcolor=\"white\", fontname=\"sans-serif\", pad=0.3, nodesep=0.5, ranksep=0.7];";
  ligne "  node [shape=circle, style=filled, fillcolor=\"#eff6ff\", color=\"#2563eb\", fontcolor=\"#172554\", fontname=\"sans-serif\", penwidth=1.5];";
  ligne "  edge [color=\"#475569\", fontcolor=\"#334155\", fontname=\"sans-serif\", arrowsize=0.8];";
  Option.iter (fun t -> ligne "  label=%s;" (citer t)) titre;
  let finaux = Array.make (Automate.nb_etats a) false in
  List.iter (fun q -> finaux.(q) <- true) (Automate.finaux a);
  for q = 0 to Automate.nb_etats a - 1 do
    ligne "  q%d [label=%s%s];" q (citer (etat q))
      (if finaux.(q) then ", shape=doublecircle, fillcolor=\"#dcfce7\", color=\"#15803d\"" else "")
  done;
  List.iter (fun q ->
    ligne "  initial%d [shape=point, label=\"\", width=0.08, color=\"#475569\"];" q;
    ligne "  initial%d -> q%d;" q q) (Automate.initiaux a);
  List.iter (fun (p, lettre, q) ->
    let etiquette = match lettre with None -> "ε" | Some x -> symbole x in
    ligne "  q%d -> q%d [label=%s];" p q (citer etiquette)) (Automate.transitions a);
  ligne "}";
  Buffer.contents b

let to_string dessin = dessin
let ecrire chemin dessin = Out_channel.with_open_text chemin (fun oc -> output_string oc dessin)
