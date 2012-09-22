open Option
(* Date related functions *)

(* Private type for dates, number of days since 1/1/70 *)
type t = int

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

let string_of_gregorian {g_day; g_month; g_year} =
  Printf.sprintf "%d %s %d" g_day (string_of_month g_month) g_year

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

let date_of_gregorian g =
  let {g_day; g_month; g_year} = g in
  if g_year < 1970 then failwith "date_of_gregorian: input before year 1970.";
  if g_day <= 0 || g_day > days_in_month g_year g_month then
    begin
      let msg =
        Printf.sprintf "date_of_gregorian: non existing day %s." (string_of_gregorian g)
      in
      failwith msg
    end;
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
  if d < 0 then failwith "gregorian_of_date: negative input.";
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

let string_of_date d = string_of_gregorian (gregorian_of_date d)

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

let is_weekend d =
  let d7 = d mod 7 in
  d7 == 3 or d7 == 4

let add_days d i = d + i
let days_between d1 d2 = d1 - d2
let init_date = 1

let month_of_int = function
  | 1 -> January
  | 2 -> February
  | 3 -> March
  | 4 -> April
  | 5 -> May
  | 6 -> June
  | 7 -> July
  | 8 -> August
  | 9 -> September
  | 10 -> October
  | 11 -> November
  | 12 -> December
  | _ -> failwith "month_of_int: not a month number."

let int_of_month = function
  | January -> 1
  | February -> 2
  | March -> 3
  | April -> 4
  | May -> 5
  | June -> 6
  | July -> 7
  | August -> 8
  | September -> 9
  | October -> 10
  | November -> 11
  | December -> 12

let ( -- ) d1 i = d1 - i
let ( ++ ) d1 i = d1 - i
let ( -/ ) d1 d2 = d1 - d2
