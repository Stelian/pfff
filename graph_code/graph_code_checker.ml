(* Yoann Padioleau
 *
 * Copyright (C) 2014 Facebook
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file license.txt.
 * 
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 *)
open Common

module E = Database_code
module G = Graph_code
module PI = Parse_info
module Error = Errors_code

(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)

(*****************************************************************************)
(* Helpers *)
(*****************************************************************************)

(*****************************************************************************)
(* Checker *)
(*****************************************************************************)
let check_imperative g =

  let pred = G.mk_eff_use_pred g in

  g +> G.iter_nodes (fun n ->
    G.nodeinfo_opt n g +> Common.do_option (fun info ->

      let ps = pred n in
      (* todo: filter nodes that are in boilerplate code *)
      if ps = [] 
      then Error.warning info.G.pos (Error.Deadcode n);

      (* todo: factorize with graph_code_clang, put in database_code? *)
      let n_def_opt =
        match n with
        | s, E.Prototype -> Some (s, E.Function)
        | s, E.GlobalExtern -> Some (s, E.Global)
        | _ -> None
      in
      n_def_opt +> Common.do_option (fun n_def ->
        let n_decl = n in
        if not (G.has_node n_def g)
        then Error.warning info.G.pos (Error.UndefinedDefOfDecl n_decl)
      )
  ))

let check g =
  Common.save_excursion Error.g_errors [] (fun () ->
    check_imperative g;
    !Error.g_errors +> List.rev
  )
