(* resources.ml
   A hashtable of resources, ie images, sounds, or musics.
   This makes sure I don't have to load everything a gajillion
   times and waste lots of space/time.

   Shall we make this a real cache?  A la, things fall off the end when
   they aren't used for a while?

   ...let's not.  This will be sufficient for most things that I will make,
   I'm sure.

   There are two options: either it loads all the given resources immediately,
   or it waits until a resource is demanded before loading it.  Startup
   wait vs. runtime wait.  I think I'll go for the latter, since the overall
   effect is probably better and it'll never happen twice.  Yeah.

   So now I'm still worried about what happens if lots of resources are
   loaded and none are ever freed.  I am NOT going to build a conservative
   GC into this thing!  Ah well, it'll probably be okay; the only thing that
   might cause a problem are the sounds.

*)

type resourcePool = {
    texture : (string, GlTex.texture_id) Hashtbl.t;
    sound : (string, Sdlmixer.chunk) Hashtbl.t;
    config : (string, Cfg.config) Hashtbl.t;
    font : (string, Sdlttf.font) Hashtbl.t;
  };;

let createResourcePool () = {
    texture = Hashtbl.create 24;
    sound = Hashtbl.create 24;
    config = Hashtbl.create 24;
    font = Hashtbl.create 8;
  };;

let getTex pool name =
  try
     Hashtbl.find pool.texture name
  with
     Not_found ->
        let tex = Loader.loadTexture2d name in
        Hashtbl.add pool.texture name tex;
        tex
;;

let freeTex pool pool name =
  Hashtbl.remove pool.texture name
;;


let getSound pool name =
  try
     Hashtbl.find pool.sound name
  with
     Not_found ->
        let sound = Loader.loadSound name in
        Hashtbl.add pool.sound name sound;
        sound
;;

let freeSound pool name =
  Hashtbl.remove pool.sound name
;;


let getConfig pool name =
  try
     Hashtbl.find pool.config name
  with
     Not_found ->
        let cfg = Loader.loadConfig name in
        Hashtbl.add pool.config name cfg;
        cfg
;;

let freeConfig pool name =
  Hashtbl.remove pool.config name
;;
    
let getFont pool name size =
  let realname = Printf.sprintf "%s:%d" name size in
  try
     Hashtbl.find pool.font realname
  with
     Not_found ->
        let font = Loader.loadFont name size in
        Hashtbl.add pool.font realname font;
        font
;;

let freeFont pool name size =
  let realname = Printf.sprintf "%s:%d" name size in
  Hashtbl.remove pool.font realname
;;
