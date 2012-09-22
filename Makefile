RESULT = test_date
SOURCES = option.mli option.ml date.mli date.ml \
					day_count_convention.mli day_count_convention.ml\
					rdate.mli rdate.ml test_date.ml
OCAMLMAKEFILE = OCamlMakefile
include $(OCAMLMAKEFILE)
