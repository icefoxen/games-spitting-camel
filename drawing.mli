val withMatrix : ('a -> 'b) -> 'a -> 'b
val withPrim : GlDraw.shape -> ('a -> 'b) -> 'a -> 'b
val withAttribs : GlMisc.attrib list -> ('a -> 'b) -> 'a -> 'b
val vertices : Gl.point2 list -> unit
val texturedVertices : (float * float) list -> Gl.point2 list -> unit
val translate : float * float -> unit
val rotate : float -> unit
val scale : float -> unit
val scale2 : float * float -> ?z:float -> unit -> unit
val affine : ?t:float * float -> ?r:float -> ?s:float -> unit -> unit
val texture : GlTex.texture_id -> [ `texture_1d | `texture_2d ] -> unit
val color : ?alpha:float -> Gl.rgb -> unit
val translated : float * float -> ('a -> 'b) -> 'a -> 'b
val rotated : float -> ('a -> 'b) -> 'a -> 'b
val scaled : float -> ('a -> 'b) -> 'a -> 'b
val colored : ?alpha:float -> Gl.rgb -> ('a -> 'b) -> 'a -> 'b
val textured :
  GlTex.texture_id -> [ `texture_1d | `texture_2d ] -> ('a -> 'b) -> 'a -> 'b
val affined :
  ?t:float * float -> ?r:float -> ?s:float -> ('a -> 'b) -> 'a -> 'b
val triangle : unit -> unit
val square : unit -> unit
val texSquare : GlTex.texture_id -> unit -> unit
val circle : int -> unit -> unit
val ring : int -> float -> unit -> unit
val arc : int -> float -> float -> float -> unit -> unit
val slice : int -> float -> float -> unit -> unit
type scene = (int * (unit -> unit)) list
val emptyScene : scene
val addToScene : ('a * 'b) list -> 'a -> 'b -> ('a * 'b) list
val addListToScene : ('a * 'b) list -> 'a -> 'b list -> ('a * 'b) list
val mergeScene : 'a list -> 'a list -> 'a list
val drawScene : ('a * (unit -> unit)) list -> unit
val antialias : bool -> unit
val setView : float -> float -> float -> float -> unit
