(** Documents Graphviz DOT. L'export ne nécessite pas Graphviz. *)

type t

val automate : ?titre:string -> ?etat:(Automate.etat -> string) -> symbole:('a -> string) -> 'a Automate.t -> t
(** Dessine les états isolés, les flèches initiales et les états finaux en double
    cercle. [etat] vaut [string_of_int] par défaut ; [symbole] décrit une lettre.
    Les étiquettes sont échappées et les transitions epsilon portent « ε ». *)

val to_string : t -> string

val ecrire : string -> t -> unit
(** [ecrire chemin dessin] écrit le document UTF-8 et remplace le fichier existant.
    Lève [Sys_error] en cas d'erreur d'écriture. *)
