(* generated by ocamltarzan with: camlp4o -o /tmp/yyy.ml -I pa/ pa_type_conv.cmo pa_vof.cmo  pr_o.cmo /tmp/xxx.ml  *)

open Ast_ml

let rec vof_info v = Parse_info.vof_info v
and vof_tok v = vof_info v
and vof_wrap _of_a (v1, v2) =
  let v1 = _of_a v1 and v2 = vof_info v2 in Ocaml.VTuple [ v1; v2 ]
and vof_paren _of_a (v1, v2, v3) =
  let v1 = vof_tok v1
  and v2 = _of_a v2
  and v3 = vof_tok v3
  in Ocaml.VTuple [ v1; v2; v3 ]
and vof_brace _of_a (v1, v2, v3) =
  let v1 = vof_tok v1
  and v2 = _of_a v2
  and v3 = vof_tok v3
  in Ocaml.VTuple [ v1; v2; v3 ]
and vof_bracket _of_a (v1, v2, v3) =
  let v1 = vof_tok v1
  and v2 = _of_a v2
  and v3 = vof_tok v3
  in Ocaml.VTuple [ v1; v2; v3 ]
and vof_comma_list _of_a = Ocaml.vof_list (Ocaml.vof_either _of_a vof_tok)
and vof_and_list _of_a = Ocaml.vof_list (Ocaml.vof_either _of_a vof_tok)
and vof_pipe_list _of_a = Ocaml.vof_list (Ocaml.vof_either _of_a vof_tok)
and vof_semicolon_list _of_a =
  Ocaml.vof_list (Ocaml.vof_either _of_a vof_tok)
and vof_star_list _of_a = Ocaml.vof_list (Ocaml.vof_either _of_a vof_tok)
  
let rec vof_name =
  function
  | Name v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1 in Ocaml.VSum (("Name", [ v1 ]))
and vof_lname v = vof_name v
and vof_uname v = vof_name v
  
let rec vof_long_name (v1, v2) =
  let v1 = vof_qualifier v1 and v2 = vof_name v2 in Ocaml.VTuple [ v1; v2 ]
and vof_qualifier v =
  Ocaml.vof_list
    (fun (v1, v2) ->
       let v1 = vof_name v1 and v2 = vof_tok v2 in Ocaml.VTuple [ v1; v2 ])
    v
  
let rec vof_ty =
  function
  | TyName v1 -> let v1 = vof_long_name v1 in Ocaml.VSum (("TyName", [ v1 ]))
  | TyVar ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_name v2
      in Ocaml.VSum (("TyVar", [ v1; v2 ]))
  | TyTuple v1 ->
      let v1 = vof_star_list vof_ty v1 in Ocaml.VSum (("TyTuple", [ v1 ]))
  | TyTuple2 v1 ->
      let v1 = vof_paren (vof_star_list vof_ty) v1
      in Ocaml.VSum (("TyTuple2", [ v1 ]))
  | TyFunction ((v1, v2, v3)) ->
      let v1 = vof_ty v1
      and v2 = vof_tok v2
      and v3 = vof_ty v3
      in Ocaml.VSum (("TyFunction", [ v1; v2; v3 ]))
  | TyApp ((v1, v2)) ->
      let v1 = vof_ty_args v1
      and v2 = vof_long_name v2
      in Ocaml.VSum (("TyApp", [ v1; v2 ]))
  | TyTodo -> Ocaml.VSum (("TyTodo", []))
and vof_type_declaration =
  function
  | TyAbstract ((v1, v2)) ->
      let v1 = vof_ty_params v1
      and v2 = vof_name v2
      in Ocaml.VSum (("TyAbstract", [ v1; v2 ]))
  | TyDef ((v1, v2, v3, v4)) ->
      let v1 = vof_ty_params v1
      and v2 = vof_name v2
      and v3 = vof_tok v3
      and v4 = vof_type_def_kind v4
      in Ocaml.VSum (("TyDef", [ v1; v2; v3; v4 ]))
