type resourcePool = {
  texture : (string, GlTex.texture_id) Hashtbl.t;
  sound : (string, Sdlmixer.chunk) Hashtbl.t;
  config : (string, Cfg.config) Hashtbl.t;
  font : (string, Sdlttf.font) Hashtbl.t;
}
val createResourcePool : unit -> resourcePool
val getTex : resourcePool -> string -> GlTex.texture_id
val freeTex : 'a -> resourcePool -> string -> unit
val getSound : resourcePool -> string -> Sdlmixer.chunk
val freeSound : resourcePool -> string -> unit
val getConfig : resourcePool -> string -> Cfg.config
val freeConfig : resourcePool -> string -> unit
val getFont : resourcePool -> string -> int -> Sdlttf.font
val freeFont : resourcePool -> string -> int -> unit
