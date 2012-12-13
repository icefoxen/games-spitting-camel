anim.cmo: 
anim.cmx: 
audio.cmo: /usr/lib/ocaml/sdl/sdlmixer.cmi /usr/lib/ocaml/sdl/sdl.cmi \
    resources.cmi audio.cmi 
audio.cmx: /usr/lib/ocaml/sdl/sdlmixer.cmi /usr/lib/ocaml/sdl/sdl.cmi \
    resources.cmx audio.cmi 
cfglex.cmo: cfgparse.cmi 
cfglex.cmx: cfgparse.cmx 
cfg.cmo: cfgtype.cmi cfgparse.cmi cfglex.cmo cfg.cmi 
cfg.cmx: cfgtype.cmx cfgparse.cmx cfglex.cmx cfg.cmi 
cfgparse.cmo: cfgtype.cmi cfgparse.cmi 
cfgparse.cmx: cfgtype.cmx cfgparse.cmi 
cfgtype.cmo: cfgtype.cmi 
cfgtype.cmx: cfgtype.cmi 
collide.cmo: vector2d.cmi collide.cmi 
collide.cmx: vector2d.cmx collide.cmi 
drawing.cmo: util.cmi /usr/lib/ocaml/sdl/sdlvideo.cmi \
    /usr/lib/ocaml/sdl/sdlgl.cmi /usr/lib/ocaml/lablgl/gluQuadric.cmi \
    /usr/lib/ocaml/lablgl/gluMat.cmi /usr/lib/ocaml/lablgl/glTex.cmi \
    /usr/lib/ocaml/lablgl/glMisc.cmi /usr/lib/ocaml/lablgl/glMat.cmi \
    /usr/lib/ocaml/lablgl/glFunc.cmi /usr/lib/ocaml/lablgl/glDraw.cmi \
    /usr/lib/ocaml/lablgl/glClear.cmi /usr/lib/ocaml/lablgl/gl.cmi \
    drawing.cmi 
drawing.cmx: util.cmx /usr/lib/ocaml/sdl/sdlvideo.cmi \
    /usr/lib/ocaml/sdl/sdlgl.cmi /usr/lib/ocaml/lablgl/gluQuadric.cmx \
    /usr/lib/ocaml/lablgl/gluMat.cmx /usr/lib/ocaml/lablgl/glTex.cmx \
    /usr/lib/ocaml/lablgl/glMisc.cmx /usr/lib/ocaml/lablgl/glMat.cmx \
    /usr/lib/ocaml/lablgl/glFunc.cmx /usr/lib/ocaml/lablgl/glDraw.cmx \
    /usr/lib/ocaml/lablgl/glClear.cmx /usr/lib/ocaml/lablgl/gl.cmx \
    drawing.cmi 
input.cmo: util.cmi /usr/lib/ocaml/sdl/sdlmouse.cmi \
    /usr/lib/ocaml/sdl/sdlkey.cmi /usr/lib/ocaml/sdl/sdlevent.cmi input.cmi 
input.cmx: util.cmx /usr/lib/ocaml/sdl/sdlmouse.cmi \
    /usr/lib/ocaml/sdl/sdlkey.cmi /usr/lib/ocaml/sdl/sdlevent.cmi input.cmi 
loader.cmo: util.cmi /usr/lib/ocaml/sdl/sdlvideo.cmi \
    /usr/lib/ocaml/sdl/sdlttf.cmi /usr/lib/ocaml/sdl/sdlmixer.cmi \
    /usr/lib/ocaml/sdl/sdlloader.cmi /usr/lib/ocaml/sdl/sdlgl.cmi \
    /usr/lib/ocaml/lablgl/raw.cmi /usr/lib/ocaml/lablgl/glTex.cmi \
    /usr/lib/ocaml/lablgl/glPix.cmi /usr/lib/ocaml/lablgl/glMisc.cmi cfg.cmi \
    loader.cmi 
loader.cmx: util.cmx /usr/lib/ocaml/sdl/sdlvideo.cmi \
    /usr/lib/ocaml/sdl/sdlttf.cmi /usr/lib/ocaml/sdl/sdlmixer.cmi \
    /usr/lib/ocaml/sdl/sdlloader.cmi /usr/lib/ocaml/sdl/sdlgl.cmi \
    /usr/lib/ocaml/lablgl/raw.cmx /usr/lib/ocaml/lablgl/glTex.cmx \
    /usr/lib/ocaml/lablgl/glPix.cmx /usr/lib/ocaml/lablgl/glMisc.cmx cfg.cmx \
    loader.cmi 
