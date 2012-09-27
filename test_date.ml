open Date
open Day_count_convention

let nb_test = ref 0
let assert_ cond str =
  let status = if cond then "\x1b[1;32;mOK" else "\x1b[1;31;mFAILED" in
  nb_test := !nb_test + 1;
  Format.printf "%-3d %s: %s\n" !nb_test str status;
  assert cond

(* Week of day regtests *)
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
    assert_ (wd = week_day) (string_of_date (date_of_gregorian d))
  in
  List.iter check tests

(* Fix point regtests *)
let _ =
  let rec aux nb_tests =
    if nb_tests = 0 then
      true
    else
      let d = add_days init_date (10 * nb_tests) in
      let g = gregorian_of_date d in
      let d' = date_of_gregorian g in
      if d != d' then false else aux (nb_tests - 1)
  in
  assert_ (aux (365 * 10)) "Fixpoint test"

(* Parsing regtests *)
let _ =
  let tests = [
    (17, September, 2012, "17sep12");
    (16, January, 1980, "16Jan80");
    (26, May, 1987, "26MAY87");
    (17, September, 2012, "17sep2012");
    (16, January, 1980, "16January1980");
    (26, May, 1987, "26MAY1987");
  ]
  in
  let check (g_day, g_month, g_year, str) =
    let d = date_of_gregorian {g_day; g_month; g_year} in
    let d' = date_of_string str in
    assert_ (d = Option.extract d') str
  in
  List.iter check tests

(* DCF regtests, based on ISDA examples *)

let _ =
  let tests = [
    ("15Jan07", "30Jan07", 15.0000, 15.0000, 15.0000, 15.0000);
    ("15Jan07", "15Feb07", 30.0000, 30.0000, 30.0000, 31.0000);
    ("15Jan07", "15Jul07", 180.0000, 180.0000, 180.0000, 181.0000);
    ("30Sep07", "31Mar08", 180.0000, 180.0000, 180.0000, 183.0000);
    ("30Sep07", "31Oct07", 30.0000, 30.0000, 30.0000, 31.0000);
    ("30Sep07", "30Sep08", 360.0000, 360.0000, 360.0000, 366.0000);
    ("15Jan07", "31Jan07", 16.0000, 15.0000, 15.0000, 16.0000);
    ("31Jan07", "28Feb07", 28.0000, 28.0000, 30.0000, 28.0000);
    ("28Feb07", "31Mar07", 33.0000, 32.0000, 30.0000, 31.0000);
    ("31Aug06", "28Feb07", 178.0000, 178.0000, 180.0000, 181.0000);
    ("28Feb07", "31Aug07", 183.0000, 182.0000, 180.0000, 184.0000);
    ("14Feb07", "28Feb07", 14.0000, 14.0000, 16.0000, 14.0000);
    ("26Feb07", "29Feb08", 363.0000, 363.0000, 364.0000, 368.0000);
    ("29Feb08", "28Feb09", 359.0000, 359.0000, 360.0000, 365.0000);   (* Modified 30E/360 Isda 358 -> 360 *)
    ("29Feb08", "30Mar08", 31.0000, 31.0000, 30.0000, 30.0000);
    ("29Feb08", "31Mar08", 32.0000, 31.0000, 30.0000, 31.0000);
    ("28Feb07", "5Mar07 ", 7.0000, 7.0000, 5.0000, 5.0000);
    ("31Oct07", "28Nov07", 28.0000, 28.0000, 28.0000, 28.0000);
    ("31Aug07", "29Feb08", 179.0000, 179.0000, 180.0000, 182.0000);
    ("29Feb08", "31Aug08", 182.0000, 181.0000, 180.0000, 184.0000);
    ("31Aug08", "28Feb09", 178.0000, 178.0000, 180.0000, 181.0000);  (* Modified 30E/360 Isda 178 -> 180 *)
    ("28Feb09", "31Aug09", 183.0000, 182.0000, 180.0000, 184.0000);
  ]
  in
  let check (str_date1, str_date2, dcf30_360, dcf30e_360, dcf30e_360_isda, dcf_act360) =
    let date1 = Option.extract (date_of_string str_date1) in
    let date2 = Option.extract (date_of_string str_date2) in
    let check_one dcf_type conv d =
      let v = dcf conv date1 date2 in
      let d = d /. 360. in
      let msg = Format.sprintf "DCF %s: %.4f vs %.4f (%s %s)" dcf_type v d str_date1 str_date2 in
      assert_ (abs_float(v -. d) < 1e-10) msg
    in
    check_one "Act/360" D_Act_360 dcf_act360;
    check_one "30/360" D_30_360 dcf30_360;
    check_one "30E/360" D_30E_360 dcf30e_360;
    check_one "30E/360 ISDA" D_30E_360_ISDA dcf30e_360_isda
  in
  List.iter check tests
