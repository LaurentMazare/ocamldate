RESULT = test_date
DATE_SOURCES = option.mli option.ml date.mli date.ml \
					day_count_convention.mli day_count_convention.ml\
					date_time.mli date_time.ml\
					rdate.mli rdate.ml
REGTESTS_SOURCES = test_date.ml
CURVE_SOURCES = curve.mli curve.ml\
								dated_curve.mli dated_curve.ml

SOURCES = $(addprefix src/date/, $(DATE_SOURCES))
SOURCES += $(addprefix src/regtests/, $(REGTESTS_SOURCES))
SOURCES += $(addprefix src/curve/, $(CURVE_SOURCES))

OCAMLMAKEFILE = OCamlMakefile
include $(OCAMLMAKEFILE)
