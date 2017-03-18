fun parse file =
  let
    (* Open input file *)
    val input = TextIO.openIn file
    (* Hocus pocus read an integer *)
    val n = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
    (* Clean the new line after the integer *)
    val garbage = TextIO.inputLine input
    fun read_name 1 acc n = (rev acc, n)
      | read_name i acc n =
        let
	  (* Read two integers *)
          val k = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
          val m = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
          
        in
          read_name (i-1) ([k,m]::acc) n
        end
  in
    read_name n nil n
  end;




fun create l = 
   let
     fun increate 0 z = z
        |increate l z = increate (l-1) (0::z)
   in
     increate l []
   end;




fun increase 1 (z::zs) x = x@[z+1]@zs
   |increase l (z::zs) x = increase (l-1) zs (x@[z]);




fun find_degrees [] z = z
   |find_degrees ([a,b]::xs) (left, right) = 
    find_degrees xs (increase b left [], increase a right [])



fun find_neighbor [] n = 0
   |find_neighbor ([a,b]::xs) n = 
    if (a = n) then b
    else find_neighbor xs n



fun find_zerodeg (0::zs) n = n
   |find_zerodeg (z::zs) n = find_zerodeg zs (n+1)



fun find_nodes tree n nodes (left, right) =
   let
     val m = find_neighbor tree n
   in
   if (m = 0) then nodes  
   else if (List.nth(right, m-1) >= 2) then
     if (List.nth(left, m-1) >= 2) then [m]
     else (m::nodes)
     else 
     if (List.nth(left, m-1) >= 2) then 
      find_nodes tree m [m] (left, right)
     else 
      find_nodes tree m (m::nodes) (left, right)
   end;



fun merge (nil, ys) = ys
  | merge (xs, nil) = xs
  | merge (x::xs, y::ys) =
   if (y > x) then 
     x :: merge (xs, y::ys)
  else 
     y :: merge (x::xs, ys)



 
fun halve nil = (nil, nil)
  | halve [a] = ([a], nil)
  | halve (a::b::cs) =
  let
    val (x, y) = halve cs
  in
    (a::x, b::y)
  end;



fun mergeSort nil = nil
  | mergeSort [a] = [a]
  | mergeSort theList =
  let
    val (x, y) = halve theList
  in
    merge (mergeSort x, mergeSort y)
  end;







fun grafo file =
  let
    val (tree, number) = parse file
    val zeros = create number 
    val degrees = find_degrees tree (zeros, zeros)
    val start = find_zerodeg (#1degrees) 1
  in
    mergeSort (find_nodes tree start [] degrees)
  end;
