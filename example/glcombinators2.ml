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
and array_fun_sequence fs x =
  Array.iter (fun f -> f x) fs

(* This $ operator is not quite the Haskell $ operator! *)
let identity x = x and constantly x _ = x
and (>>) f g x = g (f x) and (<<) f g x = f (g x)
and ($) f x = f x and ignoring _ x = x

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

(* ---------------------------------------- *)

class type [-'i, +'o] process = object
  method read : 'o
  method step : float -> 'i -> ('i, 'o) process
end

let static x =
  object (self)
    method read = x
    method step _ _ = self
  end

let compose_process a b =
  object
    val a = a
    val b = b
    method read = b#read
    method step dt w =
      let a' = a#step dt w in
      let b' = b#step dt a'#read in
      {< a = a'; b = b' >}
  end

let (@>>) a b = compose_process a b
and (@<<) b a = compose_process a b

let statically f sub =
  object
    val sub = sub
    method read = f sub#read
    method step dt w = {< sub = sub#step dt w >}
  end
and statically2 f sub1 sub2 =
  object
    val sub1 = sub1
    val sub2 = sub2
    method read = f sub1#read sub2#read
    method step dt w = {< sub1 = sub1#step dt w; sub2 = sub2#step dt w >}
  end

let (@+.) sub offset = statically (fun x -> x +. offset) sub
and (@*.) sub factor = statically (fun x -> x *. factor) sub

let statefully step start =
  object (self)
    val state = start
    method read = state
    method step dt w = {< state = step dt w state >}
  end

let timefully step = statefully (fun dt _ -> step dt)
and updatefully step = statefully (fun _ w -> step w)
and immediately f = statefully (fun dt w _ -> f w)

let warping f sub =
  object
    val sub = sub
    method read = sub#read
    method step dt w =
      let (dt', w') = f dt w in
      {< sub = sub#step dt' w' >}
  end

let warping_time f = warping (fun dt w -> (f dt, w))
and warping_input f = warping (fun dt w -> (dt, f w))
let subobject = warping_input

let modulating f modulator carrier =
  object
    val modulator = modulator
    val carrier = carrier
    method read = carrier#read
    method step dt w =
      let modulator' = modulator#step dt w in
      let (dt', w') = f modulator'#read dt w in
      let carrier' = carrier#step dt' w' in
      {< modulator = modulator'; carrier = carrier' >}
  end

let modulating_time f = modulating (fun m dt w -> (f m dt, w))
and modulating_input f = modulating (fun m dt w -> (dt, f m w))

let parallel combiner array =
  object
    val subs = array
    method read = combiner (Array.map (fun p -> p#read) subs)
    method step dt w = {< subs = Array.map (fun p -> p#step dt w) subs >}
  end

let phasor input =
  let integrator = statefully (fun dt input state -> fst (modf (state +. (input *. dt)))) 0.0 in
  input @>> integrator

type 'w animation = ('w, unit -> unit) process
let anim_stack anims = parallel array_fun_sequence anims

(* ------------------------------------------------------------ *)

let spinning (rate : ('a, float) process) (anim : 'a animation) : 'a animation =
  let angle = (phasor rate) @*. two_pi in
  statically2 rotated angle anim

type world_widget = { widget_active : bool }

let widget_anim =
  let red = (0.5, 0.0, 0.0) and blue = (0.0, 0.0, 1.0) and orange = (1.0, 0.5, 0.0) in
  let spin_rate w = if w.widget_active then 0.25 else 0.0 in
  anim_stack
    [|
      static (ignore >> colored red outside_square);
      spinning (immediately spin_rate 0.0) $ static (ignore >> colored blue (scaled 0.75 triangle));
      spinning (static 0.25) $ static (ignore >> colored orange (scaled 0.35 triangle));
    |]

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
    (!our_widget_anim)#read ();
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

  let wm_title = "Still Primitive OpenGL Combinators Demo"

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
