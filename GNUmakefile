ocamlopt := ocamlopt
ocamlc := ocamlc
ocamldoc := ocamldoc
ocamldep := ocamldep
ocamllex := ocamllex
ocamlyacc := ocamlyacc

obj_bases := util cfgtype cfglex cfgparse cfg timer vector2d collide audio input loader resources drawing text
byte_objs := $(addsuffix .cmo,$(obj_bases))
native_objs := $(addsuffix .cmx,$(obj_bases))
obj_intfs := $(addsuffix .cmi,$(obj_bases))

lib_bases := str unix nums bigarray \
		sdl sdlloader sdlttf sdlmixer \
		lablgl lablglut
byte_libs := $(addsuffix .cma,$(lib_bases))
native_libs := $(addsuffix .cmxa,$(lib_bases))

ocamlflags := -I `ocamlfind query sdl` -I +lablgl
ocamlcf = $(ocamlc) $(ocamlflags)
ocamloptf = $(ocamlopt) $(ocamlflags)

mainlib_base := spittingcamel
byte_mainlib := $(mainlib_base).cma
native_mainlib := $(mainlib_base).cmxa

test_program := spittake
byte_test := $(test_program)
native_test := $(test_program).opt

byte_test_objs := $(addsuffix .cmo, $(test_program))
native_test_objs := $(addsuffix .cmx, $(test_program))

cmo_rule = $(ocamlcf) -c -o $@ $<
cmx_rule = $(ocamloptf) -c -o $@ $<
cmi_rule = $(ocamlcf) -c -o $@ $<
cma_rule = $(ocamlcf) -a -o $@ $(1)
cmxa_rule = $(ocamloptf) -a -o $@ $(1)
byte_exec_rule = $(ocamlcf) -o $@ $(byte_libs) $(1)
native_exec_rule = $(ocamloptf) -o $@ $(native_libs) $(1)
ocamldep_rule = $(ocamldep) $(ocamlflags) $(1) > $@ || (rm -f $@; false)

all: byte native doc
byte: $(byte_mainlib) $(byte_test)
native: $(native_mainlib) $(native_test)

depend.mk: $(wildcard *.ml *.mli); $(call ocamldep_rule,$^)
include depend.mk

$(byte_mainlib): $(byte_objs); $(call cma_rule,$(byte_objs))
$(native_mainlib): $(native_objs); $(call cmxa_rule,$(native_objs))
# BUGGO: Add %.cmi to the %.cmo and %.cmx deps when all interface files exist.
%.cmo: %.ml; $(cmo_rule)
%.cmx: %.ml; $(cmx_rule)
%.cmi: %.mli; $(cmi_rule)
$(byte_test): %: $(byte_mainlib) %.ml; $(call byte_exec_rule,$^)
$(native_test): %.opt: $(native_mainlib) %.ml; $(call native_exec_rule,$^)

clean:
	-rm -f -- $(obj_intfs)
	-rm -f -- $(byte_objs) $(native_objs)
	-rm -f -- $(byte_mainlib) $(native_mainlib)
	-rm -f -- $(byte_test) $(native_test)
	-rm -f -- $(byte_test_objs) $(native_test_objs)
	-rm -f -- depend.mk
	-rm -f -- *.o *.cmi *.cmo
	-rm -f -- *~
	-rm -f -- *.a

doc: $(wildcard *.mli); $(ocamldoc) $(ocamlflags) -html -d doc $^

.PHONY: all byte native clean doc
