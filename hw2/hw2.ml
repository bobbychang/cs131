(* hw2.ml *)

(* PART 1 *)

type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

let rec get_alternatives n = function
  | [] -> []
  | (nonterm, rhs)::ruletail ->
    if nonterm == n then rhs::(get_alternatives n ruletail)
    else get_alternatives n ruletail

let make_prod rules =
  fun n ->
    get_alternatives n rules

let convert_grammar = function
  | (s, r) -> (s, make_prod r)

(* PART 2 *)

let match_nothing deriv accept frag =
  None

let match_empty deriv accept frag =
  accept deriv frag

let make_terminal_matcher term =
  fun prod deriv accept frag ->
    match frag with
    | [] -> None
    | head::tail -> if head = term then accept deriv tail else None

let append_matchers matcher1 matcher2 =
  fun prod deriv accept frag ->
    matcher1 prod deriv (fun deriv1 frag1 -> matcher2 prod deriv1 accept frag1) frag

let iterate_matchers rule matcher1 matcher2 =
  fun prod deriv accept frag ->
    match (matcher1 prod (deriv@[rule]) accept frag) with
    | None -> matcher2 prod deriv accept frag
    | Some x -> Some x

let rec make_nonterm_matcher nonterm alts =
  fun prod deriv accept frag ->
    match alts with
    | [] -> match_nothing deriv accept frag
    | headalt::tailalts ->
      let matcher = iterate_matchers (nonterm, headalt) (make_rhs_matcher headalt) (make_nonterm_matcher nonterm tailalts)
      in matcher prod deriv accept frag

and make_rhs_matcher alt =
  fun prod deriv accept frag ->
    match alt with
    | [] -> match_empty deriv accept frag
    | (T headsym)::tailsyms ->
      let matcher = append_matchers (make_terminal_matcher headsym) (make_rhs_matcher tailsyms)
      in matcher prod deriv accept frag
    | (N headsym)::tailsyms ->
      let matcher = append_matchers (make_nonterm_matcher headsym (prod headsym)) (make_rhs_matcher tailsyms)
      in matcher prod deriv accept frag

let parse_prefix = function
  | (start, production) ->
    fun accept frag ->
      (make_nonterm_matcher start (production start)) production [] accept frag