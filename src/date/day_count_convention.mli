val act_365: Date.t -> Date.t -> float
val act_360: Date.t -> Date.t -> float
val act_act: Date.t -> Date.t -> float

type t =
  | D_Act_365
  | D_Act_360
  | D_Act_Act
  | D_30_360
  | D_30E_360
  | D_30E_360_ISDA
  | D_1_1_ISDA

val dcf: t -> Date.t -> Date.t -> float
