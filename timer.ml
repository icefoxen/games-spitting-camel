(* General timers.
   Measures in milliseconds.
   Note that if the interval is exceeded several times, the callback
   will still only be called once.
   This may be a bug.
*)

class timer callback interval times step thn =
object (self)
   val thn = thn
   val interval = interval
   val times = times
   val callback = callback

  method active = times > 0

  method intervalIsPassed now =
     (thn - now) > interval

  method calc now =
    if (times < 1) then
       self
    else if self#intervalIsPassed now then
       let () = callback (thn+interval) in
       {< times = times - step; thn = thn + interval >}
    else
       self
end;;

let intervalTimer interval now = new timer ignore interval 1 0 now
and callbackTimer interval callback now = new timer callback interval 1 0 now
and limitedCallbackTimer interval callback times now =
   new timer callback interval times 1 now
;;

