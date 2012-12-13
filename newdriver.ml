(* Sigh.
   We need fixed-rate physics and variable-rate drawing.
   So.
*)


(* Represents the game at a single point in time *)
(* We need a function to feed it into to turn frame(t) into frame(t+1).
   Then we need another function that takes in frame(t), and frame(t-1), and
   interpolates between them.
*)


(*module Mainloop (Thing : T) = *)
type frame = {
   f_objects : Thing.t list;
   f_timers : Timer.timer list;
   f_physicsTimer : Timer.timer;
   f_framecount : int;
   f_now : int;
   f_input : Input.inputContext;
   f_resources : Resources.resourcePool;

};;
