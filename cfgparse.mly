%{
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
    
%}

%token<string> CIdent CString
%token<int> CInt
%token<float> CFloat
%token CLParen CRParen CEqual CEof

%start main
%type<(string * Cfgtype.cfgval) list> main

%%

main:
   sectionlist CEof
   { p "Sectionlist"; $1 }
 | CEof
   { p "No section"; [] }

;

sectionlist:
   section
   { [$1] }
 | sectionlist section
   { $1 @ [$2] }
;

section:
   CIdent CEqual value
   { p "Section"; ($1, $3) }
;

value:
   CString
   { p "String"; p $1; Cfgtype.CfgString( convertQuotes (stripQuotes $1) ) }
 | CInt
   { p "Int"; p (string_of_int $1); Cfgtype.CfgInt( $1 ) }
 | CFloat
   { Cfgtype.CfgFloat( $1 ) }
 | CLParen lst CRParen
   { Cfgtype.CfgList( $2 ) }
;

lst:
   value
   { [$1] }
 | lst value
   { $1 @ [$2] }
;


%%
