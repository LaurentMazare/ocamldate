type ('a, 'b) curve_data = 'a array * 'b array

let curve_data_of_list data_list =
  let x_list, y_list = List.split (List.sort compare data_list) in
  let x_array = Array.of_list x_list in
  let y_array = Array.of_list y_list in
  x_array, y_array

let list_of_curve_data (x_array, y_array) =
  List.combine (Array.to_list x_array) (Array.to_list y_array)

let option_of_curve (x_array, y_array) x =
  let x_length = Array.length x_array in
  if x_length == 0 || x < x_array.(0) || x > x_array.(x_length-1) then
    None
  else
    let rec aux left right = (* Tail-rec bisection search *)
      if right - left = 1 then (
        if x == x_array.(left) then Some y_array.(left)
        else if x == x_array.(right) then Some y_array.(right)
        else None
      )
      else
        let mid = (left + right) / 2 in
        let x_mid = x_array.(mid) in
        if x < x_mid then aux left mid else aux mid right
    in
    aux 0 (x_length - 1)

let data_in_curve cd x =
  match option_of_curve cd x with
  | None -> false
  | Some _ -> true

let data_of_curve cd x =
  match option_of_curve cd x with
  | None -> failwith "Cannot find point in curve."
  | Some y -> y

type interpolation =
  | I_none
  | I_linear

type extrapolation =
  | E_none
  | E_constant

type 'a float_curve = {
  c_data: ('a, float) curve_data;
  c_interpolation: interpolation;
  c_left: extrapolation;
  c_right: extrapolation;
  c_diff: 'a -> 'a -> float
}

type t = float float_curve

let mk_curve ?(inter = I_none) ?(l_extr = E_none) ?(r_extr = E_none) data_list =
  {
    c_data = curve_data_of_list data_list;
    c_interpolation = inter;
    c_left = l_extr;
    c_right = r_extr;
    c_diff = fun x y -> y -. x
  }

let eval curve x = x (* todo *)
