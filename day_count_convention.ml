open Date

let act_365 d1 d2 = float_of_int (d1 -/ d2) /. 365.0
let act_360 d1 d2 = float_of_int (d1 -/ d2) /. 360.0
let days_of_year y = if is_leap_year y then 366.0 else 365.0

let act_act d1 d2 =
  let g1 = gregorian_of_date d1 in
  let g2 = gregorian_of_date d2 in
  if g1.g_year == g2.g_year then
    float_of_int (d1 -/ d2) /. days_of_year g1.g_year
  else
    let dcf_start {g_year; g_month; g_day} d =
      let start = {g_year; g_month = January; g_day = 1} in
      let start_d = date_of_gregorian start in
      float_of_int (d -/ start_d) /. days_of_year g_year
    in
    let dcf1 = dcf_start g1 d1 in
    let dcf2 = dcf_start g2 d2 in
    float_of_int (g1.g_year - g2.g_year) +. dcf1 -. dcf2

type t =
  | D_Act_365
  | D_Act_360
  | D_Act_Act
  | D_30_360
  | D_30E_360
  | D_30E_360_ISDA

let dcf = function
  | D_Act_365 -> act_365
  | D_Act_360 -> act_360
  | D_Act_Act -> act_act
  | _ -> failwith "Day_count_convention.dcf: not supported for now."
