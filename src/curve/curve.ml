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
      if right - left <= 1 then (
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
  | E_linear of float

type t = {
  c_data: (float, float) curve_data;
  c_interpolation: interpolation;
  c_left: extrapolation;
  c_right: extrapolation;
}

let mk_curve ?(inter = I_none) ?(l_extr = E_none) ?(r_extr = E_none) data_list =
  {
    c_data = curve_data_of_list data_list;
    c_interpolation = inter;
    c_left = l_extr;
    c_right = r_extr;
  }

(* In this function, we assume that x is between x_array.(0)
   * and x_array.(n-1). and x_array is not empty. *)
let linear_interpolation (x_array, y_array) x =
  let rec aux left right =
    if right - left <= 1 then (
      if x == x_array.(left) then y_array.(left)
      else if x == x_array.(right) then y_array.(right)
      else
        let c =
          (x -. x_array.(left)) /. (x_array.(right) -. x_array.(left))
        in
        y_array.(left) +. c *. (y_array.(right) -. y_array.(left))
    )
    else
      let mid = (left + right) / 2 in
      let x_mid = x_array.(mid) in
      if x < x_mid then aux left mid else aux mid right
  in
  aux 0 (Array.length x_array - 1)


let eval {c_data; c_interpolation; c_left; c_right} x =
  let x_array, y_array = c_data in
  let x_length = Array.length x_array in
  if x_length = 0 then
    failwith "Curve.eval: empty curve data.";
  if x < x_array.(0) then
    match c_left with
    | E_none -> failwith "Curve.eval: no left extrapolation."
    | E_constant -> y_array.(0)
    | E_linear slope -> y_array.(0) +. slope *. (x_array.(0) -. x)
  else if x > x_array.(x_length - 1) then
    match c_right with
    | E_none -> failwith "Curve.eval: no left extrapolation."
    | E_constant -> y_array.(x_length-1)
    | E_linear slope ->
        y_array.(x_length-1) +. slope *. (x -. x_array.(x_length-1))
  else
    match c_interpolation with
    | I_none -> data_of_curve c_data x
    | I_linear -> linear_interpolation c_data x

