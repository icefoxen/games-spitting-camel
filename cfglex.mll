{
(* Lexer for config parser.
   Pretty simple.
XXX: Cannot lex strings containing "?  It might be able to actually...

I really really hate that the ocaml parser interprets double-quotes in 
comments: "
*)

open Cfgparse
exception Eof

let l = Lexing.lexeme;;
let p x = () (* print_endline x;; *)
}

let identr = ['a'-'z''A'-'Z''_''+'':''<''>'',''.']+
let intr = '-'?['0'-'9']+
let floatr = '-'?['0'-'9']*'.'['0'-'9']*
let stringr = '"' ('\\'_ | [^'"' '\\'])* '"' | '\'' ('\\'_ | [^'\'' '\\'])* '\''

let linecomment = ';'[^'\n']*'\n'
let whitespace = [' ''\t''\r''\n'] | linecomment

rule start = parse
   '='      { p "="; CEqual }
 | '('      { p "("; CLParen }
 | ')'      { p ")"; CRParen }
 | linecomment  { p "comment"; start lexbuf }
 | whitespace   { start lexbuf }
 | identr   { CIdent( p "ident"; p (l lexbuf); l lexbuf ) }
 | intr     { CInt( p "int"; int_of_string (l lexbuf) ) }
 | floatr   { CFloat( p "float"; p "foo:"; p (l lexbuf); float_of_string (l lexbuf) ) }
 | stringr  { CString( p "string"; l lexbuf ) }
 | eof      { p "eof"; CEof }

