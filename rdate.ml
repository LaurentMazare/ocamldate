module DateSet = Set.Make( 
  struct
    let compare = Pervasives.compare
        type t = Date.t
  end )

module Calendar =
  struct
    type t =
      | C_Empty
      | C_WeekEnds
      | C_Explicit of DateSet.t
      | C_Union of t list

    let union l = C_Union l
    let empty = C_Empty
  end

open Calendar
let rec in_calendar d = function
  | C_Empty -> false
  | C_WeekEnds -> Date.is_weekend d
  | C_Explicit l -> DateSet.mem d l
  | C_Union cals ->
      List.fold_left
      (fun acc cal -> acc || in_calendar d cal)
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

let eval = function
  | Date d -> d
  | _ -> failwith "Todo"