and vof_type_def_kind =
  function
  | TyCore v1 -> let v1 = vof_ty v1 in Ocaml.VSum (("TyCore", [ v1 ]))
  | TyAlgebric v1 ->
      let v1 = vof_pipe_list vof_constructor_declaration v1
      in Ocaml.VSum (("TyAlgebric", [ v1 ]))
  | TyRecord v1 ->
      let v1 = vof_brace (vof_semicolon_list vof_field_declaration) v1
      in Ocaml.VSum (("TyRecord", [ v1 ]))
and vof_constructor_declaration (v1, v2) =
  let v1 = vof_name v1
  and v2 = vof_constructor_arguments v2
  in Ocaml.VTuple [ v1; v2 ]
and vof_constructor_arguments =
  function
  | NoConstrArg -> Ocaml.VSum (("NoConstrArg", []))
  | Of ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_star_list vof_ty v2
      in Ocaml.VSum (("Of", [ v1; v2 ]))
and
  vof_field_declaration {
                          fld_mutable = v_fld_mutable;
                          fld_name = v_fld_name;
                          fld_tok = v_fld_tok;
                          fld_type = v_fld_type
                        } =
  let bnds = [] in
  let arg = vof_ty v_fld_type in
  let bnd = ("fld_type", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_tok v_fld_tok in
  let bnd = ("fld_tok", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_name v_fld_name in
  let bnd = ("fld_name", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_option vof_tok v_fld_mutable in
  let bnd = ("fld_mutable", arg) in
  let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_ty_args =
  function
  | TyArg1 v1 -> let v1 = vof_ty v1 in Ocaml.VSum (("TyArg1", [ v1 ]))
  | TyArgMulti v1 ->
      let v1 = vof_paren (vof_comma_list vof_ty) v1
      in Ocaml.VSum (("TyArgMulti", [ v1 ]))
and vof_ty_params =
  function
  | TyNoParam -> Ocaml.VSum (("TyNoParam", []))
  | TyParam1 v1 ->
      let v1 = vof_ty_parameter v1 in Ocaml.VSum (("TyParam1", [ v1 ]))
  | TyParamMulti v1 ->
      let v1 = vof_paren (vof_comma_list vof_ty_parameter) v1
      in Ocaml.VSum (("TyParamMulti", [ v1 ]))
and vof_ty_parameter (v1, v2) =
  let v1 = vof_tok v1 and v2 = vof_name v2 in Ocaml.VTuple [ v1; v2 ]
and vof_expr =
  function
  | C v1 -> let v1 = vof_constant v1 in Ocaml.VSum (("C", [ v1 ]))
  | L v1 -> let v1 = vof_long_name v1 in Ocaml.VSum (("L", [ v1 ]))
  | Cons ((v1, v2)) ->
      let v1 = vof_long_name v1
      and v2 = Ocaml.vof_option vof_expr v2
      in Ocaml.VSum (("Cons", [ v1; v2 ]))
  | Tuple v1 ->
      let v1 = vof_comma_list vof_expr v1 in Ocaml.VSum (("Tuple", [ v1 ]))
  | List v1 ->
      let v1 = vof_bracket (vof_semicolon_list vof_expr) v1
      in Ocaml.VSum (("List", [ v1 ]))
  | ParenExpr v1 ->
      let v1 = vof_paren vof_expr v1 in Ocaml.VSum (("ParenExpr", [ v1 ]))
  | Sequence v1 ->
      let v1 = vof_paren vof_seq_expr v1 in Ocaml.VSum (("Sequence", [ v1 ]))
  | Prefix ((v1, v2)) ->
      let v1 = vof_wrap Ocaml.vof_string v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("Prefix", [ v1; v2 ]))
  | Infix ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_wrap Ocaml.vof_string v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("Infix", [ v1; v2; v3 ]))
  | FunCallSimple ((v1, v2)) ->
      let v1 = vof_long_name v1
      and v2 = Ocaml.vof_list vof_argument v2
      in Ocaml.VSum (("FunCallSimple", [ v1; v2 ]))
  | FunCall ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = Ocaml.vof_list vof_argument v2
      in Ocaml.VSum (("FunCall", [ v1; v2 ]))
  | RefAccess ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("RefAccess", [ v1; v2 ]))
  | RefAssign ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_tok v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("RefAssign", [ v1; v2; v3 ]))
  | FieldAccess ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_tok v2
      and v3 = vof_long_name v3
      in Ocaml.VSum (("FieldAccess", [ v1; v2; v3 ]))
  | FieldAssign ((v1, v2, v3, v4, v5)) ->
      let v1 = vof_expr v1
      and v2 = vof_tok v2
      and v3 = vof_long_name v3
      and v4 = vof_tok v4
      and v5 = vof_expr v5
      in Ocaml.VSum (("FieldAssign", [ v1; v2; v3; v4; v5 ]))
  | Record v1 ->
      let v1 = vof_brace vof_record_expr v1
      in Ocaml.VSum (("Record", [ v1 ]))
  | ObjAccess ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_tok v2
      and v3 = vof_name v3
      in Ocaml.VSum (("ObjAccess", [ v1; v2; v3 ]))
  | New ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_long_name v2
      in Ocaml.VSum (("New", [ v1; v2 ]))
  | LetIn ((v1, v2, v3, v4, v5)) ->
      let v1 = vof_tok v1
      and v2 = vof_rec_opt v2
      and v3 = vof_and_list vof_let_binding v3
      and v4 = vof_tok v4
      and v5 = vof_seq_expr v5
      in Ocaml.VSum (("LetIn", [ v1; v2; v3; v4; v5 ]))
  | Fun ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = Ocaml.vof_list vof_parameter v2
      and v3 = vof_match_action v3
      in Ocaml.VSum (("Fun", [ v1; v2; v3 ]))
  | Function ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_pipe_list vof_match_case v2
      in Ocaml.VSum (("Function", [ v1; v2 ]))
  | If ((v1, v2, v3, v4, v5)) ->
      let v1 = vof_tok v1
      and v2 = vof_seq_expr v2
      and v3 = vof_tok v3
      and v4 = vof_expr v4
      and v5 =
        Ocaml.vof_option
          (fun (v1, v2) ->
             let v1 = vof_tok v1
             and v2 = vof_expr v2
             in Ocaml.VTuple [ v1; v2 ])
          v5
      in Ocaml.VSum (("If", [ v1; v2; v3; v4; v5 ]))
  | Match ((v1, v2, v3, v4)) ->
      let v1 = vof_tok v1
      and v2 = vof_seq_expr v2
      and v3 = vof_tok v3
      and v4 = vof_pipe_list vof_match_case v4
      in Ocaml.VSum (("Match", [ v1; v2; v3; v4 ]))
  | Try ((v1, v2, v3, v4)) ->
      let v1 = vof_tok v1
      and v2 = vof_seq_expr v2
      and v3 = vof_tok v3
      and v4 = vof_pipe_list vof_match_case v4
      in Ocaml.VSum (("Try", [ v1; v2; v3; v4 ]))
  | While ((v1, v2, v3, v4, v5)) ->
      let v1 = vof_tok v1
      and v2 = vof_seq_expr v2
      and v3 = vof_tok v3
      and v4 = vof_seq_expr v4
      and v5 = vof_tok v5
      in Ocaml.VSum (("While", [ v1; v2; v3; v4; v5 ]))
  | For ((v1, v2, v3, v4, v5, v6, v7, v8, v9)) ->
      let v1 = vof_tok v1
      and v2 = vof_name v2
      and v3 = vof_tok v3
      and v4 = vof_seq_expr v4
      and v5 = vof_for_direction v5
      and v6 = vof_seq_expr v6
      and v7 = vof_tok v7
      and v8 = vof_seq_expr v8
      and v9 = vof_tok v9
      in Ocaml.VSum (("For", [ v1; v2; v3; v4; v5; v6; v7; v8; v9 ]))
  | ExprTodo -> Ocaml.VSum (("ExprTodo", []))
