(* input.ml
   Manages input, a la the keyboard and mouse.
   You should be able to register callbacks for buttonpress and buttonhold.
   Also mouse move, mouse button, mouse button+drag.
   Also has functions to aid in loading key definitions.

   We do not have unbind functions: Create a different context for different
   roles.

   NOTE: Another thing that must be initialized before use!

   XXX: To do: Mouse drag
*)

open Sdlkey;;
open Sdlevent;;
open Bigarray;;
open Util;;

exception InputError of string

type 'a inputContext = {
    pressCallbacks : (Sdlkey.t * (Sdlevent.keyboard_event -> 'a -> 'a)) list;
    holdCallbacks : (Sdlkey.t * ('a -> 'a)) list;

    moveCallbacks : (Sdlevent.mousemotion_event -> 'a -> 'a) list;
    clickCallbacks : (Sdlmouse.button * (Sdlevent.mousebutton_event -> 'a -> 'a)) list;
    quitCallbacks : (('a -> 'a) list);
(*    dragCallbacks : (Sdlkey.t * (unit -> unit)) list; *)


    keystate : Sdlkey.t list;
  };;


let createContext () = {
    pressCallbacks = [];
    holdCallbacks = [];
    moveCallbacks = [];
    clickCallbacks = [];
    quitCallbacks = [];
    keystate = [];
  };;

let clearInputstate ic = {
   ic with keystate = [];
};;

(* Callback will be called only when the button is first pressed *)
let bindButtonPress context button callback =
  {context with pressCallbacks = (button, callback) :: context.pressCallbacks }
;;

(* Callback will be called as long as the button is held *)
let bindButtonHold context button callback =
  {context with holdCallbacks = (button, callback) :: context.holdCallbacks }
;;

let bindMouseMove context callback =
  {context with moveCallbacks = callback :: context.moveCallbacks}
;;

let bindMouseClick context button callback =
  {context with clickCallbacks = (button, callback) :: context.clickCallbacks}
;;

let bindMouseDrag context button callback =
  ()
;;

let bindQuit context callback =
   {context with quitCallbacks = callback :: context.quitCallbacks}
;;

let bindMany f lst context =
  List.fold_left (fun ctxt (key,callback) -> f ctxt key callback) lst context
;;


(* Helper funcs *)
let isKeyPressed ctxt key =
    List.mem key ctxt.keystate
;;

let doHoldCallbacks ctxt state =
  List.fold_left
    (fun state (key,func) -> if isKeyPressed ctxt key then func state else state)
    state ctxt.holdCallbacks
;;

let doPressCallbacks event ctxt state =
  List.fold_left
    (fun state (key,func) -> if key = event.keysym then func event state else state)
    state ctxt.pressCallbacks
;;

let doMoveCallbacks event ctxt state =
  List.fold_left (fun state f -> f event state) state ctxt.moveCallbacks;
;;

let doClickCallbacks event ctxt state =
  let pressButton state (b,f) =
     if b = event.mbe_button then f event state else state
  in
  List.fold_left pressButton state ctxt.clickCallbacks;
;;

let doQuitCallbacks ctxt state = 
  List.fold_left (fun state f -> f state) state ctxt.quitCallbacks;
;;


let doInput context state =
  Sdlevent.pump ();
  let process context state =
    match Sdlevent.poll () with
	Some( KEYDOWN( e ) ) ->
	  let ctxt = {context with keystate = e.keysym :: context.keystate} in
          let ns = doPressCallbacks e ctxt state in
	    (ctxt, ns)
      | Some( KEYUP( e ) ) ->
            let ctxt = {context with keystate = List.filter ((<>) e.keysym)
            context.keystate} in
            (ctxt, state)
      | Some( MOUSEBUTTONDOWN( e ) ) ->
            let ns = doClickCallbacks e context state in
            (context, ns)
      | Some( MOUSEMOTION( e ) ) ->
            let ns = doMoveCallbacks e context state in
            (context, ns)
      | Some( QUIT ) ->
            let ns = doQuitCallbacks context state in
            (context, ns)
      | _ -> (context, state)
  in
  let (ctxt,state) = process context state in
  let ns = doHoldCallbacks ctxt state in
  (ctxt, ns)
