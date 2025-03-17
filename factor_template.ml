(*Mute OCAML's warning for unused values*)
[@@@ocaml.warning "-32"]

(*Mute several of OCAML's warnings for when functions are not yet implemented so that dune can build. This should be removed if template code is to be implemented.*)
[@@@ocaml.warning "-27"]
[@@@ocaml.warning "-24"]
[@@@ocaml.warning "-39"]

let factors_naive (n : Z.t) =
  (* TODO: Implement naive factorization *)
  []  

(* Pollard's rho algorithm using Z *)
let g (x : Z.t) (c : Z.t) (n : Z.t) : Z.t =
  (* TODO: Implement function g for Pollard's rho *)
  Z.zero  

let rec gcd (a : Z.t) (b : Z.t) : Z.t =
  (* TODO: Implement Euclidean algorithm for gcd *)
  Z.zero  

type sequence = Sequence of Z.t * sequence Lazy.t

let rec make_sequence x c n =
  (* TODO: Generate sequence for Pollard's rho *)
  Sequence (Z.zero, lazy (make_sequence x c n))  

let pollards_rho (n : Z.t) : Z.t option =
  (* TODO: Implement Pollard's rho algorithm *)
  None  

(* Modular exponentiation using Z *)
let mod_exp (base : Z.t) (exp : Z.t) (m : Z.t) : Z.t =
  (* TODO: Implement modular exponentiation *)
  Z.zero  

(* Decompose n - 1 into 2^s * d, s is an int *)
let decompose (n : Z.t) : (int * Z.t) =
  (* TODO: Decompose n - 1 into 2^s * d *)
  (0, Z.zero)  

(* Miller-Rabin primality test using Z *)
let is_probable_prime (n : Z.t) (k : int) : bool =
  (* TODO: Implement Miller-Rabin primality test *)
  false  

(* Function to find all factors using Z *)
let factors (n : Z.t) : (Z.t * int) list =
  (* TODO: Factorize n using Pollard's rho and Miller-Rabin *)
  []  


let () =
  let n = Z.of_string "43905803181212312312" in
  let factorization = factors_naive n in
  Printf.printf "Factors of %s:\n" (Z.to_string n);
  List.iter (fun (factor, count) ->
      Printf.printf "%s^%d\n" (Z.to_string factor) count) factorization
