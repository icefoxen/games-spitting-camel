
type cfgval =
   CfgInt of int
 | CfgFloat of float
 | CfgString of string
 | CfgList of cfgval list
;;

