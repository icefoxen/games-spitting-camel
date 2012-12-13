(** audio.ml
   Basic sound and music handling, integrated with the resources system.
      
   Calling (Audio.initSound channelnum) is necessary before anything else.
*)

open Resources;;

let channelnum = ref 0;;

(** Initializes the sound system
 * @param n Number of channels.
 *)
let initSound n =
  Sdl.init_subsystem [`AUDIO];
  Sdlmixer.open_audio ();
  channelnum := Sdlmixer.allocate_channels n;
;;

(** Plays a sound until it is over, then stops.
 * A number of simultanious sounds can be played up to the number of channels
 * allocated.  If there are no free channels, it does nothing.
 *) 
let playSound pool n = 
  if Sdlmixer.num_playing_channel () < !channelnum then 
    Sdlmixer.play_sound n;
;;

(** Plays a song forever.  Only one song is played at a time.
   SDL_mixer uses a different channel for music than sound,
   so this is not orthogonal with sound.
*)
let playMusic n =
  if Sdlmixer.playing_music () then (
    Sdlmixer.fadeout_music 2.0;
  );
  let mus = Sdlmixer.load_music n in
    Gc.finalise Sdlmixer.free_music mus;
    Sdlmixer.play_music ~loops: (-1) mus
;;
