(* Unit Tests *)

{shared{
  open Cells
}}

{client{
  open Dom
  open Dom_html

  (*** Setup the Environment for Testing ***)

  let msg_of_bool b =
    match b with
    | true  -> "pass"
    | false -> "fail"

  let set_shift_area () =
    shift_area := Some [
      SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
      SingleCell {row = 2; col = 3; id = "2_3"; txt = ""};
      SingleCell {row = 3; col = 2; id = "3_2"; txt = ""};
      SingleCell {row = 3; col = 3; id = "3_3"; txt = ""}
      ];
    match !shift_area with
    | None -> ()
    | Some sa ->
      List.iter (fun (c : cell) ->
        let td = getElementById @@ id_of_cell c in
        td##textContent <- (Js.some @@ Js.string @@ txt_of_cell c)
        ) sa

  (* Clear all refs for tests *)
  let clear_all () =
    selected_cell  := None;
    shift_pressed  := false;
    shift_area     := None

  (*** Define Tests ***)

  type test_result = {
    name : string;
    pass : bool;
    msg  : string;
  }

  let row_of_id_test () = {
    name = "row_of_id_test";
    pass = (row_of_id "2_21") = 2;
    msg  = ""
  }

  let col_of_id_test () = {
    name = "col_of_id_test";
    pass = (col_of_id "2_17") = 17;
    msg  = ""
  }

  let key_of_id_test () = {
    name = "key_of_id_test";
    pass = (key_of_id "21_43") = (21, 43);
    msg  = ""
  }

  let cell_of_id_test () =
    set_shift_area ();
    {
      name = "cell_of_id_test";
      pass = (cell_of_id "2_3") = Some (SingleCell {row = 2; col = 3; id = "2_3"; txt = ""});
      msg  = "No Msg"
    }

  let shift_area_top_row_test () =
    clear_all ();
    selected_cell := Some (SingleCell {row = 3; col = 2; id = "3_2"; txt = ""});
    shift_area := Some [
      SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
      SingleCell {row = 2; col = 3; id = "2_3"; txt = ""};
      SingleCell {row = 3; col = 2; id = "3_2"; txt = ""};
      SingleCell {row = 3; col = 3; id = "3_3"; txt = ""}
    ];
    let top_row =
      [
        SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
        SingleCell {row = 2; col = 3; id = "2_3"; txt = ""}
      ]
    in
      {
        name = "shift_area_top_row_test";
        pass = (shift_area_top_row ()) = top_row;
        msg  = "N/A"
      }

  let shift_area_bottom_row_test () =
    clear_all ();
    selected_cell := Some (SingleCell {row = 3; col = 2; id = "3_2"; txt = ""});
    shift_area := Some [
      SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
      SingleCell {row = 2; col = 3; id = "2_3"; txt = ""};
      SingleCell {row = 3; col = 2; id = "3_2"; txt = ""};
      SingleCell {row = 3; col = 3; id = "3_3"; txt = ""}
    ];
    let bottom_row =
      [
        SingleCell {row = 3; col = 2; id = "3_2"; txt = ""};
        SingleCell {row = 3; col = 3; id = "3_3"; txt = ""}
      ]
    in
      {
        name = "shift_area_bottom_row_test";
        pass = (shift_area_bottom_row ()) = bottom_row;
        msg  = "N/A"
      }

  let shift_area_left_col_test () =
    clear_all ();
    selected_cell := Some (SingleCell {row = 3; col = 2; id = "3_2"; txt = ""});
    shift_area := Some [
      SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
      SingleCell {row = 2; col = 3; id = "2_3"; txt = ""};
      SingleCell {row = 3; col = 2; id = "3_2"; txt = ""};
      SingleCell {row = 3; col = 3; id = "3_3"; txt = ""}
    ];
    let left_col =
      [
        SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
        SingleCell {row = 3; col = 2; id = "3_2"; txt = ""}
      ]
    in
      {
        name = "shift_area_left_col_test";
        pass = (shift_area_left_col ()) = left_col;
        msg  = "N/A"
      }

  let shift_area_right_col_test () =
    clear_all ();
    selected_cell := Some (SingleCell {row = 3; col = 2; id = "3_2"; txt = ""});
    shift_area := Some [
      SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
      SingleCell {row = 2; col = 3; id = "2_3"; txt = ""};
      SingleCell {row = 3; col = 2; id = "3_2"; txt = ""};
      SingleCell {row = 3; col = 3; id = "3_3"; txt = ""}
    ];
    let right_col =
      [
        SingleCell {row = 2; col = 3; id = "2_3"; txt = ""};
        SingleCell {row = 3; col = 3; id = "3_3"; txt = ""}
      ]
    in
      {
        name = "shift_area_right_col_test";
        pass = (shift_area_right_col ()) = right_col;
        msg  = "N/A"
      }

  let row_above_shift_area_test () =
    clear_all ();
    selected_cell := Some (SingleCell {row = 3; col = 2; id = "3_2"; txt = ""});
    shift_area := Some [
      SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
      SingleCell {row = 2; col = 3; id = "2_3"; txt = ""};
      SingleCell {row = 3; col = 2; id = "3_2"; txt = ""};
      SingleCell {row = 3; col = 3; id = "3_3"; txt = ""}
    ];
    let row_above =
      [
        SingleCell {row = 1; col = 3; id = "1_3"; txt = ""};
        SingleCell {row = 1; col = 2; id = "1_2"; txt = ""}
      ]
    in
    let msg =
      List.map (string_of_cell) (row_above_shift_area ())
      |> List.fold_left (fun s acc -> s ^ acc) ""
    in
    {
      name = "row_above_shift_area_test";
      pass = (row_above_shift_area ()) = row_above;
      msg  = msg
    }

  let row_below_shift_area_test () =
    clear_all ();
    selected_cell := Some (SingleCell {row = 3; col = 2; id = "3_2"; txt = ""});
    shift_area := Some [
      SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
      SingleCell {row = 2; col = 3; id = "2_3"; txt = ""};
      SingleCell {row = 3; col = 2; id = "3_2"; txt = ""};
      SingleCell {row = 3; col = 3; id = "3_3"; txt = ""}
    ];
    let row_below =
      [
        SingleCell {row = 4; col = 3; id = "4_3"; txt = ""};
        SingleCell {row = 4; col = 2; id = "4_2"; txt = ""}
      ]
    in
    let msg =
      List.map (string_of_cell) (row_below_shift_area ())
      |> List.fold_left (fun s acc -> s ^ acc) ""
    in
    {
      name = "row_below_shift_area_test";
      pass = (row_below_shift_area ()) = row_below;
      msg  = msg
    }

  let col_left_shift_area_test ( )=
    clear_all ();
    selected_cell := Some (SingleCell {row = 3; col = 2; id = "3_2"; txt = ""});
    shift_area := Some [
      SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
      SingleCell {row = 2; col = 3; id = "2_3"; txt = ""};
      SingleCell {row = 3; col = 2; id = "3_2"; txt = ""};
      SingleCell {row = 3; col = 3; id = "3_3"; txt = ""}
    ];
    let col_left =
      [
        SingleCell {row = 3; col = 1; id = "3_1"; txt = ""};
        SingleCell {row = 2; col = 1; id = "2_1"; txt = ""}
      ]
    in
    let msg =
      List.map (string_of_cell) (col_left_shift_area ())
      |> List.fold_left (fun s acc -> s ^ acc) ""
    in
    {
      name = "col_left_shift_area_test";
      pass = (col_left_shift_area ()) = col_left;
      msg  = msg
    }

  let col_right_shift_area_test () =
    clear_all ();
    selected_cell := Some (SingleCell {row = 3; col = 2; id = "3_2"; txt = ""});
    shift_area := Some [
      SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
      SingleCell {row = 2; col = 3; id = "2_3"; txt = ""};
      SingleCell {row = 3; col = 2; id = "3_2"; txt = ""};
      SingleCell {row = 3; col = 3; id = "3_3"; txt = ""}
    ];
    let col_right =
      [
        SingleCell {row = 3; col = 4; id = "3_4"; txt = ""};
        SingleCell {row = 2; col = 4; id = "2_4"; txt = ""}
      ]
    in
    let msg =
      List.map (string_of_cell) (col_right_shift_area ())
      |> List.fold_left (fun s acc -> s ^ acc) ""
    in
    {
      name = "col_right_shift_area_test";
      pass = (col_right_shift_area ()) = col_right;
      msg  = msg
    }

  let update_shift_area_test_1 () =
    clear_all ();
    selected_cell := Some (SingleCell {row = 3; col = 2; id = "3_2"; txt = ""});
    shift_area := Some [SingleCell {row = 3; col = 2; id = "3_2"; txt = ""}];
    let new_shift_area =
      Some [
        SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
        SingleCell {row = 3; col = 2; id = "3_2"; txt = ""}
      ];
    in
    update_shift_area `Up;
    let msg =
      match !shift_area with
      | None -> "None"
      | Some sa -> List.map (string_of_cell) sa |> List.fold_left (fun s acc -> s ^ acc) ""
    in
    {
      name = "update_shift_area_test_1";
      pass = !shift_area = new_shift_area;
      msg  = "shift_area = " ^ msg
    }

  let update_shift_area_test_2 () =
    clear_all ();
    selected_cell := Some (SingleCell {row = 3; col = 2; id = "3_2"; txt = ""});
    shift_area := Some [
      SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
      SingleCell {row = 2; col = 3; id = "2_3"; txt = ""};
      SingleCell {row = 3; col = 2; id = "3_2"; txt = ""};
      SingleCell {row = 3; col = 3; id = "3_3"; txt = ""}
      ];
    let new_shift_area =
      Some [
        SingleCell {row = 1; col = 3; id = "1_3"; txt = ""};
        SingleCell {row = 1; col = 2; id = "1_2"; txt = ""};
        SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
        SingleCell {row = 2; col = 3; id = "2_3"; txt = ""};
        SingleCell {row = 3; col = 2; id = "3_2"; txt = ""};
        SingleCell {row = 3; col = 3; id = "3_3"; txt = ""}
      ];
    in
    update_shift_area `Up;
    let msg =
      match !shift_area with
      | None -> "None"
      | Some sa -> List.map (string_of_cell) sa |> List.fold_left (fun s acc -> s ^ acc) ""
    in
    {
      name = "update_shift_area_test_2";
      pass = !shift_area = new_shift_area;
      msg  = "shift_area = " ^ msg
    }

  let update_shift_area_test_3 () =
    clear_all ();
    selected_cell := Some (SingleCell {row = 2; col = 2; id = "2_2"; txt = ""});
    shift_area := Some [
      SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
      SingleCell {row = 2; col = 3; id = "2_3"; txt = ""};
      SingleCell {row = 3; col = 2; id = "3_2"; txt = ""};
      SingleCell {row = 3; col = 3; id = "3_3"; txt = ""}
      ];
    let new_shift_area =
      Some [
        SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
        SingleCell {row = 2; col = 3; id = "2_3"; txt = ""};
      ];
    in
    update_shift_area `Up;
    let msg =
      match !shift_area with
      | None -> "None"
      | Some sa -> List.map (string_of_cell) sa |> List.fold_left (fun s acc -> s ^ acc) ""
    in
    {
      name = "update_shift_area_test_3";
      pass = !shift_area = new_shift_area;
      msg  = "shift_area = " ^ msg
    }

  let shift_pressed_action_test () =
    clear_all ();
    selected_cell := Some (SingleCell {row = 3; col = 2; id = "3_2"; txt = ""});
    shift_pressed_action ();
    let b1 = (!shift_pressed = true) in
    let b2 = (!shift_area = Some [SingleCell {row = 3; col = 2; id = "3_2"; txt = ""}]) in
    let msg =
      "b1 - " ^ (msg_of_bool b1) ^
      ", b2 - " ^ (msg_of_bool b2)
    in
    {
      name = "shift_pressed_action_test";
      pass = b1 && b2;
      msg  = msg
    }

  (* Test up arrow with just a single selected_cell and w/o shift pressed *)
  let up_arrow_action_test_1 () =
    clear_all ();
    selected_cell := Some (SingleCell {row = 3; col = 2; id = "3_2"; txt = ""});
    shift_pressed := false;
    up_arrow_action ();
    let b1 = (!selected_cell = Some (SingleCell {row = 2; col = 2; id = "2_2"; txt = ""})) in
    let b2 = (!shift_area    = None) in
    let msg = "b1 - " ^ (msg_of_bool b1) ^ ", b2 - " ^ (msg_of_bool b2) in
    {
      name = "up_arrow_action_test_1";
      pass = b1 && b2;
      msg = msg
    }

  (* Test up arrow with just a single selected_cell and with shift pressed *)
let up_arrow_action_test_2 () =
    ignore @@ %shell_print "\n***** BEGIN ***** up_arrow_action_test_2 ***** BEGIN *****";
    clear_all ();
    (**) print_shift_area ();
    selected_cell := Some (SingleCell {row = 3; col = 2; id = "3_2"; txt = ""});
    shift_pressed := true;
    (**) print_shift_area ();
    up_arrow_action ();
    (**) print_shift_area ();
    let b1 = (!selected_cell = Some (SingleCell {row = 3; col = 2; id = "3_2"; txt = ""})) in
    let b2 = (!shift_area = Some [
        SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
        SingleCell {row = 3; col = 2; id = "3_2"; txt = ""}
      ])
    in
    (*let msg = "shift_area = " ^ (string_of_cell_list !shift_area) in*)
    let msg = "b1 - " ^ (msg_of_bool b1) ^ ", b2 - " ^ (msg_of_bool b2) in
    {
      name = "up_arrow_action_test_2";
      pass = b1 && b2;
      msg = msg
    }

(* Test up arrow TWICE with just a single selected_cell and with shift pressed *)
  let up_arrow_action_test_3 () =
    clear_all ();
    selected_cell := Some (SingleCell {row = 3; col = 2; id = "3_2"; txt = ""});
    shift_pressed := true;
    up_arrow_action ();
    up_arrow_action ();
    let b1 = (!selected_cell = Some (SingleCell {row = 2; col = 2; id = "2_2"; txt = ""})) in
    let b2 = (!shift_area = Some [
        SingleCell {row = 1; col = 2; id = "1_2"; txt = ""};
        SingleCell {row = 2; col = 2; id = "2_2"; txt = ""};
        SingleCell {row = 3; col = 2; id = "3_2"; txt = ""};
      ])
    in
    let msg =
      "b1 - " ^ (msg_of_bool b1) ^
      ", b2 - " ^ (msg_of_bool b2)
    in
    {
      name = "up_arrow_action_test_3";
      pass = b1 && b2;
      msg = msg
    }

  (* Group and Run Tests *)

  let tests = [
    row_of_id_test;
    col_of_id_test;
    key_of_id_test;
    cell_of_id_test;
    shift_area_top_row_test;
    shift_area_bottom_row_test;
    shift_area_left_col_test;
    shift_area_right_col_test;
    row_above_shift_area_test;
    row_below_shift_area_test;
    col_left_shift_area_test;
    col_right_shift_area_test;
    update_shift_area_test_1;
    update_shift_area_test_2;
    update_shift_area_test_3;
    shift_pressed_action_test;
    up_arrow_action_test_1;
    up_arrow_action_test_2;
    up_arrow_action_test_3
  ]

  (* Append the test results to the page *)
  let append_result ?(print_msg = true) (tr : test_result) =
    let body = document##body in
    let test_msg = createP document in
    let () =
      match tr.pass with
      | true -> (
          test_msg##textContent <- Js.some (Js.string (tr.name ^ " passed"));
          test_msg##style##backgroundColor <- Js.string "lightgreen"
        )
      | false -> (
          test_msg##textContent <- Js.some (Js.string
            ("*** " ^ tr.name ^ " FAILED ***" ^ (if print_msg then "msg = " ^ tr.msg else "")));
          test_msg##style##backgroundColor <- Js.string "lightpink"
        )
    in
    appendChild body test_msg

  let run_tests () =
    let body = document##body in
    let h = createH1 document in
    h##textContent <- Js.some (Js.string "Unit Test Results:");
    appendChild body h;
    let results = List.map (fun f -> f ()) tests in
    let all_tests_pass = List.map (fun tr -> tr.pass) results |> fun l -> not (List.mem false l) in
    if all_tests_pass
    then append_result ~print_msg:false {name = "ALL TESTS"; pass = true; msg = ""}
    else append_result ~print_msg:false {name = "SOME TESTS FAILED"; pass = false; msg = ""};
    List.iter (append_result) results
}}
