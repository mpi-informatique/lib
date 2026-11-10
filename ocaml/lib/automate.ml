type etat = int
type 'a transition = etat * 'a option * etat

type 'a t = {
  nb_etats : int;
  initiaux : etat list;
  finaux : etat list;
  transitions : 'a transition list;
}

let creer ~nb_etats ~initiaux ~finaux ~transitions =
  if nb_etats < 0 then invalid_arg "Automate.creer : nombre d'états négatif";
  let verifier q =
    if q < 0 || q >= nb_etats then
      invalid_arg (Printf.sprintf "Automate.creer : état %d hors limites" q)
  in
  List.iter verifier initiaux;
  List.iter verifier finaux;
  List.iter (fun (p, _, q) -> verifier p; verifier q) transitions;
  { nb_etats; initiaux = List.sort_uniq Int.compare initiaux; finaux = List.sort_uniq Int.compare finaux; transitions }

let nb_etats a = a.nb_etats
let initiaux a = a.initiaux
let finaux a = a.finaux
let transitions a = a.transitions
