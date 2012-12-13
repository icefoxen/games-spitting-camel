(** box.ml
    An box, which is a generalized type for collision detection.
    Right now, we only do axis-aligned bounding boxes.
*) 


open Vector2d

(* The location representing the center of the box, and the 
   data needed to collide it with things.
*)
type box = {
   b_loc : vector2d; (** Bottom-left corner of bounding box *)
   b_w : float; (** Width *)
   b_h : float; (** Height *)
};;

(* A line is represented by ts endpoints.  *)
type line = float * float * float * float



let createBox loc w h = {
      b_loc = loc;
      b_w = w;
      b_h = h;
   } 
;;

let moveBox box vec = {
   box with b_loc = box.b_loc ^+ vec
};;

let moveBoxTo box vec = {
   box with b_loc = vec
};;
   
(** Simple axis-aligned bounding boxes *)
let collideBox a1 a2 =
   let a1left, a1bottom = a1.b_loc
   and a2left, a2bottom = a2.b_loc in
   let a1right = a1left +. a1.b_w
   and a2right = a2left +. a2.b_w
   and a1top = a1bottom +. a1.b_h
   and a2top = a2bottom +. a2.b_h in
   if a1bottom > a2top then
      false
   else if a2bottom > a1top then
      false
   else if a1left > a2right then
      false
   else if a2left > a1right then
      false
   else
      true
;;

let collideBoxPoint a (px,py) =
   let aleft, abottom = a.b_loc in
   let aright = aleft +. a.b_w
   and atop = abottom +. a.b_h in
   if px < aleft then
      false
   else if py < abottom then
      false
   else if px > aright then
      false
   else if py > atop then
      false
   else
      true
;;


(** Avoiding sqrt for obfustication and profit *)
let collideCircle vec1 r1 vec2 r2 =
   let distx,disty = vec1 ^- vec2 in
   let size = (r1 +. r2) in 
   ((distx *. distx) +. (disty *. disty)) < (size *. size)
;;

let lines_of_box box =
   let x1, y1 = box.b_loc in
   let x2 = x1 +. box.b_w 
   and y2 = y1 +. box.b_w in
   [(x1, y1, x1, y2); (x1, y2, x2, y2); (x2, y2, x2, y1); (x2, y1, x1, y1)]
;;



let isBetween thing lower upper = (thing >= lower) && (thing <= upper)

(* Turns it into a line of type... um...  y = Ax+B, excep there's a C in 
   there as well... *)
let canonifyLine line =
  let  x1, y1, x2, y2 = line in
  let a = y2 -. y1
  and b = x1 -. x2 in
  let c = (a *. x1) +. (b *. y1) in 
    (a, b, c)
;;


(* From http://www.ucancode.net/faq/C-Line-Intersection-2D-drawing.htm
One of the most common tasks you will find in geometry problems is line intersection. Despite the fact that it is so common, a lot of coders still have trouble with it. The first question is, what form are we given our lines in, and what form would we like them in? Ideally, each of our lines will be in the form Ax+By=C, where A, B and C are the numbers which define the line. However, we are rarely given lines in this format, but we can easily generate such an equation from two points. Say we are given two different points, (x1, y1) and (x2, y2), and want to find A, B and C for the equation above. We can do so by setting 
A = y2-y1
B = x1-x2
C = A*x1+B*y1
Regardless of how the lines are specified, you should be able to generate two different points along the line, and then generate A, B and C. Now, lets say that you have lines, given by the equations:
A1x + B1y = C1
A2x + B2y = C2
To find the point at which the two lines intersect, we simply need to solve the two equations for the two unknowns, x and y. 
    double det = A1*B2 - A2*B1
    if(det == 0){
        //Lines are parallel
    }else{
        double x = (B2*C1 - B1*C2)/det
        double y = (A1*C2 - A2*C1)/det
    }
To see where this comes from, consider multiplying the top equation by B2, and the bottom equation by B1. This gives you
A1B2x + B1B2y = B2C1
A2B1x + B1B2y = B1C2
Now, subtract the bottom equation from the top equation to get
A1B2x - A2B1x = B2C1 - B1C2
Finally, divide both sides by A1B2 - A2B1, and you get the equation for x. The equation for y can be derived similarly. 

This gives you the location of the intersection of two lines, but what if you have line segments, not lines. In this case, you need to make sure that the point you found is on both of the line segments. If your line segment goes from (x1,y1) to (x2,y2), then to check if (x,y) is on that segment, you just need to check that min(x1,x2) ? x ? max(x1,x2), and do the same thing for y. You must be careful about double precision issues though. If your point is right on the edge of the segment, or if the segment is horizontal or vertical, a simple comparison might be problematic. In these cases, you can either do your comparisons with some tolerance, or else use a fraction class.

*)
let collideLine line1 line2 =
  let xa1, ya1, xa2, ya2 = line1
  and xb1, yb1, xb2, yb2 = line2 in
  let a1, b1, c1 = canonifyLine line1
  and a2, b2, c2 = canonifyLine line2 in
  let det = (a1 *. b2) -. (a2 *. b1) in  (* Relative slope, I believe *)
    if det = 0.0 then
      None (* Lines are parallel (but may also be identical *)
    else
      let x = ((b2 *. c1) -. (b1 *. c2)) /. det
      and y = ((a1 *. c2) -. (a2 *. c1)) /. det in
	if (isBetween x (min xa1 xa2) (max xa1 xa2)) &&
	  (isBetween y (min ya1 ya2) (max ya1 ya2)) &&
	  (isBetween x (min xb1 xb2) (max xb1 xb2)) &&
	  (isBetween y (min yb1 yb2) (max yb1 yb2)) then
	    Some( (x, y) )
	else
          None
;;

let slope line = let x1, y1, x2, y2 = line in (y2 -. y1) /. (x2 -. x1)



(* Collides an box with a line.  Kinda sucky name, I know... *)
let collideBoxLine box line =
  let boxLines = lines_of_box box in
  let rec loop l accm =
    if accm = [] then
      false
    else
      let first = List.hd accm
      and rest = List.tl accm in
      match collideLine l first with
         None -> loop l rest
       | Some( _ ) -> true
  in
    loop line boxLines
;;


(* Returns < 0 for left of, 0 for right on (unlikely), and > 0 for right of. 

   XXX: THIS DOESN'T BLEEDIN' WORK if the slope of the incoming line
   is negative, or something close to that.
   Crap.
*)
let pointRelative line x y =
  let s = slope line 
  and x1, y1, x2, y2 = line in
  let line2 = (x1, y1, x, y) in
  let s2 = slope line2 in
  let ds = s -. s2 in
    if s > 0. then
      ds
    else
      -.ds
;;

let createLine x0 y0 x1 y1 = (x0, y0, x1, y1)

let moveLine line vec =
  let x0, y0, x1, y1 = line
  and xoff, yoff = vec in
    (x0 +. xoff, y0 +. yoff, x1 +. xoff, y0 +. yoff)

let isVert line = let x0, _, x1, _ = line in x0 = x1

let isHorz line = let _, y0, _, y1 = line in y0 = y1
  

let string_of_line line =
  let x1, y1, x2, y2 = line in
  Printf.sprintf "(%f,%f)(%f,%f)" x1 y1 x2 y2

(* Not sure if this is the best way, but... *)
let line_of_string str = 
   Scanf.sscanf str "(%f,%f)(%f,%f)" (fun x1 y1 x2 y2 -> (x1, y1, x2, y2))

