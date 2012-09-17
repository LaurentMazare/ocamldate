type date

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


type gregorian = {
  g_day: int;
  g_month: month;
  g_year: int;
}

val date_of_gregorian: gregorian -> date
val gregorian_of_date: date -> gregorian
val week_day_of_date: date -> week_day
val string_of_date: date -> string
