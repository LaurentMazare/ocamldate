(* Generic date functions *)
type t
val init_date: t
val add_days: t -> int -> t
val days_between: t -> t -> int
val date_of_string: string -> t Option.option
val string_of_date: t -> string

(* Infix operators *)
val ( ++ ): t -> int -> t (* Add days *)
val ( -- ): t -> int -> t (* Substract days *)
val ( -/ ): t -> t -> int (* Days between *)

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

val month_of_int: int -> month
val int_of_month: month -> int
val days_in_month: int -> month -> int
val is_leap_year: int -> bool

type gregorian = {
  g_day: int;
  g_month: month;
  g_year: int;
}

val date_of_gregorian: gregorian -> t
val gregorian_of_date: t -> gregorian
