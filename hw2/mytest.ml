(* hw2test.ml *)
(* PART 1 *)
type awksub_nonterminals = Expr | Lvalue | Incrop | Binop | Num

let awksub_rules =
   [Expr, [T"("; N Expr; T")"];
    Expr, [N Num];
    Expr, [N Expr; N Binop; N Expr];
    Expr, [N Lvalue];
    Expr, [N Incrop; N Lvalue];
    Expr, [N Lvalue; N Incrop];
    Lvalue, [T"$"; N Expr];
    Incrop, [T"++"];
    Incrop, [T"--"];
    Binop, [T"+"];
    Binop, [T"-"];
    Num, [T"0"];
    Num, [T"1"];
    Num, [T"2"];
    Num, [T"3"];
    Num, [T"4"];
    Num, [T"5"];
    Num, [T"6"];
    Num, [T"7"];
    Num, [T"8"];
    Num, [T"9"]]

let awksub_grammar_hw1 = Expr, awksub_rules

let awksub_grammar = convert_grammar awksub_grammar_hw1

let get_production = function
  | (start, production) -> production

let awksub_production = get_production awksub_grammar

(* PART 2 *)

type test_nonterminals = 
  | S | A | B | C | D | E | F | G

let test_prod = function
  | S -> [[T"s"]]
let test_grammar = (S, test_prod)
let test_matcher0 = parse_prefix test_grammar

let test_prod = function
  | S -> [[N A]]
  | A -> [[T"a"]]
let test_grammar = (S, test_prod)
let test_matcher1 = parse_prefix test_grammar

let test_prod = function
  | S -> [[N A]]
  | A -> [[N B]]
  | B -> [[N C]]
  | C -> [[N D]]
  | D -> [[N E]]
  | E -> [[N F]]
  | F -> [[T"f"]]
let test_grammar = (S, test_prod)
let test_matcher2 = parse_prefix test_grammar

let test_prod = function
  | S -> [[N A; N B]]
  | A -> [[T"a"]]
  | B -> [[T"b"]]
let test_grammar = (S, test_prod)
let test_matcher3 = parse_prefix test_grammar

let test_prod = function
  | S -> [[N A];
          [N B]]
  | A -> [[T"a"]]
  | B -> [[T"b"]]
let test_grammar = (S, test_prod)
let test_matcher4 = parse_prefix test_grammar

let test_prod = function
  | S -> [[N A];
          [N B]]
  | A -> [[N C];
          [N D]]
  | B -> [[N E];
          [N F]]
  | C -> [[T"c"]]
  | D -> [[T"d"]]
  | E -> [[T"e"]]
  | F -> [[T"f"]]
let test_grammar = (S, test_prod)
let test_matcher5 = parse_prefix test_grammar

let test_prod = function
  | S -> [[N A];
          [N B];
          [N C]]
  | A -> [[T"a"]]
  | B -> [[T"b"]]
  | C -> [[T"c"]]
let test_grammar = (S, test_prod)
let test_matcher6 = parse_prefix test_grammar

let test_prod = function
  | S -> [[N A; N B; N C];
          [N A]]
  | A -> [[T"a"]]
  | B -> [[T"b"]]
  | C -> [[T"c"]]
let test_grammar = (S, test_prod)
let test_matcher7 = parse_prefix test_grammar

let test_prod = function
  | S -> [[N A];
          [N A; N B; N C]]
  | A -> [[T"a"]]
  | B -> [[T"b"]]
  | C -> [[T"c"]]
let test_grammar = (S, test_prod)
let test_matcher8 = parse_prefix test_grammar

let test_prod = function
  | S -> [[N A; N B; N C];
          [N A]]
  | A -> [[N B];
          [N C]];
  | B -> [[T"b"]]
  | C -> [[T"c"]]
let test_grammar = (S, test_prod)
let test_matcher9 = parse_prefix test_grammar

let test_prod = function
  | S -> [[N A; N B; N C];
          [N A]]
  | A -> [[N E];
          [N B];
          [N C; N B];
          [N B; N C]]
  | B -> [[T"b"]]
  | C -> [[T"c"]]
  | D -> [[T"d"]]
  | E -> [[T"e"]]
