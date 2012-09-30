module DateSet = Set.Make( 
  struct
    let compare = Pervasives.compare
        type t = Date.t
  end)

module Calendar =
  struct
    type _t =
      | C_WeekEnds
      | C_Explicit of DateSet.t

    type t = _t list

    let union l = List.flatten l
    let empty = []
    let of_string _ = []
  end

open Calendar
let in_calendar d cals =
  List.fold_left
  (fun acc cal ->
    if acc then true
    else
      match cal with
      | C_WeekEnds -> Date.is_weekend d
      | C_Explicit set -> DateSet.mem d set
  )
  false
  cals

let is_business_day d cal = not (in_calendar d cal)

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

let adjust_date date cal date_rolling =
  let rec adjust direction d =
    if is_business_day d cal then d
    else adjust direction (Date.add_days d direction)
  in
  match date_rolling with
  | DR_Actual -> date
  | DR_Following -> adjust 1 date
  | DR_ModifiedFollowing ->
      let {Date.g_month} = Date.gregorian_of_date date in
      let ndate = adjust 1 date in
      let {Date.g_month = new_month} = Date.gregorian_of_date ndate in
      if new_month == g_month then
        ndate
      else
        adjust (-1) date
  | DR_Previous -> adjust (-1) date
  | DR_ModifiedPrevious ->
      let {Date.g_month} = Date.gregorian_of_date date in
      let ndate = adjust (-1) date in
      let {Date.g_month = new_month} = Date.gregorian_of_date ndate in
      if new_month == g_month then
        ndate
      else
        adjust 1 date

(* Todo: implement this in an optimized way         *)
(* as the current version is *really* *really* slow *)
let add_business_days d ds_number cal =
  let direction = if ds_number >= 0 then 1 else -1 in
  let rec adjust d =
    if is_business_day d cal then d
    else adjust (Date.add_days d direction)
  in
  let rec aux n d =
    if n == 0 then adjust d
    else aux (n-1) (adjust (Date.add_days d 1))
  in
  aux ds_number d

let adjust_gregorian {Date.g_day; g_month; g_year} cal date_rolling =
  let dim = Date.days_in_month g_year g_month in
  let g_day = if g_day <= dim then g_day else dim in
  let date = Date.date_of_gregorian {Date.g_day; g_month; g_year} in
  adjust_date date cal date_rolling

let add_months d nb_months cal date_rolling =
  let {Date.g_day; g_month; g_year} = Date.gregorian_of_date d in
  let g_month = Date.int_of_month g_month + nb_months in
  let g_year = g_year + g_month / 12 in
  let g_month = Date.month_of_int (g_month mod 12) in
  adjust_gregorian {Date.g_day; g_month; g_year} cal date_rolling

let rec eval = function
  | Date d -> d
  | Adjust {a_rdate; a_calendar; a_date_rolling} ->
      let d = eval a_rdate in
      adjust_date d a_calendar a_date_rolling
  | Shift (d, {ds_number; ds_type; ds_calendar; ds_date_rolling}) ->
      let d = eval d in
      match ds_type with
      | DS_Days ->
          let d = Date.add_days d ds_number in
          adjust_date d ds_calendar ds_date_rolling
      | DS_BusinessDays ->
          if ds_date_rolling != DR_Actual then
            failwith "RDate.eval: only DR_Actual can be used with DS_BusinessDays.";
          add_business_days d ds_number ds_calendar
      | DS_Weeks ->
          let d = Date.add_days d (7 * ds_number) in
          adjust_date d ds_calendar ds_date_rolling
      | DS_Months ->
          add_months d ds_number ds_calendar ds_date_rolling
      | DS_Years ->
          add_months d (12 * ds_number) ds_calendar ds_date_rolling