and vof_seq_expr v = vof_semicolon_list vof_expr v
and vof_constant =
  function
  | Int v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1 in Ocaml.VSum (("Int", [ v1 ]))
  | Float v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1 in Ocaml.VSum (("Float", [ v1 ]))
  | Char v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1 in Ocaml.VSum (("Char", [ v1 ]))
  | String v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1
      in Ocaml.VSum (("String", [ v1 ]))
and vof_record_expr =
  function
  | RecordNormal v1 ->
      let v1 = vof_semicolon_list vof_field_and_expr v1
      in Ocaml.VSum (("RecordNormal", [ v1 ]))
  | RecordWith ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_tok v2
      and v3 = vof_semicolon_list vof_field_and_expr v3
      in Ocaml.VSum (("RecordWith", [ v1; v2; v3 ]))
and vof_field_and_expr =
  function
  | FieldExpr ((v1, v2, v3)) ->
      let v1 = vof_long_name v1
      and v2 = vof_tok v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("FieldExpr", [ v1; v2; v3 ]))
  | FieldImplicitExpr v1 ->
      let v1 = vof_long_name v1 in Ocaml.VSum (("FieldImplicitExpr", [ v1 ]))
and vof_argument =
  function
  | ArgExpr v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("ArgExpr", [ v1 ]))
  | ArgLabelTilde ((v1, v2)) ->
      let v1 = vof_name v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("ArgLabelTilde", [ v1; v2 ]))
  | ArgImplicitTildeExpr ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_name v2
      in Ocaml.VSum (("ArgImplicitTildeExpr", [ v1; v2 ]))
  | ArgLabelQuestion ((v1, v2)) ->
      let v1 = vof_name v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("ArgLabelQuestion", [ v1; v2 ]))
  | ArgImplicitQuestionExpr ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_name v2
      in Ocaml.VSum (("ArgImplicitQuestionExpr", [ v1; v2 ]))
