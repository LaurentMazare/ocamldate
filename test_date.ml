open Date
(* Tests are stored here for now. Todo: move them to regtest. *)
let _ =
  let d = {g_day = 17; g_month = September; g_year = 2012} in
  Format.printf "%s\n" (string_of_week_day (week_day_of_date
  (date_of_gregorian d)));
  Format.printf "%s\n" (string_of_date (date_of_gregorian d))

let _ =
  let rec aux nb_tests =
    if nb_tests == 0 then
      true
    else
      let d = add_days init_date (10 * nb_tests) in
      let g = gregorian_of_date d in
      let d' = date_of_gregorian g in
      if d != d' then false else aux (nb_tests - 1)
  in
  Format.printf "Fixpoint test: %s\n" (if aux (365 * 10) then "OK" else "FAILED")
