let pi = 3.1415926535897932384626
let two_pi = 2.0 *. pi
and degrees = pi /. 180.0
let half_sqrt3 = 0.5 *. (sqrt 3.0)
and half_sqrt2 = 0.5 *. (sqrt 2.0)

let wrap f before after x =
  let () = before () in
  let y = f x in
  let () = after () in
  y
and before f g x =
  let () = g () in
  f x
and fun_sequence fs x =
  List.iter (fun f -> f x) fs

(* This $ operator is not quite the Haskell $ operator! *)
let identity x = x and constantly x _ = x
and (>>) f g x = g (f x) and ($) f x = f x

let translate (dx, dy) = GlMat.translate ~x:dx ~y:dy ()
and rotate theta = GlMat.rotate ~angle:(theta /. degrees) ~x:0.0 ~y:0.0 ~z:1.0 ()
and scale s = GlMat.scale ~x:s ~y:s ()
and scale2 (sx, sy) = GlMat.scale ~x:sx ~y:sy ()

let affine ?(t = (0.0, 0.0)) ?(r = 0.0) ?(s = 1.0) () =
  translate t; rotate r; scale s

let color (* ((r, g, b) as c) *) = GlDraw.color
and vertex (* ((x, y) as v) *) = GlDraw.vertex2
and texcoord (* ((s, t) as v) *) = GlTex.coord2

let with_matrix f = wrap f GlMat.push GlMat.pop
and with_attribs a f = wrap f (fun () -> GlMisc.push_attrib a) GlMisc.pop_attrib
and with_prim p f = wrap f (fun () -> GlDraw.begins p) GlDraw.ends

let translated dv f = with_matrix (before f (fun () -> translate dv))
and rotated theta f = with_matrix (before f (fun () -> rotate theta))
and scaled s f = with_matrix (before f (fun () -> scale s))
and colored c f = with_attribs [`current] (before f (fun () -> color c))
and affined ?(t = (0.0, 0.0)) ?(r = 0.0) ?(s = 1.0) f = with_matrix (before f (affine ~t ~r ~s))

let triangle =
  with_prim `triangles (fun () ->
    vertex (1.0, 0.0);
    vertex (-0.5, half_sqrt3);
    vertex (-0.5, -. half_sqrt3))
and inside_square =
  with_prim `quads (fun () ->
    vertex (1.0, 0.0);
    vertex (0.0, 1.0);
    vertex (-1.0, 0.0);
    vertex (0.0, -1.0))
and outside_square =
  with_prim `quads (fun () ->
    vertex (1.0, 1.0);
    vertex (-1.0, 1.0);
    vertex (-1.0, -1.0);
    vertex (1.0, -1.0))

class type ['w] animation = object
  method draw : 'w -> unit
  method step : float -> 'w -> 'w animation
end

let frame w a = a#draw w and forward dt w a = a#step dt w

let animated start step draw : 'w animation =
  object
    val state = start
    method draw = draw
    method step dt w = {< state = step dt w state >}
  end
and static draw : 'w animation =
  object (self)
    method draw = draw
    method step dt w = self
  end
and statically static_transformer sub : 'w animation =
  object
    val sub = sub
    method draw = static_transformer sub#draw
    method step dt w = {< sub = sub#step dt w >}
  end
and anim_sequence list : 'w animation =
  object
    val subs = list
    method draw w = List.iter (fun a -> a#draw w) subs
    method step dt w = {< subs = List.map (fun a -> a#step dt w) subs >}
  end
and dynamically draw_transformer step2 start2 sub : 'w animation =
  object
    val state2 = start2
    val sub = sub
    method draw = draw_transformer state2 sub#draw
    method step dt w = {< state2 = step2 dt w state2; sub = sub#step dt w >}
  end
and subobject obj_transformer sub : 'w animation =
  object
    val sub = sub
    method draw w = sub#draw (obj_transformer w)
    method step dt w = {< sub = sub#step dt (obj_transformer w) >}
  end

let spinning ?(start = 0.0) w_rate =
  let step dt w theta = theta +. (dt *. (w_rate w)) in
  dynamically rotated step start

type world_widget = { widget_active : bool }

let widget_anim =
  let red = (1.0, 0.0, 0.0) and blue = (0.0, 0.0, 1.0) and orange = (1.0, 0.5, 0.0) in
  let spin_rate w = if w.widget_active then 0.5 *. pi else 0.0 in
  anim_sequence
    [
     subobject ignore $ static (colored red outside_square);
     spinning spin_rate $ static (ignore >> colored blue (scaled 0.75 triangle));
     subobject ignore >> spinning (constantly (0.25 *. pi)) $ static (colored orange (scaled 0.35 triangle));
   ]

module Main = struct
  exception Quit

  let rec forever f x = forever f (f x)

  let our_widget = ref { widget_active = false }
  let our_widget_anim = ref widget_anim

  let toggle_widget () = 
    let { widget_active = a } = !our_widget in
    our_widget := { widget_active = (not a) }

  let handle_event ev =
    match ev with
      Sdlevent.QUIT -> raise Quit
    | Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE } -> raise Quit
    | Sdlevent.MOUSEBUTTONDOWN { Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } -> toggle_widget ()
    | _ -> ()

  let rec handle_events () =
    match Sdlevent.poll () with
      Some ev -> handle_event ev; handle_events ()
    | None -> ()

  let last_frame_time = ref 0

  let draw_frame () =
    GlClear.clear [`color];
    let this_frame_time = Sdltimer.get_ticks () in
    let dt = 0.001 *. (float_of_int (this_frame_time - !last_frame_time)) in
    our_widget_anim := (!our_widget_anim)#step dt !our_widget;
    (!our_widget_anim)#draw !our_widget;
    last_frame_time := this_frame_time;
    Sdlgl.swap_buffers ()

  let main_iteration () =
    handle_events ();
    draw_frame ();
    Sdltimer.delay 5

  let init_gl () = begin
    GlMat.mode `projection;
    GlMat.load_identity ();
    GluMat.ortho2d ~x:(-2.0, 2.0) ~y:(-2.0, 2.0);
    GlMat.mode `modelview;
    GlMat.load_identity ();
    List.iter Gl.disable [`blend; `cull_face; `depth_test; `lighting];
  end

  let wm_title = "Awfully Primitive OpenGL Combinators Demo"

  let main () = begin
    Sdl.init [`VIDEO; `TIMER];
    Sdlgl.set_attr [Sdlgl.DOUBLEBUFFER true];
    ignore (Sdlvideo.set_video_mode ~w:320 ~h:320 [`OPENGL]);
    Sdlwm.set_caption ~title:wm_title ~icon:wm_title;
    init_gl ();
    last_frame_time := Sdltimer.get_ticks ();
    (try (forever main_iteration ()) with Quit -> ());
    Sdl.quit ()
  end
end

let _ = Main.main ()
