open Date
(* Tests are stored here for now. Todo: move them to regtest. *)
let _ =
  let tests = [
    (17, September, 2012, Monday);
    (16, January, 1980, Wednesday);
    (26, May, 1987, Tuesday);
  ]
  in
  let check (g_day, g_month, g_year, week_day) =
    let d = {g_day; g_month; g_year} in
    let wd = week_day_of_date (date_of_gregorian d) in
    let ok = if wd == week_day then "OK" else "FAILED" in
    Format.printf "%s %s\n" (string_of_date (date_of_gregorian d)) ok
  in
  List.iter check tests

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
