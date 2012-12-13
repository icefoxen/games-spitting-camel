class timer :
  (int -> unit) ->
  int ->
  int ->
  int ->
  int ->
  object ('a)
    val callback : int -> unit
    val interval : int
    val thn : int
    val times : int
    method active : bool
    method calc : int -> 'a
    method intervalIsPassed : int -> bool
  end
val intervalTimer : int -> int -> timer
val callbackTimer : int -> (int -> unit) -> int -> timer
val limitedCallbackTimer : int -> (int -> unit) -> int -> int -> timer