let test_grammar = (S, test_prod)
let test_matcher10 = parse_prefix test_grammar

let test_prod = function
  | S -> [[T"t"; N A]]
  | A -> [[T"s"; N A];
          [T"s"]]
let snake_grammar = (S, test_prod)
let test_matcher11 = parse_prefix snake_grammar

let test_prod = function
  | S -> [[N A; N D; N S];
          [N A]]
  | A -> [[N E];
          [N B];
          [N C; N B];
          [N B; N C];
          [T"a"; N S; T"a"]]
  | B -> [[T"b"; N S]]
  | C -> [[T"c"]]
  | D -> [[T"d"]]
  | E -> [[T"e"]]
let test_grammar = (S, test_prod)
let test_matcher12 = parse_prefix test_grammar

(* Test Cases*)

let accept_all derivation string = Some (derivation, string)
let accept_empty_suffix derivation = function
   | [] -> Some (derivation, [])
   | _ -> None

type awksub_nonterminals =
  | Expr | Term | Lvalue | Incrop | Binop | Num

let awkish_grammar =
  (Expr,
   function
     | Expr ->
         [[N Term; N Binop; N Expr]; 
          [N Term]]
     | Term ->
         [[N Num]; 
          [N Lvalue]; 
          [N Incrop; N Lvalue]; 
          [N Lvalue; N Incrop]; 
          [T"("; N Expr; T")"]]
     | Lvalue ->
         [[T"$"; N Expr]]
     | Incrop ->
         [[T"++"];
          [T"--"]]
     | Binop ->
         [[T"+"];
          [T"-"]]
     | Num ->
         [[T"0"]; 
          [T"1"]; 
          [T"2"]; 
          [T"3"]; 
          [T"4"];
          [T"5"]; 
          [T"6"]; 
          [T"7"]; 
          [T"8"]; 
          [T"9"]]
  )

let test0 =
  ((parse_prefix awkish_grammar accept_all ["ouch"]) = None)

let test1 =
  ((parse_prefix awkish_grammar accept_all ["9"])
   = Some ([(Expr, [N Term]); (Term, [N Num]); (Num, [T "9"])], []))

let test2 =
  ((parse_prefix awkish_grammar accept_all ["9"; "+"; "$"; "1"; "+"])
   = Some
       ([(Expr, [N Term; N Binop; N Expr]); (Term, [N Num]); (Num, [T "9"]);
		 (Binop, [T "+"]); (Expr, [N Term]); (Term, [N Lvalue]);
		  (Lvalue, [T "$"; N Expr]); (Expr, [N Term]); (Term, [N Num]);
			    (Num, [T "1"])],
			    ["+"]))

let test3 =
  ((parse_prefix awkish_grammar accept_empty_suffix ["9"; "+"; "$"; "1"; "+"])
   = None)

