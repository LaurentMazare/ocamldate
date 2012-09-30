open Date

let act_365 d1 d2 = float_of_int (d2 -/ d1) /. 365.0
let act_360 d1 d2 = float_of_int (d2 -/ d1) /. 360.0
let days_of_year y = if is_leap_year y then 366.0 else 365.0

let act_act d1 d2 =
  let g1 = gregorian_of_date d1 in
  let g2 = gregorian_of_date d2 in
  if g1.g_year = g2.g_year then
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

let gen_30_360 y1 y2 m1 m2 d1 d2 =
  let nb_years = y2 - y1 in
  let nb_months = int_of_month m2 - int_of_month m1 in
  let dcf_day = float_of_int (d2 - d1) /. 360. in
  float_of_int nb_years +. float_of_int nb_months /. 12. +. dcf_day

let d_30_360 d1 d2 =
  let g1 = gregorian_of_date d1 in
  let g2 = gregorian_of_date d2 in
  let day1 = if g1.g_day = 31 then 30 else g1.g_day in
  let day2 = if g2.g_day = 31 && day1 = 30 then 30 else g2.g_day in
  gen_30_360 g1.g_year g2.g_year g1.g_month g2.g_month day1 day2

let d_30e_360 d1 d2 =
  let g1 = gregorian_of_date d1 in
  let g2 = gregorian_of_date d2 in
  let day1 = if g1.g_day = 31 then 30 else g1.g_day in
  let day2 = if g2.g_day = 31 then 30 else g2.g_day in
  gen_30_360 g1.g_year g2.g_year g1.g_month g2.g_month day1 day2

let d_30e_360_isda d1 d2 =
  let g1 = gregorian_of_date d1 in
  let g2 = gregorian_of_date d2 in
  let m1 = days_in_month g1.g_year g1.g_month in
  let m2 = days_in_month g2.g_year g2.g_month in
  let day1 = if g1.g_day = m1 then 30 else g1.g_day in
  let day2 = if g2.g_day = m2 then 30 else g2.g_day in
  gen_30_360 g1.g_year g2.g_year g1.g_month g2.g_month day1 day2

type t =
  | D_Act_365
  | D_Act_360
  | D_Act_Act
  | D_30_360
  | D_30E_360
  | D_30E_360_ISDA
  | D_1_1_ISDA

let dcf = function
  | D_Act_365 -> act_365
  | D_Act_360 -> act_360
  | D_Act_Act -> act_act
  | D_30_360 -> d_30_360
  | D_30E_360 -> d_30e_360
  | D_30E_360_ISDA -> d_30e_360_isda
  | D_1_1_ISDA -> fun _ _ -> 1.0
