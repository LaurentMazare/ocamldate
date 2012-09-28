type t
val add_seconds: t -> int -> t
val add_minutes: t -> int -> t
val add_hours: t -> int -> t
val add_days: t -> int -> t
val date_of_t: t -> Date.t
val t_of_date: Date.t -> t

type dt = {
  dt_year: int;
  dt_month: Date.month;
  dt_day: int;
  dt_hour: int;
  dt_minute: int;
  dt_second: int;
}

val dt_is_valid: dt -> bool
val dt_of_t: t -> dt
val t_of_dt: dt -> t
