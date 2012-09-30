type 'a option =
  | Some of 'a
  | None

let extract = function
  | Some x -> x
  | None -> failwith "Option.extract on None!"
