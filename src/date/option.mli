type 'a option =
  | Some of 'a
  | None

val extract: 'a option -> 'a
