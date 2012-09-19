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

type date_shift = {
  ds_number: int;
  ds_type: date_shift_type;
  ds_calendar: Calendar.t;
}

type t =
  | Date of Date.t
  | Adjust of t * Calendar.t
  | Shift of t * date_shift

(* Todo: implement this in an optimized way         *)
(* as the current version is *really* *really* slow *)
let add_business_days d ds_number cal =
  if ds_number < 0 then failwith "Negative number of days.";
  let rec adjust d =
    if is_business_day d cal then d
    else adjust (Date.add_days d 1)
  in
  let rec aux n d =
    if n == 0 then adjust d
    else aux (n-1) (adjust (Date.add_days d 1))
  in
  aux ds_number d

(* Todo: roll convention + implement *)
let add_months d _ _ = d

let rec eval = function
  | Date d -> d
  | Adjust (d, cal) ->
      let d = eval d in
      add_business_days d 0 cal
  | Shift (d, {ds_number; ds_type; ds_calendar}) ->
      let d = eval d in
      match ds_type with
      | DS_Days -> Date.add_days d ds_number
      | DS_BusinessDays -> add_business_days d ds_number ds_calendar
      | DS_Weeks ->
          let d = Date.add_days d (7 * ds_number) in
          add_business_days d 0 ds_calendar
      | DS_Months -> add_months d ds_number ds_calendar
      | DS_Years -> add_months d (12 * ds_number) ds_calendar
