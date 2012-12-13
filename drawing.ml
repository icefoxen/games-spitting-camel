(* Okay, let's try a function-based approach to drawing, rather than
   a data-based approach.

*)

open Sdlvideo
open Util

(* Basics *)
let withMatrix f = wrap f GlMat.push GlMat.pop
and withPrim prim f = wrap f (fun () -> GlDraw.begins prim) GlDraw.ends
and withAttribs attrib f = 
  wrap f (fun () -> GlMisc.push_attrib attrib) GlMisc.pop_attrib


let vertices v =
   List.iter GlDraw.vertex2 v

(* See if you can make this better *)
let texturedVertices uv verts =
  let rec draw uv vert =
      GlTex.coord2 uv;
      GlDraw.vertex2 vert;
  in
    List.iter2 draw uv verts
;;

let translate (x,y) = GlMat.translate ~x ~y ();;
let rotate theta =
  GlMat.rotate ~angle: (theta *. radians) ~x: 0. ~y: 0. ~z: 1. ()
let scale s = GlMat.scale ~x: s ~y: s ()
let scale2 (x,y) = GlMat.scale ~x ~y
let affine ?(t = (0., 0.)) ?(r = 0.) ?(s = 1.) () =
  translate t; rotate r; scale s
let texture tex target = GlTex.bind_texture ~target tex
let color = GlDraw.color



(* Combinators *)
let translated vec f = withMatrix (before f (fun () -> translate vec))
let rotated theta f = withMatrix (before f (fun () -> rotate theta))
let scaled s f = withMatrix (before f (fun () -> scale s))
let colored ?(alpha = 1.0) c f = 
  withAttribs [`current] (before f (fun () -> color ~alpha c))
let textured tex target f = 
  withAttribs [`texture] (before f (fun () -> texture tex target))
let affined ?(t = (0., 0.)) ?(r = 0.) ?(s = 1.) f =
  withMatrix (before f (fun () -> affine ~t ~r ~s ()))


(* Handy shortcuts 
   Notice they still don't use withMatrix; I feel like that should come at the
   very top, or at least be under explicit control.
*)
let triangle =
  let verts = [(1., 0.); (-0.5, halfSqrt3); (-0.5, -. halfSqrt3)] in
    withPrim `triangles (fun () -> vertices verts)

let square =
  let verts = [(-0.5, -0.5); (-0.5, 0.5); (0.5, 0.5); (0.5, -0.5)] in
    withPrim `quads (fun () -> vertices verts)

let texSquare tex =
   let verts = [(-0.5, -0.5); (-0.5, 0.5); (0.5, 0.5); (0.5, -0.5)]
   and uv = [(0.0, 0.0); (0.0, 1.0); (1.0, 1.0); (1.0, 0.0)] in
    textured tex `texture_2d 
      (withPrim `quads (fun () -> texturedVertices uv verts))



(* Grump.  The ?quad:GluQuadric.t argument to the GluQuadric functions causes
 * Issues here. *)
let circle slices () =
  GluQuadric.disk ~inner: 0. ~outer: 0.5 ~slices ~loops: 1 ()

let ring slices inner () =
  GluQuadric.disk ~inner ~outer: 0.5 ~slices ~loops: 1 ()

let arc slices thickness start sweep () =
  let inner = 0.5 -. thickness in
  GluQuadric.partial_disk ~inner ~outer: 0.5 ~slices ~start ~sweep ~loops: 1 ()

(* Like a pie-slice! *)
let slice slices start sweep () =
  GluQuadric.partial_disk ~inner: 0. ~outer: 0.5 ~slices ~start ~sweep ~loops: 1 ()




(* Ordering functions, so we can draw things back-to-front and have it layer 
   right. *)
type scene = (int * (unit -> unit)) list

let emptyScene : scene = []

let addToScene scene layer f =
  (layer, f) :: scene
;;

let addListToScene scene layer lst =
   let l = List.map (fun x -> (layer, x)) lst in
   l @ scene
;;

let mergeScene scene1 scene2 =
   scene1 @ scene2
;;

let drawScene scene =
  let orderedScene = List.sort (fun (n1,_) (n2,_) -> compare n1 n2) scene in
  GlClear.clear [`color];
  withMatrix (fun () -> List.iter (fun (_, f) -> f ()) orderedScene) ();
  Sdlgl.swap_buffers ();
  Sdlvideo.flip (Sdlvideo.get_video_surface ());
;;


(* GL functions *)

(* This... might not be correct.  In fact it might be vastly incorrect.
   But the correct way might need drawing front-to-back, which is
   unacceptable.
   It honestly might be simpler to write a shader to do a postprocessing
   step.
   Do not use this until I've made some sort of decision on it and done a lot
   more testing.
*)
let antialias flag =
  if flag then begin
      List.iter Gl.enable [`line_smooth; `polygon_smooth];
      GlMisc.hint `line_smooth `nicest;
      GlMisc.hint `polygon_smooth `nicest;
      GlFunc.blend_func `src_alpha `one_minus_src_alpha;
    end
  else begin
      List.iter Gl.disable [`line_smooth; `polygon_smooth];
    end
;;

let setView left right top bottom =
  GlMat.mode `projection;
  GlMat.load_identity ();
  GluMat.ortho2d ~x:(left, right) ~y:(bottom,top);
  GlMat.mode `modelview;
;;
