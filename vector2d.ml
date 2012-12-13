(*
Exactly what it says on the tin.
Increasing clockwise, with 0 degrees lying on the X axis
*)

type vector2d = float * float;;

(* XXX: Cross and dot? 
*)

let create x y = (x,y);;

let x (x,_) = x;;
let y (_,y) = y;;

let setX (_,y) x = create (x,y);;
let setY (x,_) y = create (x,y);;

let (^+) (x1,y1) (x2,y2) = 
   (x1+.x2, y1+.y2)
;;

let (^-) (x1,y1) (x2,y2) = 
   (x1-.x2, y1-.y2)
;;

(** Scale a vector by a constant factor *)
let (^*) (x,y) d =
   (x*.d, y*.d)
;;

let (^/) (x,y) d =
   (x/.d, y/.d)
;;

let magnitude (x,y) = sqrt ((x *. x) +. (y *. y));;

let direction (x,y) =
   atan2 y x
;;


let createDirMag d m =
  let x = m *. (cos d)
  and y = m *. (sin d) in
    (x, y)

let addDirMag v d m =
   let v' = createDirMag d m in
   v ^+ v'
;;

let invert (x,y) =
   (-.x, -.y)
;;

let createRandom n =
  let x = (Random.float n) -. n /. 2.
  and y = (Random.float n) -. n /. 2. in
    (x,y)
;;

let string_of_vector2d (x,y) =
   Printf.sprintf "<%f,%f>" x y
;;

(** Treating vectors as points, we can get the distance between them *)
let distance v1 v2 =
   magnitude (v1 ^- v2)
;; 

(** Returns a vector parallel to the given one, but d longer or shorter *)
let offset v d =
   let v' = createDirMag (direction v) d in
   v ^- v'
;;

(** Returns whether or not two vectors (points) are within the given distance of
 * each other. *)
let within v1 v2 d =
   let xf,yf = v1 ^- v2 in
   ((xf *. xf) +. (yf *. yf)) < (d *. d)
;;
