type t = {
  t_date: Date.t;
  t_seconds: int;
}

let seconds_per_day = 24 * 3600

let add_seconds {t_date; t_seconds} nb_seconds =
  let t_seconds = t_seconds + nb_seconds in
  let nb_days = t_seconds / seconds_per_day in
  let t_seconds = t_seconds mod seconds_per_day in
  {t_date = Date.add_days t_date nb_days; t_seconds}

let add_minutes t nb_minutes =
  add_seconds t (nb_minutes * 60)

let add_hours t nb_hours =
  add_seconds t (nb_hours * 3600)

let add_days {t_date; t_seconds} nb_days =
  let t_date = Date.add_days t_date nb_days in
  {t_date; t_seconds}

let date_of_t {t_date} = t_date
let t_of_date t_date = {t_date; t_seconds = 0}

type dt = {
  dt_year: int;
  dt_month: Date.month;
  dt_day: int;
  dt_hour: int;
  dt_minute: int;
  dt_second: int;
}

let dt_is_valid {dt_year; dt_month; dt_day; dt_hour; dt_minute; dt_second} =
  dt_year >= 1970 &&
  dt_year <= 2500 &&
  dt_hour >= 0 &&
  dt_hour <= 23 &&
  dt_minute >= 0 &&
  dt_minute <= 59 &&
  dt_second >= 0 &&
  dt_second <= 59 &&
  dt_day >= 1 &&
  dt_day <= Date.days_in_month dt_year dt_month

let t_of_dt {dt_year; dt_month; dt_day; dt_hour; dt_minute; dt_second} =
  let t_seconds = dt_second + 60 * dt_minute + 3600 * dt_hour in
  let greg = {Date.g_day = dt_day; g_month = dt_month; g_year = dt_year} in
  let t_date = Date.date_of_gregorian greg in
  {t_date; t_seconds}

let dt_of_t {t_date; t_seconds} =
  let {Date.g_day; g_month; g_year} = Date.gregorian_of_date t_date in
  let dt_year = g_year and dt_month = g_month and dt_day = g_day in
  let dt_second = t_seconds mod 60 in
  let t_minutes = t_seconds / 60 in
  let dt_minute = t_minutes mod 60 in
  let dt_hour = dt_minute / 60 in 
  {dt_year; dt_month; dt_day; dt_hour; dt_minute; dt_second}
