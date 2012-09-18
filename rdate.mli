module Calendar:
  sig
    type t
    val union: t list -> t
    val empty: t
  end

val is_business_day: Date.t -> Calendar.t -> bool

type date_shift_type =
  | DS_Days
  | DS_BusinessDays
  | DS_Weeks
  | DS_Months
  | DS_Years

type date_shift = {
  ds_number: int;
  ds_type: date_shift_type;
  ds_calendar: Calendar.t;
}

type t =
  | Date of Date.t
  | Adjust of t * Calendar.t
  | Shift of t * date_shift

val eval: t -> Date.t
