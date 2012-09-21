module Calendar:
  sig
    type t
    val union: t list -> t
    val empty: t
    val of_string: string -> t
  end

val is_business_day: Date.t -> Calendar.t -> bool

type date_shift_type =
  | DS_Days
  | DS_BusinessDays
  | DS_Weeks
  | DS_Months
  | DS_Years

type date_rolling =
  | DR_Actual
  | DR_Following
  | DR_ModifiedFollowing
  | DR_Previous
  | DR_ModifiedPrevious

val adjust_date: Date.t -> Calendar.t -> date_rolling -> Date.t

type date_shift = {
  ds_number: int;
  ds_type: date_shift_type;
  ds_calendar: Calendar.t;
  ds_date_rolling: date_rolling;
}

type adjust = {
  a_rdate: t;
  a_calendar: Calendar.t;
  a_date_rolling: date_rolling;
}
and t =
  | Date of Date.t
  | Adjust of adjust
  | Shift of t * date_shift


val eval: t -> Date.t
