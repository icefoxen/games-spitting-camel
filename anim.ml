(** Animations are represented by a list of gobs, the location of which is
    a relative offset to wherever the animation is drawn, a list of
    timings between frames, and information on the current frame and time.
    Animations will loop forever if given the opportunity.
*)


(** XXX: Do we want each frame to have more than one gob?  We'll see. 
    XXX: Do we want it to have a specific location...?  Probably.  -_-
    XXX: Now,the DRACONIC way to do it would be to have a function that
    takes a number and the previous gob, and creates a new one based on
    that...
*)
type anim = {
   an_gobs : Graphics.gob array;
   an_delays : int array;
   an_current : int;
   an_delay : int;
};;

(** framelist = a list of (gob,delay) tuples *)
let makeAnim framelist = 
   let gobs, delays = List.split framelist in
   let gobs = Array.of_list gobs
   and delays = Array.of_list delays in
   {
      an_gobs = gobs;
      an_delays = delays;
      an_current = 0;
      an_delay = delays.(0)
   }
;;


(** Not the most EFFICIENT way of doing it, I'm sure, but simple *)

let rec calc anim dt =
   let newt = anim.an_delay - dt in
   if newt > 0 then
      { anim with an_delay = newt }
   else
      let nextAnim = (anim.an_current + 1) mod 
                     ((Array.length anim.an_gobs) - 1) in
      calc {anim with 
	      an_current = nextAnim; 
	      an_delay = anim.an_delays.(nextAnim)} 
           (dt - anim.an_delay)
;;

let drawAnim scene anim =
   ()
;;
