type ('a, 'b) curve_data
val curve_data_of_list: ('a * 'b) list -> ('a, 'b) curve_data
val list_of_curve_data: ('a, 'b) curve_data -> ('a * 'b) list
val data_in_curve: ('a, 'b) curve_data -> 'a -> bool
val data_of_curve: ('a, 'b) curve_data -> 'a -> 'b

type interpolation =
  | I_none
  | I_linear

type extrapolation =
  | E_none
  | E_constant
  | E_linear of float

type t = {
  c_data: (float, float) curve_data;
  c_interpolation: interpolation;
  c_left: extrapolation;
  c_right: extrapolation;
}

val mk_curve:
  ?inter: interpolation ->
    ?l_extr: extrapolation ->
      ?r_extr: extrapolation ->
        (float * float) list -> t

val eval: t -> float -> float
