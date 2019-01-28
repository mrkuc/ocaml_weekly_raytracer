open Base
module Out = Stdio.Out_channel
module Vec3 = Raylib.Vec3
module Ray = Raylib.Ray

let nx = 200
let ny = 100
let output_file_name = "output.ppm"

let color r =
  let unit_direction = Vec3.unit_vector (Ray.direction r) in
  let t = 0.5 *. ((Vec3.y unit_direction) +. 1.0) in
  let a = 1.0 -. t in
  let open Vec3 in
  ((Vec3.create 1.0 1.0 1.0) *. a) + ((Vec3.create 0.5 0.7 1.0) *. t)

let get_ray origin lower_left_corner horizontal vertical u v =
  let open Vec3 in
  Ray.create origin (lower_left_corner + (horizontal *. u) + (vertical *. v))

(* 1ピクセル分を描画する *)
(* Out_channel.t -> int -> int -> unit *)
let render chan x y =
  let lower_left_corner = Vec3.create (-2.0) (-1.0) (-1.0) in
  let horizontal = Vec3.create 4.0 0.0 0.0 in
  let vertical = Vec3.create 0.0 2.0 0.0 in
  let origin = Vec3.create 0.0 0.0 0.0 in
  let u = (Int.to_float x) /. (Int.to_float nx) in
  let v = (Int.to_float y) /. (Int.to_float ny) in
  let r = get_ray origin lower_left_corner horizontal vertical u v in
  let col = color r in
  let (r, g, b) = Vec3.xyz col in
  begin
    Out.output_string
      chan
      ((Int.to_string (Float.to_int (255.99 *. r))) ^ " " ^
         (Int.to_string (Float.to_int (255.99 *. g))) ^ " " ^
           (Int.to_string (Float.to_int (255.99 *. b))));
    Out.newline chan;
  end

(* MAIN *)
let () =
  let chan = Out.create output_file_name
  in begin
      Out.print_endline "start...";
      Out.output_string chan ("P3\n" ^ (Int.to_string nx) ^ " " ^ (Int.to_string ny) ^ "\n255\n");
      List.iter (List.rev (List.range 0 ny))
                ~f:(fun y ->
                  List.iter (List.range 0 nx)
                            ~f:(fun x -> render chan x y));
      Out.close chan;
      Out.print_endline "complete!";
    end
   


