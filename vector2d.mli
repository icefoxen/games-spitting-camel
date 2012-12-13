type vector2d = float * float
val create : 'a -> 'b -> 'a * 'b
val x : 'a * 'b -> 'a
val y : 'a * 'b -> 'b
val setX : 'a * 'b -> 'c -> 'd -> ('c * 'b) * 'd
val setY : 'a * 'b -> 'c -> 'd -> ('a * 'c) * 'd
val ( ^+ ) : float * float -> float * float -> float * float
val ( ^- ) : float * float -> float * float -> float * float
val ( ^* ) : float * float -> float -> float * float
val ( ^/ ) : float * float -> float -> float * float
val magnitude : float * float -> float
val direction : float * float -> float
val createDirMag : float -> float -> float * float
val addDirMag : float * float -> float -> float -> float * float
val invert : float * float -> float * float
val createRandom : float -> float * float
val string_of_vector2d : float * float -> string
val distance : float * float -> float * float -> float
val offset : float * float -> float -> float * float
val within : vector2d -> vector2d -> float -> bool
