open Date
let nb_test = ref 0
let assert_ cond str =
  let status = if cond then "\x1b[1;32;mOK" else "\x1b[1;31;mFAILED" in
  nb_test := !nb_test + 1;
  Format.printf "%-3d %s: %s\n" !nb_test str status;
  assert cond

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
    assert_ (wd == week_day) (string_of_date (date_of_gregorian d))
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
  assert_ (aux (365 * 10)) "Fixpoint test"

let _ =
  let tests = [
    (17, September, 2012, "17sep12");
    (16, January, 1980, "16Jan80");
    (26, May, 1987, "26MAY87");
    (17, September, 2012, "17sep2012");
    (16, January, 1980, "16Jan1980");
    (26, May, 1987, "26MAY1987");
  ]
  in
  let check (g_day, g_month, g_year, str) =
    let d = date_of_gregorian {g_day; g_month; g_year} in
    let d' = date_of_string str in
    assert_ (d == d') str
  in
  List.iter check tests
