(* General client-side GUI widgets *)

class t :: Type (* final value generated *)
      -> Type (* internal state *)
      -> Type (* global configuration for this kind of widget, computed on the server *)
      -> Type

con t' (value :: Type, state :: Type, config :: Type) = t value state config

val configure : value ::: Type -> state ::: Type -> config ::: Type -> t value state config -> transaction config
val create : value ::: Type -> state ::: Type -> config ::: Type -> t value state config -> config -> transaction state
val initialize : value ::: Type -> state ::: Type -> config ::: Type -> t value state config -> config -> value -> transaction state
val reset : value ::: Type -> state ::: Type -> config ::: Type -> t value state config -> state -> transaction unit
val asWidget : value ::: Type -> state ::: Type -> config ::: Type -> t value state config -> state -> option id (* Use this ID if you can, to help group with labels. *) -> xbody
val value : value ::: Type -> state ::: Type -> config ::: Type -> t value state config -> state -> signal value
val asValue : value ::: Type -> state ::: Type -> config ::: Type -> t value state config -> value -> xbody

val make : value ::: Type -> state ::: Type -> config ::: Type
           -> { Configure : transaction config,
                Create : config -> transaction state,
                Initialize : config -> value -> transaction state,
                Reset : state -> transaction unit,
                AsWidget : state -> option id -> xbody,
                Value : state -> signal value,
                AsValue : value -> xbody }
           -> t value state config

(* Some default widgets *)

type urlbox
type urlbox_config
val urlbox : t string urlbox urlbox_config
(* This one is earlier in the list so that [textbox] overrides it by default! *)

type htmlbox
type htmlbox_config = {}
val htmlbox : t string htmlbox htmlbox_config
val html : string -> xbody (* Use this one to parse result of [htmlbox] into real HTML. *)

type textbox
type textbox_config
val textbox : t string textbox textbox_config

type opt_textbox
type opt_textbox_config
val opt_textbox : t (option string) opt_textbox opt_textbox_config

type checkbox
type checkbox_config
val checkbox : t bool checkbox checkbox_config

type intbox
type intbox_config
val intbox : t int intbox intbox_config

type timebox
type timebox_config
val timebox : t time timebox timebox_config

con choicebox :: Type -> Type
con choicebox_config :: Type -> Type
val choicebox : a ::: Type ->
                 show a
                 -> read a
                 -> a -> list a
                 -> t a (choicebox a) (choicebox_config a)

(* A widget that only allows selection from a finite list, computed via an SQL query *)
con foreignbox :: Type -> Type
con foreignbox_config :: Type -> Type
val foreignbox : a ::: Type -> f ::: Name ->
                 show a
                 -> read a
                 -> sql_query [] [] [] [f = a]
                 -> t (option a) (foreignbox a) (foreignbox_config a)

con foreignbox_default :: Type -> Type
con foreignbox_default_config :: Type -> Type
val foreignbox_default : a ::: Type -> f ::: Name ->
                           show a
                           -> read a
                           -> sql_query [] [] [] [f = a]
                           -> a (* default value *)
                           -> t a (foreignbox_default a) (foreignbox_default_config a)
