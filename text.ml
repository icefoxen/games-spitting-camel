(* text.ml
*)

open Sdlvideo;;

(* Text.ure
   Oh, I kill me.

   XXX: This uses SDL colors, where the rest of the universe uses opengl colors
   Also, it doesn't return a texture with dimensions equal to powers of two,
   which makes life more interesting.
*)

let ure txt font col =
  let i = Sdlttf.render_text_solid font txt ~fg: col in
  let j = Sdlvideo.create_RGB_surface_format i [] ~w: 512 ~h: 512 in
  Sdlvideo.blit_surface ~src: i ~dst: j ();
  let tex = Loader.texture2d_of_surface (Loader.canonifySurface j) in
    tex
;;
