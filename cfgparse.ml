type token =
  | CIdent of (string)
  | CString of (string)
  | CInt of (int)
  | CFloat of (float)
  | CLParen
  | CRParen
  | CEqual
  | CEof

open Parsing;;
# 2 "cfgparse.mly"
(*let p = print_endline;; *)
let p x = ();;

let stripQuotes str =
   let last = (String.length str) - 1 in
   let str = Str.string_before str last in
   let str = Str.string_after str 1 in
   str
;;

let convertQuotes str =
   let a = Str.regexp "\\\\\""
   and b = Str.regexp "\\\\'"
   and c = Str.regexp "\\\\\\\\" in
   let str = Str.global_replace a "\"" str in
   let str = Str.global_replace b "'" str in
   let str = Str.global_replace c "\\" str in
   str
;;
    
# 34 "cfgparse.ml"
let yytransl_const = [|
  261 (* CLParen *);
  262 (* CRParen *);
  263 (* CEqual *);
  264 (* CEof *);
    0|]

let yytransl_block = [|
  257 (* CIdent *);
  258 (* CString *);
  259 (* CInt *);
  260 (* CFloat *);
    0|]

let yylhs = "\255\255\
\001\000\001\000\002\000\002\000\003\000\004\000\004\000\004\000\
\004\000\005\000\005\000\000\000"

let yylen = "\002\000\
\002\000\001\000\001\000\002\000\003\000\001\000\001\000\001\000\
\003\000\001\000\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\002\000\012\000\000\000\003\000\000\000\
\001\000\004\000\006\000\007\000\008\000\000\000\005\000\010\000\
\000\000\009\000\011\000"

let yydgoto = "\002\000\
\005\000\006\000\007\000\015\000\017\000"

let yysindex = "\013\000\
\255\254\000\000\251\254\000\000\000\000\000\255\000\000\001\255\
\000\000\000\000\000\000\000\000\000\000\001\255\000\000\000\000\
\007\255\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\000\000\010\000\001\000\000\000"

let yytablesize = 18
let yytable = "\003\000\
\003\000\008\000\011\000\012\000\013\000\014\000\004\000\009\000\
\011\000\012\000\013\000\014\000\018\000\001\000\016\000\010\000\
\000\000\019\000"

let yycheck = "\001\001\
\001\001\007\001\002\001\003\001\004\001\005\001\008\001\008\001\
\002\001\003\001\004\001\005\001\006\001\001\000\014\000\006\000\
\255\255\017\000"

let yynames_const = "\
  CLParen\000\
  CRParen\000\
  CEqual\000\
  CEof\000\
  "

let yynames_block = "\
  CIdent\000\
  CString\000\
  CInt\000\
  CFloat\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'sectionlist) in
    Obj.repr(
# 36 "cfgparse.mly"
   ( p "Sectionlist"; _1 )
# 110 "cfgparse.ml"
               : (string * Cfgtype.cfgval) list))
; (fun __caml_parser_env ->
    Obj.repr(
# 38 "cfgparse.mly"
   ( p "No section"; [] )
# 116 "cfgparse.ml"
               : (string * Cfgtype.cfgval) list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'section) in
    Obj.repr(
# 44 "cfgparse.mly"
   ( [_1] )
# 123 "cfgparse.ml"
               : 'sectionlist))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'sectionlist) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'section) in
    Obj.repr(
# 46 "cfgparse.mly"
   ( _1 @ [_2] )
# 131 "cfgparse.ml"
               : 'sectionlist))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'value) in
    Obj.repr(
# 51 "cfgparse.mly"
   ( p "Section"; (_1, _3) )
# 139 "cfgparse.ml"
               : 'section))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 56 "cfgparse.mly"
   ( p "String"; p _1; Cfgtype.CfgString( convertQuotes (stripQuotes _1) ) )
# 146 "cfgparse.ml"
               : 'value))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 58 "cfgparse.mly"
   ( p "Int"; p (string_of_int _1); Cfgtype.CfgInt( _1 ) )
# 153 "cfgparse.ml"
               : 'value))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : float) in
    Obj.repr(
# 60 "cfgparse.mly"
   ( Cfgtype.CfgFloat( _1 ) )
# 160 "cfgparse.ml"
               : 'value))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'lst) in
    Obj.repr(
# 62 "cfgparse.mly"
   ( Cfgtype.CfgList( _2 ) )
# 167 "cfgparse.ml"
               : 'value))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'value) in
    Obj.repr(
# 67 "cfgparse.mly"
   ( [_1] )
# 174 "cfgparse.ml"
               : 'lst))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'lst) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'value) in
    Obj.repr(
# 69 "cfgparse.mly"
   ( _1 @ [_2] )
# 182 "cfgparse.ml"
               : 'lst))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : (string * Cfgtype.cfgval) list)
;;