;;


(* I love Python.  It helps me build things like these.
   Of course, if this were Lisp I could just write a macro, buuut...  
   Actually, I REALLY want more reflective data types for OCaml.
   Anyway.  These are mainly here to help tranlate to and from
   config files.  *)
let string_of_key = function
    KEY_UNKNOWN -> "KEY_UNKNOWN"
  | KEY_BACKSPACE -> "KEY_BACKSPACE"
  | KEY_TAB -> "KEY_TAB"
  | KEY_CLEAR -> "KEY_CLEAR"
  | KEY_RETURN -> "KEY_RETURN"
  | KEY_PAUSE -> "KEY_PAUSE"
  | KEY_ESCAPE -> "KEY_ESCAPE"
  | KEY_SPACE -> "KEY_SPACE"
  | KEY_EXCLAIM -> "KEY_EXCLAIM"
  | KEY_QUOTEDBL -> "KEY_QUOTEDBL"
  | KEY_HASH -> "KEY_HASH"
  | KEY_DOLLAR -> "KEY_DOLLAR"
  | KEY_AMPERSAND -> "KEY_AMPERSAND"
  | KEY_QUOTE -> "KEY_QUOTE"
  | KEY_LEFTPAREN -> "KEY_LEFTPAREN"
  | KEY_RIGHTPAREN -> "KEY_RIGHTPAREN"
  | KEY_ASTERISK -> "KEY_ASTERISK"
  | KEY_PLUS -> "KEY_PLUS"
  | KEY_COMMA -> "KEY_COMMA"
  | KEY_MINUS -> "KEY_MINUS"
  | KEY_PERIOD -> "KEY_PERIOD"
  | KEY_SLASH -> "KEY_SLASH"
  | KEY_0 -> "KEY_0"
  | KEY_1 -> "KEY_1"
  | KEY_2 -> "KEY_2"
  | KEY_3 -> "KEY_3"
  | KEY_4 -> "KEY_4"
  | KEY_5 -> "KEY_5"
  | KEY_6 -> "KEY_6"
  | KEY_7 -> "KEY_7"
  | KEY_8 -> "KEY_8"
  | KEY_9 -> "KEY_9"
  | KEY_COLON -> "KEY_COLON"
  | KEY_SEMICOLON -> "KEY_SEMICOLON"
  | KEY_LESS -> "KEY_LESS"
  | KEY_EQUALS -> "KEY_EQUALS"
  | KEY_GREATER -> "KEY_GREATER"
  | KEY_QUESTION -> "KEY_QUESTION"
  | KEY_AT -> "KEY_AT"
  | KEY_LEFTBRACKET -> "KEY_LEFTBRACKET"
  | KEY_BACKSLASH -> "KEY_BACKSLASH"
  | KEY_RIGHTBRACKET -> "KEY_RIGHTBRACKET"
  | KEY_CARET -> "KEY_CARET"
  | KEY_UNDERSCORE -> "KEY_UNDERSCORE"
  | KEY_BACKQUOTE -> "KEY_BACKQUOTE"
  | KEY_a -> "KEY_a"
  | KEY_b -> "KEY_b"
  | KEY_c -> "KEY_c"
  | KEY_d -> "KEY_d"
  | KEY_e -> "KEY_e"
  | KEY_f -> "KEY_f"
  | KEY_g -> "KEY_g"
  | KEY_h -> "KEY_h"
  | KEY_i -> "KEY_i"
  | KEY_j -> "KEY_j"
  | KEY_k -> "KEY_k"
  | KEY_l -> "KEY_l"
  | KEY_m -> "KEY_m"
  | KEY_n -> "KEY_n"
  | KEY_o -> "KEY_o"
  | KEY_p -> "KEY_p"
  | KEY_q -> "KEY_q"
  | KEY_r -> "KEY_r"
  | KEY_s -> "KEY_s"
  | KEY_t -> "KEY_t"
  | KEY_u -> "KEY_u"
  | KEY_v -> "KEY_v"
  | KEY_w -> "KEY_w"
  | KEY_x -> "KEY_x"
  | KEY_y -> "KEY_y"
  | KEY_z -> "KEY_z"
  | KEY_DELETE -> "KEY_DELETE"
  | KEY_KP0 -> "KEY_KP0"
  | KEY_KP1 -> "KEY_KP1"
  | KEY_KP2 -> "KEY_KP2"
  | KEY_KP3 -> "KEY_KP3"
  | KEY_KP4 -> "KEY_KP4"
  | KEY_KP5 -> "KEY_KP5"
  | KEY_KP6 -> "KEY_KP6"
  | KEY_KP7 -> "KEY_KP7"
  | KEY_KP8 -> "KEY_KP8"
  | KEY_KP9 -> "KEY_KP9"
  | KEY_KP_PERIOD -> "KEY_KP_PERIOD"
  | KEY_KP_DIVIDE -> "KEY_KP_DIVIDE"
  | KEY_KP_MULTIPLY -> "KEY_KP_MULTIPLY"
  | KEY_KP_MINUS -> "KEY_KP_MINUS"
  | KEY_KP_PLUS -> "KEY_KP_PLUS"
  | KEY_KP_ENTER -> "KEY_KP_ENTER"
  | KEY_KP_EQUALS -> "KEY_KP_EQUALS"
  | KEY_UP -> "KEY_UP"
  | KEY_DOWN -> "KEY_DOWN"
  | KEY_RIGHT -> "KEY_RIGHT"
  | KEY_LEFT -> "KEY_LEFT"
  | KEY_INSERT -> "KEY_INSERT"
  | KEY_HOME -> "KEY_HOME"
  | KEY_END -> "KEY_END"
  | KEY_PAGEUP -> "KEY_PAGEUP"
  | KEY_PAGEDOWN -> "KEY_PAGEDOWN"
  | KEY_F1 -> "KEY_F1"
  | KEY_F2 -> "KEY_F2"
  | KEY_F3 -> "KEY_F3"
  | KEY_F4 -> "KEY_F4"
  | KEY_F5 -> "KEY_F5"
  | KEY_F6 -> "KEY_F6"
  | KEY_F7 -> "KEY_F7"
  | KEY_F8 -> "KEY_F8"
  | KEY_F9 -> "KEY_F9"
  | KEY_F10 -> "KEY_F10"
  | KEY_F11 -> "KEY_F11"
  | KEY_F12 -> "KEY_F12"
  | KEY_F13 -> "KEY_F13"
  | KEY_F14 -> "KEY_F14"
  | KEY_F15 -> "KEY_F15"
  | KEY_NUMLOCK -> "KEY_NUMLOCK"
  | KEY_CAPSLOCK -> "KEY_CAPSLOCK"
  | KEY_SCROLLOCK -> "KEY_SCROLLOCK"
  | KEY_RSHIFT -> "KEY_RSHIFT"
  | KEY_LSHIFT -> "KEY_LSHIFT"
  | KEY_RCTRL -> "KEY_RCTRL"
  | KEY_LCTRL -> "KEY_LCTRL"
  | KEY_RALT -> "KEY_RALT"
  | KEY_LALT -> "KEY_LALT"
  | KEY_RMETA -> "KEY_RMETA"
  | KEY_LMETA -> "KEY_LMETA"
  | KEY_LSUPER -> "KEY_LSUPER"
  | KEY_RSUPER -> "KEY_RSUPER"
  | KEY_MODE -> "KEY_MODE"
  | KEY_COMPOSE -> "KEY_COMPOSE"
  | KEY_HELP -> "KEY_HELP"
  | KEY_PRINT -> "KEY_PRINT"
  | KEY_SYSREQ -> "KEY_SYSREQ"
  | KEY_BREAK -> "KEY_BREAK"
  | _ -> raise (InputError "string_of_key: Invalid key; some keys aren't supported.  Easy to fix if you want.")