and vof_match_action =
  function
  | Action ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_seq_expr v2
      in Ocaml.VSum (("Action", [ v1; v2 ]))
  | WhenAction ((v1, v2, v3, v4)) ->
      let v1 = vof_tok v1
      and v2 = vof_seq_expr v2
      and v3 = vof_tok v3
      and v4 = vof_seq_expr v4
      in Ocaml.VSum (("WhenAction", [ v1; v2; v3; v4 ]))
and vof_match_case (v1, v2) =
  let v1 = vof_pattern v1
  and v2 = vof_match_action v2
  in Ocaml.VTuple [ v1; v2 ]
and vof_for_direction =
  function
  | To v1 -> let v1 = vof_tok v1 in Ocaml.VSum (("To", [ v1 ]))
  | Downto v1 -> let v1 = vof_tok v1 in Ocaml.VSum (("Downto", [ v1 ]))
and vof_pattern =
  function
  | PatVar v1 -> let v1 = vof_name v1 in Ocaml.VSum (("PatVar", [ v1 ]))
  | PatConstant v1 ->
      let v1 = vof_signed_constant v1 in Ocaml.VSum (("PatConstant", [ v1 ]))
  | PatCons ((v1, v2)) ->
      let v1 = vof_long_name v1
      and v2 = Ocaml.vof_option vof_pattern v2
      in Ocaml.VSum (("PatCons", [ v1; v2 ]))
  | PatConsInfix ((v1, v2, v3)) ->
      let v1 = vof_pattern v1
      and v2 = vof_tok v2
      and v3 = vof_pattern v3
      in Ocaml.VSum (("PatConsInfix", [ v1; v2; v3 ]))
  | PatTuple v1 ->
      let v1 = vof_comma_list vof_pattern v1
      in Ocaml.VSum (("PatTuple", [ v1 ]))
  | PatUnderscore v1 ->
      let v1 = vof_tok v1 in Ocaml.VSum (("PatUnderscore", [ v1 ]))
  | PatAs ((v1, v2, v3)) ->
      let v1 = vof_pattern v1
      and v2 = vof_tok v2
      and v3 = vof_name v3
      in Ocaml.VSum (("PatAs", [ v1; v2; v3 ]))
  | PatDisj ((v1, v2, v3)) ->
      let v1 = vof_pattern v1
      and v2 = vof_tok v2
      and v3 = vof_pattern v3
      in Ocaml.VSum (("PatDisj", [ v1; v2; v3 ]))
  | PatTyped ((v1, v2, v3, v4, v5)) ->
      let v1 = vof_tok v1
      and v2 = vof_pattern v2
      and v3 = vof_tok v3
      and v4 = vof_ty v4
      and v5 = vof_tok v5
      in Ocaml.VSum (("PatTyped", [ v1; v2; v3; v4; v5 ]))
  | ParenPat v1 ->
      let v1 = vof_paren vof_pattern v1 in Ocaml.VSum (("ParenPat", [ v1 ]))
  | PatTodo -> Ocaml.VSum (("PatTodo", []))
