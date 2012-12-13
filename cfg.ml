(* Lists are a bit imperfectly supported, but it's really hard to make a good
variant-type for them in OCaml, it seems.
*)

open Cfgtype

exception Cfg_error of string

type config = (string, Cfgtype.cfgval) Hashtbl.t;;

let loadFile (file : string) : config = 
   let configify table (key,vl) =
      Hashtbl.add table key vl
   in
   try
   let f = open_in file in
      let lexbuf = Lexing.from_channel f in
      let result = Cfgparse.main Cfglex.start lexbuf in
      let table = Hashtbl.create 16 in
      List.iter (configify table) result;
      table
   with
      Sys_error( s ) -> raise (Cfg_error( s ))
;;

let get (tbl : config) key =
   try
      Hashtbl.find tbl key
   with
      Not_found -> raise (Cfg_error( key ^ ": Not found" ))
;;

let getString (tbl : config) key =
   match get tbl key with
      CfgString( s ) -> s
    | CfgInt( _ ) -> raise (Cfg_error( key ^ ": tried to get string, got int"))
    | CfgFloat( _ ) -> raise (Cfg_error( key ^ ": tried to get string, got float"))
    | CfgList( _ ) -> raise (Cfg_error( key ^ ": tried to get string, got list"))
;;

let getInt (tbl : config) key =
   match get tbl key with
      CfgInt( s ) -> s
    | CfgString( _ ) -> raise (Cfg_error( key ^ ": tried to get int, got string"))
    | CfgFloat( _ ) -> raise (Cfg_error( key ^ ": tried to get int, got float"))
    | CfgList( _ ) -> raise (Cfg_error( key ^ ": tried to get int, got list"))
;;

let getFloat (tbl : config) key =
   match get tbl key with
      CfgFloat( s ) -> s
    | CfgString( _ ) -> raise (Cfg_error( key ^ ": tried to get float, got string"))
    | CfgInt( _ ) -> raise (Cfg_error( key ^ ": tried to get float, got int"))
    | CfgList( _ ) -> raise (Cfg_error( key ^ ": tried to get float, got list"))
;;


let rec string_of_cfgval = function
   CfgFloat( f ) -> string_of_float f
 | CfgInt( i ) -> string_of_int i
 | CfgString( s ) -> s
 | CfgList( l ) -> "( " ^ 
                   (List.fold_left (fun x y -> x ^ " " ^ 
                                    (string_of_cfgval y)) " " l) ^ ")"
;;

(*
let _ =
   print_endline "Doing stuff...";
   let a = loadFile "test.cfg" in
   Hashtbl.iter (fun x y -> Printf.printf ": %s = %s\n" x (string_of_cfgval y)) a;
   print_endline "Done!";
;;
*)
