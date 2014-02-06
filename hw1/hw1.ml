let rec elem x b =
  match b with
  | y::b -> if x == y then true else elem x b
  | []   -> false
;;

let rec subset a b =
  match a with
  | x::a  -> if elem x b then subset a b else false
  | []    -> true
;;

let equal_sets a b =
  if subset a b then subset b a else false
;;

let proper_subset a b =
  if equal_sets a b then false else subset a b
;;

let rec set_diff a b =
  match a with
  | x::a -> if elem x b then set_diff a b else x::(set_diff a b)
  | []   -> []
;;

let rec computed_fixed_point eq f x =
  if eq x (f x) then true else computed_fixed_point eq f (f x)
;;

let rec compound_self f p x =
  if p == 0 then x else compound_self f (p-1) (f x)
;;

let rec computed_periodic_point eq f p x = 
  if eq x (compound_self f p x) then true else computed_periodic_point eq f p (f x)
;;

type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal
;;

let rec get_nonterminals = function
  | [] -> []
  | (N n)::st -> n::(get_nonterminals st)
  | (T t)::st -> get_nonterminals st
;;
  

let rec get_rules s rules =
  match rules with
  |[] -> []
  |(n, rhs)::rt -> if n == s then (n, rhs)::(get_rules s rt)
                 else get_rules s rt
;;

let rec filter_symbols s rules =
  match s with
  (* This case should never happen *)
  | []    -> []

  (* return the list of all terminating rules that start with this symbol *)
  | n::[] ->
    (
      match (get_rules n rules) with
      | []    -> []
      | r::rt -> 
        (filter_symbols [n] (set_diff rules [r]))@
        (
          match r with (n, rhs) -> 
            match (get_nonterminals rhs) with
            | [] -> [r]
            | rhs -> filter_symbols rhs (set_diff rules [r])
        )
    )

  (* check that the entire list can terminate and return a list of the terminating rules for each symbol *)
  | n::nt ->
    match (filter_symbols [n] rules) with
    | [] -> []
    | nr -> 
      match (filter_symbols nt rules) with
      | [] -> []
      | ntr -> nr@ntr
;;

let filter_blind_alleys (s, rules) =
  (s, set_diff rules (set_diff rules (filter_symbols [s] rules)))
;;
