(*Mute OCAML's warning for unused values*)
[@@@ocaml.warning "-32"]

(* Modular exponentiation using Z *)
let mod_exp (base : Z.t) (exp : Z.t) (m : Z.t) : Z.t =
  let rec aux base exp acc =
    if Z.equal exp Z.zero then acc
    else if Z.equal (Z.rem exp (Z.of_int 2)) Z.one then
      aux (Z.rem (Z.mul base base) m) (Z.div exp (Z.of_int 2))
        (Z.rem (Z.mul acc base) m)
    else
      aux (Z.rem (Z.mul base base) m) (Z.div exp (Z.of_int 2)) acc
  in
  aux base exp Z.one

(* Decompose n - 1 into 2^s * d, s is an int *)
let decompose (n : Z.t) : (int * Z.t) =
  let rec aux s d =
    if Z.equal (Z.rem d (Z.of_int 2)) Z.zero then
      aux (s + 1) (Z.div d (Z.of_int 2))
    else
      (s, d)
  in
  aux 0 (Z.pred n)

(* Miller-Rabin primality test using Z *)
let is_probable_prime (n : Z.t) (k : int) : bool =
  if Z.lt n (Z.of_int 2) then false
  else if Z.equal n (Z.of_int 2) || Z.equal n (Z.of_int 3) then true
  else if Z.equal (Z.rem n (Z.of_int 2)) Z.zero then false
  else
    let (s, d) = decompose n in
    let test a =
      let x = mod_exp a d n in
      if Z.equal x Z.one || Z.equal x (Z.pred n) then true
      else
        let rec check_round i x =
          if i = 0 then false
          else
            let x = Z.rem (Z.mul x x) n in
            if Z.equal x (Z.pred n) then true
            else check_round (i - 1) x
        in
        check_round (s - 1) x
    in
    let rec aux i =
      if i = 0 then true
      else
        let a =
          Z.add (Z.of_int 2) (Z.of_int64 (Random.int64 (Z.to_int64 (Z.sub n (Z.of_int 3)))))
        in
        if test a then aux (i - 1) else false
    in
    aux k

(* Pollard's rho algorithm using Z *)
let g (x : Z.t) (c : Z.t) (n : Z.t) : Z.t =
  Z.rem (Z.add (Z.mul x x) c) n

let rec gcd (a : Z.t) (b : Z.t) : Z.t =
  if Z.equal b Z.zero then Z.abs a else gcd b (Z.rem a b)

type sequence = Sequence of Z.t * sequence Lazy.t

let rec make_sequence x c n =
  let next_x = g x c n in
  Sequence (next_x, lazy (make_sequence next_x c n))

let pollards_rho (n : Z.t) : Z.t option =
  if Z.leq n Z.one then None
  else if Z.equal (Z.rem n (Z.of_int 2)) Z.zero then Some (Z.of_int 2)
  else
    let rec try_factorization () =
      let x0 = Z.of_int 2 in  (* Can be randomized *)
      let c = Z.add Z.one (Z.of_int64 (Random.int64 1000L)) in  (* Random c *)
      let tortoise_seq = make_sequence x0 c n in
      let hare_seq =
        match tortoise_seq with
        | Sequence (_, lazy tortoise_next) -> tortoise_next
      in
      let rec find_factor tortoise_seq hare_seq =
        match (tortoise_seq, hare_seq) with
        | Sequence (tortoise, lazy tortoise_next),
          Sequence (hare, lazy (Sequence (_, lazy hare_next_next))) ->
            let d = gcd (Z.abs (Z.sub tortoise hare)) n in
            if Z.gt d Z.one && Z.lt d n then Some d
            else find_factor tortoise_next hare_next_next
      in
      match find_factor tortoise_seq hare_seq with
      | Some factor -> Some factor
      | None -> try_factorization ()
    in
    try_factorization ()

(* Function to find all factors using Z *)
let factors (n : Z.t) : (Z.t * int) list =
  let rec factor n =
    if Z.equal n Z.one then []
    else if is_probable_prime n 10 then [n]
    else
      match pollards_rho n with
      | None -> [n]
      | Some d ->
          factor d @ factor (Z.div n d)
  in
  let prime_factors = factor n in
  let sorted_factors = List.sort Z.compare prime_factors in
  let rec group lst =
    match lst with
    | [] -> []
    | h :: t ->
        let count, rest =
          List.fold_left
            (fun (c, acc) x ->
              if Z.equal x h then (c + 1, acc)
              else (c, x :: acc))
            (1, []) t
        in
        (h, count) :: group (List.rev rest)
  in
  group sorted_factors

let factors_naive (n : Z.t) =
  let rec aux (d : Z.t) (n : Z.t) =
    if Z.equal n Z.one then []
    else if Z.equal (Z.rem n d) Z.zero then
      match aux d (Z.div n d) with
      | (h, count) :: t when Z.equal h d ->
          (h, count + 1) :: t
      | l -> (d, 1) :: l
    else aux (Z.succ d) n
  in
  aux (Z.of_int 2) n

let () =
  let n = Z.of_string "1112196922131321323" in
  let factorization = factors n in
  Printf.printf "Factors of %s:\n" (Z.to_string n);
  List.iter (fun (factor, count) ->
      Printf.printf "%s^%d\n" (Z.to_string factor) count) factorization 



(* CODE TO BENCHMARK
open Core
open Core_bench

(* Benchmarking the factors_naive function for integers 1-8 *)
let benchmarks =
  List.concat_map (List.init 8 ~f:(fun i -> Z.of_int (i + 1))) ~f:(fun i ->
    [
      Bench.Test.create ~name:(Printf.sprintf "factors_naive %d" (Z.to_int i)) (fun () ->
          ignore (factors_naive i));
      Bench.Test.create ~name:(Printf.sprintf "factors %d" (Z.to_int i)) (fun () ->
          ignore (factors i))
    ])

let () =
  Command_unix.run (Bench.make_command benchmarks)
  *)