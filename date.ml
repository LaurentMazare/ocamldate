open Option
(* Date related functions *)

(* Private type for dates, number of days since 1/1/70 *)
type date = int

type week_day =
  | Monday
  | Tuesday
  | Wednesday
  | Thursday
  | Friday
  | Saturday
  | Sunday

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

let string_of_week_day = function
  | Monday -> "Monday"
  | Tuesday -> "Tuesday"
  | Wednesday -> "Wednesday"
  | Thursday -> "Thursday"
  | Friday -> "Friday"
  | Saturday -> "Saturday"
  | Sunday -> "Sunday"

let string_of_month = function
  | January -> "January"
  | February -> "February"
  | March -> "March"
  | April -> "April"
  | May -> "May"
  | June -> "June"
  | July -> "July"
  | August -> "August"
  | September -> "September"
  | October -> "October"
  | November -> "November"
  | December -> "December"

type gregorian = {
  g_day: int;
  g_month: month;
  g_year: int;
}

let is_leap_year y =
  y mod 400 == 0 || (y mod 4 == 0 && y mod 100 != 0)

let months = [
  January;
  February;
  March;
  April;
  May;
  June;
  July;
  August;
  September;
  October;
  November;
  December;
]

let days_in_month y = function
  | January -> 31
  | February -> if is_leap_year y then 29 else 28
  | March -> 31
  | April -> 30
  | May -> 31
  | June -> 30
  | July -> 31
  | August -> 31
  | September -> 30
  | October -> 31
  | November -> 30
  | December -> 31

let days_in_year y =
  if is_leap_year y then 366 else 365

let date_of_gregorian {g_day; g_month; g_year} =
  if g_year < 1970 then failwith "date_of_gregorian: input before year 1970.";
  let rec aux_year y acc =
    if y == g_year then acc
    else aux_year (y+1) (acc + days_in_year y)
  in
  let d_year = aux_year 1970 0 in
  let _, d_month =
    List.fold_left
    (fun (acc_done, acc_days) month ->
      if acc_done then (acc_done, acc_days)
      else if month == g_month then (true, acc_days)
      else (false, acc_days + days_in_month g_year month)
    )
    (false, 0)
    months
  in
  d_month + d_year + g_day

let gregorian_of_date d =
  let rec aux_year y d =
    if d <= days_in_year y then y, d
    else aux_year (y+1) (d - days_in_year y)
  in
  let g_year, day = aux_year 1970 d in
  let g_month, g_day =
    List.fold_left
    (fun (acc_month, acc_day) month ->
        match acc_month with
        | Some _ -> (acc_month, acc_day)
        | None ->
            let days_in_month = days_in_month g_year month in
            if acc_day <= days_in_month then (Some month, acc_day)
            else (None, acc_day - days_in_month)
    )
    (None, day)
    months
  in
  let g_month = Option.extract g_month in
  {g_day = g_day; g_month = g_month; g_year = g_year}

let week_day_of_date d =
  match d mod 7 with
  | 1 -> Thursday
  | 2 -> Friday
  | 3 -> Saturday
  | 4 -> Sunday
  | 5 -> Monday
  | 6 -> Tuesday
  | 0 -> Wednesday
  | _ -> failwith "Not a correct day in day_of_week"

let string_of_date d =
  let {g_day; g_month; g_year} = gregorian_of_date d in
  Printf.sprintf "%d %s %d" g_day (string_of_month g_month) g_year

(* Tests are stored here for now. Todo: move them to regtest. *)
let _ =
  let d = {g_day = 17; g_month = September; g_year = 2012} in
  Format.printf "%s\n" (string_of_week_day (week_day_of_date
  (date_of_gregorian d)));
  Format.printf "%s\n" (string_of_date (date_of_gregorian d))
