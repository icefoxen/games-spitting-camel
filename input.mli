exception InputError of string
type 'a inputContext = {
  pressCallbacks : (Sdlkey.t * (Sdlevent.keyboard_event -> 'a -> 'a)) list;
  holdCallbacks : (Sdlkey.t * ('a -> 'a)) list;
  moveCallbacks : (Sdlevent.mousemotion_event -> 'a -> 'a) list;
  clickCallbacks :
    (Sdlmouse.button * (Sdlevent.mousebutton_event -> 'a -> 'a)) list;
  quitCallbacks : ('a -> 'a) list;
  keystate : Sdlkey.t list;
}
val createContext : unit -> 'a inputContext
val clearInputstate : 'a inputContext -> 'a inputContext
val bindButtonPress :
  'a inputContext ->
  Sdlkey.t -> (Sdlevent.keyboard_event -> 'a -> 'a) -> 'a inputContext
val bindButtonHold :
  'a inputContext -> Sdlkey.t -> ('a -> 'a) -> 'a inputContext
val bindMouseMove :
  'a inputContext ->
  (Sdlevent.mousemotion_event -> 'a -> 'a) -> 'a inputContext
val bindMouseClick :
  'a inputContext ->
  Sdlmouse.button ->
  (Sdlevent.mousebutton_event -> 'a -> 'a) -> 'a inputContext
val bindMouseDrag : 'a -> 'b -> 'c -> unit
val bindQuit : 'a inputContext -> ('a -> 'a) -> 'a inputContext
val bindMany : ('a -> 'b -> 'c -> 'a) -> 'a -> ('b * 'c) list -> 'a
val isKeyPressed : 'a inputContext -> Sdlkey.t -> bool
val doHoldCallbacks : 'a inputContext -> 'a -> 'a
val doPressCallbacks : Sdlevent.keyboard_event -> 'a inputContext -> 'a -> 'a
val doMoveCallbacks :
  Sdlevent.mousemotion_event -> 'a inputContext -> 'a -> 'a
val doClickCallbacks :
  Sdlevent.mousebutton_event -> 'a inputContext -> 'a -> 'a
val doQuitCallbacks : 'a inputContext -> 'a -> 'a
val doInput : 'a inputContext -> 'a -> 'a inputContext * 'a
val string_of_key : Sdlkey.t -> string
val key_of_string : string -> Sdlkey.t
val string_of_keystate : Sdlevent.keyboard_event -> string
