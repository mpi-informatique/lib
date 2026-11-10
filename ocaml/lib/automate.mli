(** Automates finis, éventuellement non déterministes et avec transitions epsilon. *)

type etat = int
type 'a transition = etat * 'a option * etat
(** [(p, Some x, q)] lit [x] ; [(p, None, q)] est une transition epsilon. *)

type 'a t

val creer : nb_etats:int -> initiaux:etat list -> finaux:etat list -> transitions:'a transition list -> 'a t
(** Les états sont les entiers de [0] à [nb_etats - 1]. Les listes d'états
    initiaux et finaux sont triées et dédoublonnées.
    Lève [Invalid_argument] si [nb_etats < 0] ou si un état est hors limites. *)

val nb_etats : 'a t -> int
val initiaux : 'a t -> etat list
val finaux : 'a t -> etat list
val transitions : 'a t -> 'a transition list
