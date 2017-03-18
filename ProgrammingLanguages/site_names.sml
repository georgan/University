fun parse file =
  let
    (* Open input file *)
    val input = TextIO.openIn file
    (* Hocus pocus read an integer *)
    val n = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
    (* Clean the new line after the integer *)
    val garbage = TextIO.inputLine input
    fun read_name 0 acc = rev acc
      | read_name i acc =
        let
	  (* Read a string *)
          val rawName = Option.valOf (TextIO.inputLine input)
	  (* Remove the \n in the end of the line *)
          val name =  (rev (tl (rev (explode rawName))))
        in
          read_name (i-1) (name::acc)
        end
  in
    read_name n nil
  end




fun synthesis (nil, length) = nil
   |synthesis (y::ys, length) = (y, length):: synthesis (ys, length+1)




fun putit (nil, x, length) = (nil, x, length)
   |putit (y, nil, length)  = (y, nil, length)
   |putit (y::ys, x::xs, length) = 
   if (y = #1x) then
    let
       val make = putit (ys, xs, length+1)
    in
      (#1make, (#1x, #2x+length)::(#2make), #3make)
    end
   else
    (y::ys, x::xs, length-1)




fun deeput (nil, x, length) = x
   |deeput (y, nil, length) = [synthesis (y, length)]
   |deeput (y, x::xs, length) =
   if (List.nth(y, 0) = #1(List.nth(x, 0))) then
    let
       val (newy, newx, l) = putit (y, x, length)
    in
      [newx] @ deeput (newy, xs, l+1)
    end
   else
    [x] @ deeput (y, xs, length)




fun put (y, nil, z) = z @ [[synthesis (y, 1)]]
   |put (y, x::xs, z) = 
   if (List.nth(y, 0) = #1(List.nth(List.nth(x, 0), 0)) ) then 
    let
       val putin = deeput (y, x, 1)
    in
      z @ [putin] @ xs
    end
   else
    put (y, xs, z @ [x])



fun operate (nil, x) = x
   |operate (y::ys, x) = 
   let
      val new = put (y, x, nil)
   in 
      operate (ys, new)
   end;

fun max (nil, m) = m
   |max (x::xs, m) = 
   let
      fun maxim (nil, m) = m
         |maxim (x::xs, m) = 
         let 
            fun maximum (nil, m) = m
               |maximum ((x1,x2)::xs, m) = 
               if (m < x2) then
                 maximum (xs, x2)
               else
                 maximum (xs, m)
         in
            maxim (xs, maximum(x, m))
         end
   in
      max (xs, maxim (x, m))
   end



fun site_names file = 
   let
      val readlist = parse file
   in
      max (operate(readlist, nil), 0)
   end 
   



