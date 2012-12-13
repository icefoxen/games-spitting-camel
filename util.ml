(* util.ml
   Basic utility junk and global vars.
*)

let string_of_bool = function
    true -> "true"
  | false -> "false"
;;

(* Kudos to Premchaia for all the combinators. *)
let pi = 3.1415926535897932384626
let twoPi = 2.0 *. pi
and degrees = pi /. 180.0
and radians = 180.0 /. pi
let halfSqrt3 = 0.5 *. (sqrt 3.0)
and halfSqrt2 = 0.5 *. (sqrt 2.0)


(* Functiony things *)
(* Compose *)
let (<<) f g x = f (g x)
and (>>) f g x = g (f x)
(* Other handy funcs *)
and delay f x = fun () -> f x
and delay2 f x y = fun () -> f x y
and wrap f before after x =
  let () = before () in
  let y = f x in
  let () = after () in
    y
and before f before x = 
  let () = before () in
    f x

and explode2 f (a,b) = f a b 
and implode2 f x y = f (x,y)

(* I'm sure this could be written better *)
(* It is also unnecessary
and iter3 f a b c =
  let loop a b c =
    let ha :: ta = a
    and hb :: tb = b
    and hc :: tc = c in
    let () = f ha hb hc in
      if ta = [] then
	()
      else
	loop ta tb tc
  in
  let la = List.length a
  and lb = List.length b
  and lc = List.length c in
    if (la = lb) && (la = lc) then
      loop a b c
    else
      raise (Invalid_argument "Util.iter3")
;;
*)
(*
let absmod x y = 
  let n = x mod y in
    abs n
;;
*)

(* Numbery things *)
(* Magic!
   For unsigned integers.  Replace x <> 0 with x > 0 if signed *)
let powerOfTwo x = ((x land (x-1)) == 0) && (x <> 0)

and absf x =
  if x < 0. then
    -.x
  else
    x


(* Return true if a is equal to b within the given delta *)
let within a b delta = absf (a -. b) > delta

(** Initializes OpenGL in a hopefully sane manner.
 *)
let initGL w h =
  GlDraw.shade_model `smooth;
  GlDraw.polygon_mode `front `fill;
  GlClear.color (0., 0., 0.);
  GlClear.depth 1.0;
  GlClear.clear [`color; `depth];
  (*Sdlgl.set_attr [Sdlgl.DOUBLEBUFFER true]; *)
  List.iter Gl.disable [`depth_test; `cull_face; `lighting];
  List.iter Gl.enable [`blend; `texture_2d; `texture_1d];

  GlDraw.viewport ~x: 0 ~y: 0 ~w: w ~h: h;
;;


(** Initialize stuff and create screen context.
 *  x and y are the resolution of the screen.
 * Note that Drawing.setView still needs to be called.
*)
let init ?(title="Spitting Camel") x y =
  Sdl.init [`EVERYTHING];
  Sdlwm.set_caption ~title: title ~icon: "None";
  Sdlttf.init ();
  Random.self_init ();

  initGL x y;
  let screen = Sdlvideo.set_video_mode ~w: x ~h: y ~bpp: 16 
  [`OPENGL; `DOUBLEBUF; `HWSURFACE] in
    ignore screen;

;;


(** Shuts down the necessary things *)
let quit () =
   Sdlttf.quit ();
   Sdl.quit ();
   exit 0;
;;


