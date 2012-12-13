exception Cfg_error of string
type config = (string, Cfgtype.cfgval) Hashtbl.t
val loadFile : string -> config
val get : config -> string -> Cfgtype.cfgval
val getString : config -> string -> string
val getInt : config -> string -> int
val getFloat : config -> string -> float
val string_of_cfgval : Cfgtype.cfgval -> string