;;

let key_of_string = function
    "KEY_UNKNOWN" -> KEY_UNKNOWN
  | "KEY_BACKSPACE" -> KEY_BACKSPACE
  | "KEY_TAB" -> KEY_TAB
  | "KEY_CLEAR" -> KEY_CLEAR
  | "KEY_RETURN" -> KEY_RETURN
  | "KEY_PAUSE" -> KEY_PAUSE
  | "KEY_ESCAPE" -> KEY_ESCAPE
  | "KEY_SPACE" -> KEY_SPACE
  | "KEY_EXCLAIM" -> KEY_EXCLAIM
  | "KEY_QUOTEDBL" -> KEY_QUOTEDBL
  | "KEY_HASH" -> KEY_HASH
  | "KEY_DOLLAR" -> KEY_DOLLAR
  | "KEY_AMPERSAND" -> KEY_AMPERSAND
  | "KEY_QUOTE" -> KEY_QUOTE
  | "KEY_LEFTPAREN" -> KEY_LEFTPAREN
  | "KEY_RIGHTPAREN" -> KEY_RIGHTPAREN
  | "KEY_ASTERISK" -> KEY_ASTERISK
  | "KEY_PLUS" -> KEY_PLUS
  | "KEY_COMMA" -> KEY_COMMA
  | "KEY_MINUS" -> KEY_MINUS
  | "KEY_PERIOD" -> KEY_PERIOD
  | "KEY_SLASH" -> KEY_SLASH
  | "KEY_0" -> KEY_0
  | "KEY_1" -> KEY_1
  | "KEY_2" -> KEY_2
  | "KEY_3" -> KEY_3
  | "KEY_4" -> KEY_4
  | "KEY_5" -> KEY_5
  | "KEY_6" -> KEY_6
  | "KEY_7" -> KEY_7
  | "KEY_8" -> KEY_8
  | "KEY_9" -> KEY_9
  | "KEY_COLON" -> KEY_COLON
  | "KEY_SEMICOLON" -> KEY_SEMICOLON
  | "KEY_LESS" -> KEY_LESS
  | "KEY_EQUALS" -> KEY_EQUALS
  | "KEY_GREATER" -> KEY_GREATER
  | "KEY_QUESTION" -> KEY_QUESTION
  | "KEY_AT" -> KEY_AT
  | "KEY_LEFTBRACKET" -> KEY_LEFTBRACKET
  | "KEY_BACKSLASH" -> KEY_BACKSLASH
  | "KEY_RIGHTBRACKET" -> KEY_RIGHTBRACKET
  | "KEY_CARET" -> KEY_CARET
  | "KEY_UNDERSCORE" -> KEY_UNDERSCORE
  | "KEY_BACKQUOTE" -> KEY_BACKQUOTE
  | "KEY_a" -> KEY_a
  | "KEY_b" -> KEY_b
  | "KEY_c" -> KEY_c
  | "KEY_d" -> KEY_d
  | "KEY_e" -> KEY_e
  | "KEY_f" -> KEY_f
  | "KEY_g" -> KEY_g
  | "KEY_h" -> KEY_h
  | "KEY_i" -> KEY_i
  | "KEY_j" -> KEY_j
  | "KEY_k" -> KEY_k
  | "KEY_l" -> KEY_l
  | "KEY_m" -> KEY_m
  | "KEY_n" -> KEY_n
  | "KEY_o" -> KEY_o
  | "KEY_p" -> KEY_p
  | "KEY_q" -> KEY_q
  | "KEY_r" -> KEY_r
  | "KEY_s" -> KEY_s
  | "KEY_t" -> KEY_t
  | "KEY_u" -> KEY_u
  | "KEY_v" -> KEY_v
  | "KEY_w" -> KEY_w
  | "KEY_x" -> KEY_x
  | "KEY_y" -> KEY_y
  | "KEY_z" -> KEY_z
  | "KEY_DELETE" -> KEY_DELETE
  | "KEY_KP0" -> KEY_KP0
  | "KEY_KP1" -> KEY_KP1
  | "KEY_KP2" -> KEY_KP2
  | "KEY_KP3" -> KEY_KP3
  | "KEY_KP4" -> KEY_KP4
  | "KEY_KP5" -> KEY_KP5
  | "KEY_KP6" -> KEY_KP6
  | "KEY_KP7" -> KEY_KP7
  | "KEY_KP8" -> KEY_KP8
  | "KEY_KP9" -> KEY_KP9
  | "KEY_KP_PERIOD" -> KEY_KP_PERIOD
  | "KEY_KP_DIVIDE" -> KEY_KP_DIVIDE
  | "KEY_KP_MULTIPLY" -> KEY_KP_MULTIPLY
  | "KEY_KP_MINUS" -> KEY_KP_MINUS
  | "KEY_KP_PLUS" -> KEY_KP_PLUS
  | "KEY_KP_ENTER" -> KEY_KP_ENTER
  | "KEY_KP_EQUALS" -> KEY_KP_EQUALS
  | "KEY_UP" -> KEY_UP
  | "KEY_DOWN" -> KEY_DOWN
  | "KEY_RIGHT" -> KEY_RIGHT
  | "KEY_LEFT" -> KEY_LEFT
  | "KEY_INSERT" -> KEY_INSERT
  | "KEY_HOME" -> KEY_HOME
  | "KEY_END" -> KEY_END
  | "KEY_PAGEUP" -> KEY_PAGEUP
  | "KEY_PAGEDOWN" -> KEY_PAGEDOWN
  | "KEY_F1" -> KEY_F1
  | "KEY_F2" -> KEY_F2
  | "KEY_F3" -> KEY_F3
  | "KEY_F4" -> KEY_F4
  | "KEY_F5" -> KEY_F5
  | "KEY_F6" -> KEY_F6
  | "KEY_F7" -> KEY_F7
  | "KEY_F8" -> KEY_F8
  | "KEY_F9" -> KEY_F9
  | "KEY_F10" -> KEY_F10
  | "KEY_F11" -> KEY_F11
  | "KEY_F12" -> KEY_F12
  | "KEY_F13" -> KEY_F13
  | "KEY_F14" -> KEY_F14
  | "KEY_F15" -> KEY_F15
  | "KEY_NUMLOCK" -> KEY_NUMLOCK
  | "KEY_CAPSLOCK" -> KEY_CAPSLOCK
  | "KEY_SCROLLOCK" -> KEY_SCROLLOCK
  | "KEY_RSHIFT" -> KEY_RSHIFT
  | "KEY_LSHIFT" -> KEY_LSHIFT
  | "KEY_RCTRL" -> KEY_RCTRL
  | "KEY_LCTRL" -> KEY_LCTRL
  | "KEY_RALT" -> KEY_RALT
  | "KEY_LALT" -> KEY_LALT
  | "KEY_RMETA" -> KEY_RMETA
  | "KEY_LMETA" -> KEY_LMETA
  | "KEY_LSUPER" -> KEY_LSUPER
  | "KEY_RSUPER" -> KEY_RSUPER
  | "KEY_MODE" -> KEY_MODE
  | "KEY_COMPOSE" -> KEY_COMPOSE
  | "KEY_HELP" -> KEY_HELP
  | "KEY_PRINT" -> KEY_PRINT
  | "KEY_SYSREQ" -> KEY_SYSREQ
  | "KEY_BREAK" -> KEY_BREAK
  | x -> raise (InputError ("key_of_string: Undefined key:" ^ x))
;;


let string_of_keystate k =
  let p = match k.ke_state with
      PRESSED -> "pressed" | RELEASED -> "released"
  in
    Printf.sprintf "Which: %d, State: %s, Key: %s, code: %c"
      k.ke_which p (string_of_key k.keysym) k.keycode
;;