newdriver.cmo: timer.cmi resources.cmi input.cmi 
newdriver.cmx: timer.cmx resources.cmx input.cmx 
resources.cmo: /usr/lib/ocaml/sdl/sdlttf.cmi /usr/lib/ocaml/sdl/sdlmixer.cmi \
    loader.cmi /usr/lib/ocaml/lablgl/glTex.cmi cfg.cmi resources.cmi 
resources.cmx: /usr/lib/ocaml/sdl/sdlttf.cmi /usr/lib/ocaml/sdl/sdlmixer.cmi \
    loader.cmx /usr/lib/ocaml/lablgl/glTex.cmx cfg.cmx resources.cmi 
spittake.cmo: util.cmi text.cmi /usr/lib/ocaml/sdl/sdlvideo.cmi \
    /usr/lib/ocaml/sdl/sdltimer.cmi /usr/lib/ocaml/sdl/sdlkey.cmi loader.cmi \
    input.cmi drawing.cmi 
spittake.cmx: util.cmx text.cmx /usr/lib/ocaml/sdl/sdlvideo.cmi \
    /usr/lib/ocaml/sdl/sdltimer.cmi /usr/lib/ocaml/sdl/sdlkey.cmi loader.cmx \
    input.cmx drawing.cmx 
text.cmo: /usr/lib/ocaml/sdl/sdlvideo.cmi /usr/lib/ocaml/sdl/sdlttf.cmi \
    loader.cmi text.cmi 
text.cmx: /usr/lib/ocaml/sdl/sdlvideo.cmi /usr/lib/ocaml/sdl/sdlttf.cmi \
    loader.cmx text.cmi 
timer.cmo: timer.cmi 
timer.cmx: timer.cmi 
util.cmo: /usr/lib/ocaml/sdl/sdlwm.cmi /usr/lib/ocaml/sdl/sdlvideo.cmi \
    /usr/lib/ocaml/sdl/sdlttf.cmi /usr/lib/ocaml/sdl/sdl.cmi \
    /usr/lib/ocaml/lablgl/glDraw.cmi /usr/lib/ocaml/lablgl/glClear.cmi \
    /usr/lib/ocaml/lablgl/gl.cmi util.cmi 
util.cmx: /usr/lib/ocaml/sdl/sdlwm.cmi /usr/lib/ocaml/sdl/sdlvideo.cmi \
    /usr/lib/ocaml/sdl/sdlttf.cmi /usr/lib/ocaml/sdl/sdl.cmi \
    /usr/lib/ocaml/lablgl/glDraw.cmx /usr/lib/ocaml/lablgl/glClear.cmx \
    /usr/lib/ocaml/lablgl/gl.cmx util.cmi 
vector2d.cmo: vector2d.cmi 
vector2d.cmx: vector2d.cmi 
audio.cmi: /usr/lib/ocaml/sdl/sdlmixer.cmi 
cfg.cmi: cfgtype.cmi 
cfgparse.cmi: cfgtype.cmi 
cfgtype.cmi: 
collide.cmi: vector2d.cmi 
drawing.cmi: /usr/lib/ocaml/lablgl/glTex.cmi /usr/lib/ocaml/lablgl/glMisc.cmi \
    /usr/lib/ocaml/lablgl/glDraw.cmi /usr/lib/ocaml/lablgl/gl.cmi 
input.cmi: /usr/lib/ocaml/sdl/sdlmouse.cmi /usr/lib/ocaml/sdl/sdlkey.cmi \
    /usr/lib/ocaml/sdl/sdlevent.cmi 
lines.cmi: 
loader.cmi: /usr/lib/ocaml/sdl/sdlvideo.cmi /usr/lib/ocaml/sdl/sdlttf.cmi \
    /usr/lib/ocaml/sdl/sdlmixer.cmi /usr/lib/ocaml/lablgl/raw.cmi \
    /usr/lib/ocaml/lablgl/glTex.cmi cfg.cmi 
resources.cmi: /usr/lib/ocaml/sdl/sdlttf.cmi /usr/lib/ocaml/sdl/sdlmixer.cmi \
    /usr/lib/ocaml/lablgl/glTex.cmi cfg.cmi 
text.cmi: /usr/lib/ocaml/sdl/sdlvideo.cmi /usr/lib/ocaml/sdl/sdlttf.cmi \
    /usr/lib/ocaml/lablgl/glTex.cmi 
timer.cmi: 
util.cmi: 
vector2d.cmi: 
