open Sdlvideo;;
open Input;;
open Drawing;;

let print1 _ =
  print_endline "One!";
;;

let print2 _ = 
  print_endline "Two!";
;;

let print3 _ s = 
  print_endline "Three!"; s
;;

let print4 _ = 
  print_endline "Four!";
;;

let print5 _ =
  print_endline "Five!";
;;

let print6 _ = 
  print_endline "Six!";
;;

let randomPoint x y =
   let xr = (Random.float (x *. 2.)) -. x
   and yr = (Random.float (y *. 2.)) -. y in
   (xr, yr)
;;
let randomColor () =
   let r = Random.float 1.
   and g = Random.float 1.
   and b = Random.float 1. in
   (r,g,b)
;;

let randomTriangle =
   let x = 1.25
   and y = 1.0 in
   let verts = [randomPoint x y; randomPoint x y; randomPoint x y] in
   withPrim `triangles (fun () -> vertices verts)
;;

let randomColoredTriangle =
   let r = Random.float 1.
   and g = Random.float 1.
   and b = Random.float 1. in
   withMatrix (colored (r,g,b) randomTriangle)
;;

(* The above don't work right.  Let's try something else. *)
let coloredTriangle c verts =
   withMatrix (colored c (withPrim `triangles (fun () -> vertices verts)))
;;

let accumulate n f =
   let rec loop n accm =
      if n = 0 then
         accm
      else
         loop (n - 1) ((f n) :: accm)
   in
   loop n []
;;

let randomTriangle _ =
   let points = accumulate 3 (fun _ -> randomPoint 1.25 1.0)
   and color = randomColor () in
   coloredTriangle color points
;;

let listMapi f lst =
   let rec loop i lst accm =
      if lst = [] then accm
      else
         let hd = List.hd lst
         and tl = List.tl lst in
           loop (i + 1) tl ((f i hd) :: accm)
   in
   List.rev (loop 0 lst [])
;;




let doDrawing () =
   let font = Loader.loadFont "cour.ttf" 18 in
   let tex = Loader.loadTexture2d "test.png" in
   let text = Text.ure "Hello world" font (255, 255, 0) in
   let scene = listMapi (fun i x -> (i,x)) (accumulate 100 randomTriangle) in
   let scene = (1000, texSquare tex) :: scene in
   let scene = (1002, arc 7 0.5 0. 220.) :: scene in
   let scene = (1003, texSquare text) :: scene in 
   drawScene scene
;;

let doMainloop input = 
   let rec loop ic continue =
      if continue then begin
         let (ic, continue) = Input.doInput ic continue in
         doDrawing ();
         Sdltimer.delay 50;
         loop ic continue	   
      end
      else
         ()
   in
   loop input true
;;


let main () =
  Util.init 800 600;
  setView (-1.25) 1.25 (-1.0) 1.0;
  let ic = Input.createContext () in
  let ic = Input.bindMany Input.bindButtonPress ic
     [(Sdlkey.KEY_q, (fun _ c -> not c));
     (Sdlkey.KEY_SPACE, print3)] in
  let ic = Input.bindQuit ic (fun c -> not c) in

  doMainloop ic;

  Util.quit ();
;;




let _ =  main ();;
