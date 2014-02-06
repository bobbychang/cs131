(* DNA fragment analyzer.  *)

type nucleotide = A | C | G | T
type fragment = nucleotide list
type acceptor = fragment -> fragment option
type matcher = fragment -> acceptor -> fragment option

type pattern =
  | Frag of fragment
  | List of pattern list
  | Or of pattern list
  | Junk of int
  | Closure of pattern

let match_empty frag accept = accept frag

let match_nothing frag accept = None

let rec match_junk k frag accept =
  match accept frag with
    | None ->
        (if k = 0
         then None
         else match frag with
           | [] -> None
           | _::tail -> match_junk (k - 1) tail accept)
    | ok -> ok

let rec match_star matcher frag accept =
  match accept frag with
    | None ->
      matcher frag
        (fun frag1 ->
          if frag == frag1
	  then None
          else match_star matcher frag1 accept)
    | ok -> ok

let match_nucleotide nt frag accept =
  match frag with
    | [] -> None
    | n::tail -> if n == nt then accept tail else None

let append_matchers matcher1 matcher2 frag accept =
  matcher1 frag (fun frag1 -> matcher2 frag1 accept)

let make_appended_matchers make_a_matcher ls =
  let rec mams = function
    | [] -> match_empty
    | head::tail -> append_matchers (make_a_matcher head) (mams tail)
  in mams ls

let rec make_or_matcher make_a_matcher = function
  | [] -> match_nothing
  | head::tail ->
    let head_matcher = make_a_matcher head
    and tail_matcher = make_or_matcher make_a_matcher tail
    in fun frag accept ->
      let ormatch = head_matcher frag accept
      in match ormatch with
        | None -> tail_matcher frag accept
        | _ -> ormatch

let rec make_matcher = function
  | Frag frag -> make_appended_matchers match_nucleotide frag
  | List pats -> make_appended_matchers make_matcher pats
  | Or pats -> make_or_matcher make_matcher pats
  | Junk k -> match_junk k
  | Closure pat -> match_star (make_matcher pat)

(*
type nucleotide = A | C | G | T
type fragment = nucleotide list
type acceptor = fragment -> fragment option
type matcher = fragment -> acceptor -> fragment option
type pattern =
    Frag of fragment
  | List of pattern list
  | Or of pattern list
  | Junk of int
  | Closure of pattern
val match_empty : 'a -> ('a -> 'b) -> 'b = <fun>
val match_nothing : 'a -> 'b -> 'c option = <fun>
val match_junk : int -> 'a list -> ('a list -> 'b option) -> 'b option = <fun>
val match_star :
  ('a -> ('a -> 'b option) -> 'b option) ->
  'a -> ('a -> 'b option) -> 'b option = <fun>
val match_nucleotide : 'a -> 'a list -> ('a list -> 'b option) -> 'b option = <fun>
val append_matchers :
  ('a -> ('b -> 'c) -> 'd) -> ('b -> 'e -> 'c) -> 'a -> 'e -> 'd = <fun>
val make_appended_matchers :
  ('a -> 'b -> ('b -> 'c) -> 'c) -> 'a list -> 'b -> ('b -> 'c) -> 'c = <fun>
val make_or_matcher :
  ('a -> 'b -> 'c -> 'd option) -> 'a list -> 'b -> 'c -> 'd option = <fun>
val make_matcher :
  pattern -> nucleotide list -> (nucleotide list -> 'a option) -> 'a option = <fun>

Trace 
1. make_matcher Frag [A;B]
let rec make_matcher = function
  | Frag frag -> make_appended_matchers match_nucleotide frag 
  | List pats -> make_appended_matchers make_matcher pats
  | Or pats -> make_or_matcher make_matcher pats
  | Junk k -> match_junk k
  | Closure pat -> match_star (make_matcher pat);;

2. make_appended_matchers match_nucleotide [A;B]
let make_appended_matchers make_a_matcher ls =
  let rec mams = function
    | [] -> match_empty
    | head::tail -> append_matchers (make_a_matcher head) (mams tail)
  in mams ls;;

match_nucleotide A

*)
