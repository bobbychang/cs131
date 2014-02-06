let my_subset_test0 = subset [1;9;5;5;6;1;9] [1;2;3;4;5;6;7;8;9]
let my_subset_test1 = not (subset [1;2;4;9] [1;2;3;4;5;6;7;8])

let my_proper_subset_test0 = proper_subset [1;4;2] [3;2;1;1;4]
let my_proper_subset_test1 = not (proper_subset [1;4;2;3] [3;2;1;1;4])

let my_equal_set_test0 = equal_sets [1;2] [2;1;1;2]
let my_equal_set_test1 = not (equal_sets [1;2;3] [2;1;1;2])

let my_set_diff_test0 = equal_sets (set_diff [1;2;3] [1;2;2;1]) [3]

let my_computed_fixed_point_test0 = computed_fixed_point (=) (fun x -> x / 3) 81 = 0

let my_computed_periodic_point_test0 = computed_periodic_point (=) (fun x -> x * (-1)) 2 1 = 1

type mygram_nonterminals = 
  | S | A | B | C | D

let mygram_rules =
  [S, [N A; N B];
   S, [N B; N C];
   A, [T"A"];
   B, [T"B"];
   C, [T"C"];
   C, [N D];
   D, [T"D"; N C];]

let mygram = S, mygram_rules

let my_filter_blind_alleys_test0 = 
  filter_blind_alleys mygram = mygram

type mybadgram_nonterminals = 
  | S | A | B | C | D | E

let mybadgram_rules =
  [S, [N A; N B];
   S, [N B; N C];
   A, [T"A"];
   B, [T"B"];
   C, [T"C"; N D];
   D, [T"D"; N C];
   E, [T"E"; N A];]

let myfixedgram_rules =
  [S, [N A; N B];
   A, [T"A"];
   B, [T"B"];]

let mybadgram = S, mybadgram_rules

let myfixedgram = S, myfixedgram_rules

let my_filter_blind_alleys_test1 = 
  filter_blind_alleys mybadgram = myfixedgram
