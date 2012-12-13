(* Loading stuff.
*)

exception LoaderException of string

(* This breaks abstraction, which is terrible.
 * I think it's better than trying to expose an optional argument up to the
 * occasional user who will need it, through about three levels of abstraction
 *)
let little_endian = ref true;;

(* Copies the given surface into a 32-bit RGB surface *)
let canonifySurface surf =
   let w, h, _bpp = Sdlvideo.surface_dims surf in
   let ns = if !little_endian then
      Sdlvideo.create_RGB_surface [] ~w ~h ~bpp: 32 
      ~rmask: 0x000000FFl ~gmask: 0x0000FF00l ~bmask: 0x00FF0000l
      ~amask: 0xFF000000l
   else
      Sdlvideo.create_RGB_surface [] ~w ~h ~bpp: 32 
      ~rmask: 0xFF000000l ~gmask: 0x00FF0000l ~bmask: 0x0000FF00l
      ~amask: 0x000000FFl
   in
   Sdlvideo.blit_surface ~src: surf ~dst: ns ();
   ns
;;

let loadImg name =
  let n = (Sdlloader.load_image name) in
  (*let n = Sdlvideo.display_format ~alpha:true n in
    Sdlvideo.set_color_key n (Sdlvideo.map_RGB n (255,0,255)); *)
    canonifySurface n
;;


let debug raw =
  let l = Raw.length raw in
  let s = Raw.gets raw ~pos: 0 ~len: l in
    Printf.printf "Length: %d\n" l;
    Array.iter (fun x -> Printf.printf "%X" x) s;
    print_endline "";
;;

let texture_of_surf typ surf =
  let tex = GlTex.gen_texture () in
  let x, y, _bpp = Sdlvideo.surface_dims surf in
  if Util.powerOfTwo x && Util.powerOfTwo y then begin
     GlMisc.push_attrib [`texture];
     let img = GlPix.of_raw (Sdlgl.to_raw surf) ~format: `rgba 
                            ~width: x ~height: y in 
    GlTex.bind_texture typ tex;
    GlTex.image2d img;
    GlTex.parameter typ (`min_filter( `linear ));
    GlTex.parameter typ (`mag_filter( `linear ));
    GlMisc.pop_attrib ();
    (* Gc.finalise GlTex.delete_texture tex; *)
      tex;
   end 
   else
      raise (LoaderException( "Texture dimensions must be a power of 2!" ))

let texture2d_of_surface surf = texture_of_surf `texture_2d surf
let texture1d_of_surface surf = texture_of_surf `texture_1d surf

let loadTexture typ name =
  try
  let i = loadImg name in
  let t = texture_of_surf typ i in
    t
  with
     LoaderException( _ ) ->
        raise (LoaderException( "Texture " ^ name ^ " has dimensions not a power of 2." ))

let loadTexture2d = loadTexture `texture_2d
let loadTexture1d = loadTexture `texture_1d


let loadSound name =
  let s = Sdlmixer.loadWAV name in
    Gc.finalise Sdlmixer.free_chunk s;
    s
;;

let loadConfig name =
  Cfg.loadFile name
;;

let loadFont name size =
  Sdlttf.open_font name size
;;