and vof_labeled_simple_pattern v = Ocaml.vof_unit v
and vof_parameter v = vof_labeled_simple_pattern v
and vof_signed_constant =
  function
  | C2 v1 -> let v1 = vof_constant v1 in Ocaml.VSum (("C2", [ v1 ]))
  | CMinus ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_constant v2
      in Ocaml.VSum (("CMinus", [ v1; v2 ]))
  | CPlus ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_constant v2
      in Ocaml.VSum (("CPlus", [ v1; v2 ]))
and vof_let_binding =
  function
  | LetClassic v1 ->
      let v1 = vof_let_def v1 in Ocaml.VSum (("LetClassic", [ v1 ]))
  | LetPattern ((v1, v2, v3)) ->
      let v1 = vof_pattern v1
      and v2 = vof_tok v2
      and v3 = vof_seq_expr v3
      in Ocaml.VSum (("LetPattern", [ v1; v2; v3 ]))
and
  vof_let_def {
                l_name = v_l_name;
                l_args = v_l_args;
                l_tok = v_l_tok;
                l_body = v_l_body
              } =
  let bnds = [] in
  let arg = vof_seq_expr v_l_body in
  let bnd = ("l_body", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_tok v_l_tok in
  let bnd = ("l_tok", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_list vof_parameter v_l_args in
  let bnd = ("l_args", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_name v_l_name in
  let bnd = ("l_name", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_function_def v = Ocaml.vof_unit v
and vof_module_type v = Ocaml.vof_unit v
and vof_module_expr = function
  | ModuleName v1 ->
      let v1 = vof_long_name v1 in
      Ocaml.VSum(("ModuleName", [ v1 ]))
  | ModuleStruct (v1, v2, v3) ->
      let v1 = vof_tok v1 in
      let v2 = Ocaml.vof_list vof_item v2 in
      let v3 = vof_tok v3 in
      Ocaml.VSum("ModuleStruct", [v1; v2; v3])
  | ModuleTodo ->
      Ocaml.VSum(("ModuleTodo", []))

and vof_item =
  function
  | Type ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_and_list vof_type_declaration v2
      in Ocaml.VSum (("Type", [ v1; v2 ]))
  | Exception ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_name v2
      and v3 = vof_constructor_arguments v3
      in Ocaml.VSum (("Exception", [ v1; v2; v3 ]))
  | External ((v1, v2, v3, v4, v5, v6)) ->
      let v1 = vof_tok v1
      and v2 = vof_name v2
      and v3 = vof_tok v3
      and v4 = vof_ty v4
      and v5 = vof_tok v5
      and v6 = Ocaml.vof_list (vof_wrap Ocaml.vof_string) v6
      in Ocaml.VSum (("External", [ v1; v2; v3; v4; v5; v6 ]))
  | Open ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_long_name v2
      in Ocaml.VSum (("Open", [ v1; v2 ]))
  | Val ((v1, v2, v3, v4)) ->
      let v1 = vof_tok v1
      and v2 = vof_name v2
      and v3 = vof_tok v3
      and v4 = vof_ty v4
      in Ocaml.VSum (("Val", [ v1; v2; v3; v4 ]))
  | Let ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_rec_opt v2
      and v3 = vof_and_list vof_let_binding v3
      in Ocaml.VSum (("Let", [ v1; v2; v3 ]))
  | Module ((v1, v2, v3, v4)) ->
      let v1 = vof_tok v1
      and v2 = vof_uname v2
      and v3 = vof_tok v3
      and v4 = vof_module_expr v4
      in Ocaml.VSum (("Module", [v1; v2; v3; v4]))
      

  | ItemTodo v1 -> let v1 = vof_info v1 in Ocaml.VSum (("ItemTodo", [ v1 ]))
and vof_sig_item v = vof_item v
and vof_struct_item v = vof_item v
and vof_rec_opt v = Ocaml.vof_option vof_tok v
and vof_toplevel =
  function
  | Item v1 -> let v1 = vof_item v1 in Ocaml.VSum (("Item", [ v1 ]))
  | ScSc v1 -> let v1 = vof_info v1 in Ocaml.VSum (("ScSc", [ v1 ]))
  | TopSeqExpr v1 ->
      let v1 = vof_seq_expr v1 in Ocaml.VSum (("TopSeqExpr", [ v1 ]))
  | TopDirective v1 ->
      let v1 = vof_info v1 in Ocaml.VSum (("TopDirective", [ v1 ]))
  | NotParsedCorrectly v1 ->
      let v1 = Ocaml.vof_list vof_info v1
      in Ocaml.VSum (("NotParsedCorrectly", [ v1 ]))
  | FinalDef v1 -> let v1 = vof_info v1 in Ocaml.VSum (("FinalDef", [ v1 ]))
and vof_program v = Ocaml.vof_list vof_toplevel v
  
let vof_any =
  function
  | Ty v1 -> let v1 = vof_ty v1 in Ocaml.VSum (("Ty", [ v1 ]))
  | Expr v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("Expr", [ v1 ]))
  | Pattern v1 -> let v1 = vof_pattern v1 in Ocaml.VSum (("Pattern", [ v1 ]))
  | Item2 v1 -> let v1 = vof_item v1 in Ocaml.VSum (("Item2", [ v1 ]))
  | Toplevel v1 ->
      let v1 = vof_toplevel v1 in Ocaml.VSum (("Toplevel", [ v1 ]))
  | Program v1 -> let v1 = vof_program v1 in Ocaml.VSum (("Program", [ v1 ]))
  | TypeDeclaration v1 ->
      let v1 = vof_type_declaration v1
      in Ocaml.VSum (("TypeDeclaration", [ v1 ]))
  | TypeDefKind v1 ->
      let v1 = vof_type_def_kind v1 in Ocaml.VSum (("TypeDefKind", [ v1 ]))
  | FieldDeclaration v1 ->
      let v1 = vof_field_declaration v1
      in Ocaml.VSum (("FieldDeclaration", [ v1 ]))
  | MatchCase v1 ->
      let v1 = vof_match_case v1 in Ocaml.VSum (("MatchCase", [ v1 ]))
  | LetBinding v1 ->
      let v1 = vof_let_binding v1 in Ocaml.VSum (("LetBinding", [ v1 ]))
  | Constant v1 ->
      let v1 = vof_constant v1 in Ocaml.VSum (("Constant", [ v1 ]))
  | Argument v1 ->
      let v1 = vof_argument v1 in Ocaml.VSum (("Argument", [ v1 ]))
  | Body v1 -> let v1 = vof_seq_expr v1 in Ocaml.VSum (("Body", [ v1 ]))
  | Info v1 -> let v1 = vof_info v1 in Ocaml.VSum (("Info", [ v1 ]))
  | InfoList v1 ->
      let v1 = Ocaml.vof_list vof_info v1
      in Ocaml.VSum (("InfoList", [ v1 ]))
  
