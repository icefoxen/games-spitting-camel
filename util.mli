val string_of_bool : bool -> string
val pi : float
val twoPi : float
val degrees : float
val radians : float
val halfSqrt3 : float
val halfSqrt2 : float
val ( << ) : ('a -> 'b) -> ('c -> 'a) -> 'c -> 'b
val ( >> ) : ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c
val delay : ('a -> 'b) -> 'a -> unit -> 'b
val delay2 : ('a -> 'b -> 'c) -> 'a -> 'b -> unit -> 'c
val wrap : ('a -> 'b) -> (unit -> unit) -> (unit -> unit) -> 'a -> 'b
val before : ('a -> 'b) -> (unit -> unit) -> 'a -> 'b
val explode2 : ('a -> 'b -> 'c) -> 'a * 'b -> 'c
val implode2 : ('a * 'b -> 'c) -> 'a -> 'b -> 'c
val powerOfTwo : int -> bool
val absf : float -> float
val within : float -> float -> float -> bool
val initGL : int -> int -> unit
val init : ?title:string -> int -> int -> unit
val quit : unit -> 'a
