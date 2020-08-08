open Core

let int16_to_words, words_to_int16 =
  let blocked_character_re = Re2.create_exn "([0-9]+|[A-Z]+|\\.|@|[ \t]+|')" in
  let cond str =
    String.length str > 5
    && String.length str < 8
    && not @@ Re2.matches blocked_character_re str in
  [%blob "./words.txt"]
  |> String.split_lines
  |> List.filter ~f:cond
  |> (fun ls -> List.to_array ls, List.mapi ls ~f:(fun i v -> (v,i)) |> Map.of_alist_exn (module String))
  |> (fun (f,g) ->
      (fun ind -> f.(ind)), (fun word -> Map.find g word))


let ip_to_funip (ip: Ipaddr.V4.t) : unit =
  let first,second = Ipaddr.V4.to_int16 ip in
  let funip = int16_to_words first ^ "." ^ int16_to_words second in
  print_endline (Printf.sprintf "%s" funip)

let funip_to_ip (funip: string) : unit =
  match String.split funip ~on:'.' with
  | [first; second] ->
    let first,second = words_to_int16 first, words_to_int16 second in
    begin match first,second with
    | Some a, Some b when Int.(a < Int.pow 2 16) && Int.(b < Int.pow 2 16) ->
      let ip = Ipaddr.V4.of_int16 (a, b) in
      print_endline (Ipaddr.V4.to_string ip)
    | _ ->
      Printf.printf "Invalid funip format %s - use of unrecognised words." funip;
      exit (-1)
    end
  | _ ->
    Printf.eprintf "Invalid funip format %s - expecting two words separated by a single dot.\n" funip;
    exit (-1)


let () =
  let main_command =
    let open Command.Let_syntax in
    let ip_to_funip_command =
      Command.basic
        ~summary:"Convert an ipv4-address to a funip format."
        [%map_open
          let ip_addr = anon ("ip_address" %: Command.Arg_type.create Ipaddr.V4.of_string_exn) in
          fun () -> ip_to_funip ip_addr
        ] in
    let funip_to_ip_command =
      Command.basic
        ~summary:"Convert a funip to ipv4-address format."
        [%map_open
          let ip_addr = anon ("funip_address" %: string) in
          fun () -> funip_to_ip ip_addr
        ] in
    Command.group
      ~summary:"Convert between funips and ipv4 addresses."
      [
        "funip-to-ip", funip_to_ip_command;
        "ip-to-funip", ip_to_funip_command
      ]
  in
  Command.run main_command
