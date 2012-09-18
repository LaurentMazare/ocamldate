(* Generic date functions *)
type t
val init_date: t
val add_days: t -> int -> t
val string_of_date: t -> string
val days_between: t -> t -> int

(* Week Day functions *)
type week_day =
  | Monday
  | Tuesday
  | Wednesday
  | Thursday
  | Friday
  | Saturday
  | Sunday

val week_day_of_date: t -> week_day
val string_of_week_day: week_day -> string
val is_weekend: t -> bool

(* Gregorian functions *)
type month =
  | January
  | February
  | March
  | April
  | May
  | June
  | July
  | August
  | September
  | October
  | November
  | December


type gregorian = {
  g_day: int;
  g_month: month;
  g_year: int;
}

val date_of_gregorian: gregorian -> t
val gregorian_of_date: t -> gregorian
