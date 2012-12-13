type token =
  | CIdent of (string)
  | CString of (string)
  | CInt of (int)
  | CFloat of (float)
  | CLParen
  | CRParen
  | CEqual
  | CEof

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> (string * Cfgtype.cfgval) list
