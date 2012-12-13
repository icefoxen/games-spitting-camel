exception LoaderException of string
val little_endian : bool ref
val canonifySurface : Sdlvideo.surface -> Sdlvideo.surface
val loadImg : string -> Sdlvideo.surface
val debug : [< Raw.ikind ] Raw.t -> unit
val texture_of_surf :
  [ `texture_1d | `texture_2d ] -> Sdlvideo.surface -> GlTex.texture_id
val texture2d_of_surface : Sdlvideo.surface -> GlTex.texture_id
val texture1d_of_surface : Sdlvideo.surface -> GlTex.texture_id
val loadTexture : [ `texture_1d | `texture_2d ] -> string -> GlTex.texture_id
val loadTexture2d : string -> GlTex.texture_id
val loadTexture1d : string -> GlTex.texture_id
val loadSound : string -> Sdlmixer.chunk
val loadConfig : string -> Cfg.config
val loadFont : string -> int -> Sdlttf.font
