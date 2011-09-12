(* Integer distance matrices *)

let create collec =
  DistMat.mk_dist Genotype.diff collec.Genotypes.genos

let get m i j =
  if i = j then 0
  else DistMat.get m i j

let empty length =
  DistMat.create length 0

(* Float distance matrices *)

let createF collec =
  let genos = collec.Genotypes.genos in
  DistMat.init
    collec.Genotypes.size
    (fun i j -> float_of_int (Genotype.diff genos.(i) genos.(j)))

let emptyF length =
  DistMat.create length 0.
    
let getF m i j =
  if i = j then 0.0
  else DistMat.get m i j

let toFloat m =
  DistMat.map float_of_int m

let createP collec =
  let m = createF collec in
  DistMat.modif
    (fun x -> x *. 100. /. float_of_int(collec.Genotypes.geno_size))
    m;
  m

let print matrix =
  let printLine line =
    Array.iter (Printf.printf "-%3d ") line;
    Printf.printf "\n"
  in Array.iter printLine matrix

let printF matrix =
  let length = Array.length matrix in
  for i=0 to length - 1 do
    for j=0 to i-1  do
      Printf.printf "%-3.1f " matrix.(i).(j)
    done;
    Printf.printf "\n"
  done