(* This one might take a bit longer.... *)
let test4 =
 ((parse_prefix awkish_grammar accept_all
     ["("; "$"; "8"; ")"; "-"; "$"; "++"; "$"; "--"; "$"; "9"; "+";
      "("; "$"; "++"; "$"; "2"; "+"; "("; "8"; ")"; "-"; "9"; ")";
      "-"; "("; "$"; "$"; "$"; "$"; "$"; "++"; "$"; "$"; "5"; "++";
      "++"; "--"; ")"; "-"; "++"; "$"; "$"; "("; "$"; "8"; "++"; ")";
      "++"; "+"; "0"])
  = Some
     ([(Expr, [N Term; N Binop; N Expr]); (Term, [T "("; N Expr; T ")"]);
       (Expr, [N Term]); (Term, [N Lvalue]); (Lvalue, [T "$"; N Expr]);
       (Expr, [N Term]); (Term, [N Num]); (Num, [T "8"]); (Binop, [T "-"]);
       (Expr, [N Term; N Binop; N Expr]); (Term, [N Lvalue]);
       (Lvalue, [T "$"; N Expr]); (Expr, [N Term; N Binop; N Expr]);
       (Term, [N Incrop; N Lvalue]); (Incrop, [T "++"]);
       (Lvalue, [T "$"; N Expr]); (Expr, [N Term; N Binop; N Expr]);
       (Term, [N Incrop; N Lvalue]); (Incrop, [T "--"]);
       (Lvalue, [T "$"; N Expr]); (Expr, [N Term; N Binop; N Expr]);
       (Term, [N Num]); (Num, [T "9"]); (Binop, [T "+"]); (Expr, [N Term]);
       (Term, [T "("; N Expr; T ")"]); (Expr, [N Term; N Binop; N Expr]);
       (Term, [N Lvalue]); (Lvalue, [T "$"; N Expr]);
       (Expr, [N Term; N Binop; N Expr]); (Term, [N Incrop; N Lvalue]);
       (Incrop, [T "++"]); (Lvalue, [T "$"; N Expr]); (Expr, [N Term]);
       (Term, [N Num]); (Num, [T "2"]); (Binop, [T "+"]); (Expr, [N Term]);
       (Term, [T "("; N Expr; T ")"]); (Expr, [N Term]); (Term, [N Num]);
       (Num, [T "8"]); (Binop, [T "-"]); (Expr, [N Term]); (Term, [N Num]);
       (Num, [T "9"]); (Binop, [T "-"]); (Expr, [N Term]);
       (Term, [T "("; N Expr; T ")"]); (Expr, [N Term]); (Term, [N Lvalue]);
       (Lvalue, [T "$"; N Expr]); (Expr, [N Term]); (Term, [N Lvalue]);
       (Lvalue, [T "$"; N Expr]); (Expr, [N Term]); (Term, [N Lvalue]);
       (Lvalue, [T "$"; N Expr]); (Expr, [N Term]); (Term, [N Lvalue; N Incrop]);
       (Lvalue, [T "$"; N Expr]); (Expr, [N Term]); (Term, [N Lvalue; N Incrop]);
       (Lvalue, [T "$"; N Expr]); (Expr, [N Term]); (Term, [N Incrop; N Lvalue]);
       (Incrop, [T "++"]); (Lvalue, [T "$"; N Expr]); (Expr, [N Term]);
       (Term, [N Lvalue; N Incrop]); (Lvalue, [T "$"; N Expr]); (Expr, [N Term]);
       (Term, [N Num]); (Num, [T "5"]); (Incrop, [T "++"]); (Incrop, [T "++"]);
       (Incrop, [T "--"]); (Binop, [T "-"]); (Expr, [N Term]);
       (Term, [N Incrop; N Lvalue]); (Incrop, [T "++"]);
       (Lvalue, [T "$"; N Expr]); (Expr, [N Term]); (Term, [N Lvalue; N Incrop]);
       (Lvalue, [T "$"; N Expr]); (Expr, [N Term]);
       (Term, [T "("; N Expr; T ")"]); (Expr, [N Term]);
       (Term, [N Lvalue; N Incrop]); (Lvalue, [T "$"; N Expr]); (Expr, [N Term]);
       (Term, [N Num]); (Num, [T "8"]); (Incrop, [T "++"]); (Incrop, [T "++"]);
       (Binop, [T "+"]); (Expr, [N Term]); (Term, [N Num]); (Num, [T "0"])],
      []))

let rec contains_lvalue = function
  | [] -> false
  | (Lvalue,_)::_ -> true
  | _::rules -> contains_lvalue rules

let accept_only_non_lvalues rules frag =
  if contains_lvalue rules
  then None
  else Some (rules, frag)

let test5 =
  ((parse_prefix awkish_grammar accept_only_non_lvalues
      ["3"; "-"; "4"; "+"; "$"; "5"; "-"; "6"])
   = Some
      ([(Expr, [N Term; N Binop; N Expr]); (Term, [N Num]); (Num, [T "3"]);
(Binop, [T "-"]); (Expr, [N Term]); (Term, [N Num]); (Num, [T "4"])],
       ["+"; "$"; "5"; "-"; "6"]))

let test_1 =
  ((parse_prefix awkish_grammar accept_none
      ["

let test_2 =
