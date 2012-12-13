type box = { b_loc : Vector2d.vector2d; b_w : float; b_h : float; }
type line = float * float * float * float
val createBox : Vector2d.vector2d -> float -> float -> box
val moveBox : box -> float * float -> box
val moveBoxTo : box -> Vector2d.vector2d -> box
val collideBox : box -> box -> bool
val collideBoxPoint : box -> float * float -> bool
val collideCircle : float * float -> float -> float * float -> float -> bool
val lines_of_box : box -> (float * float * float * float) list
val isBetween : 'a -> 'a -> 'a -> bool
val canonifyLine : float * float * float * float -> float * float * float
val collideLine :
  float * float * float * float ->
  float * float * float * float -> (float * float) option
val slope : float * float * float * float -> float
val collideBoxLine : box -> float * float * float * float -> bool
val pointRelative : float * float * float * float -> float -> float -> float
val createLine : 'a -> 'b -> 'c -> 'd -> 'a * 'b * 'c * 'd
val moveLine :
  float * float * float * 'a ->
  float * float -> float * float * float * float
val isVert : 'a * 'b * 'a * 'c -> bool
val isHorz : 'a * 'b * 'c * 'b -> bool
val string_of_line : float * float * float * float -> string
val line_of_string : string -> float * float * float * float
