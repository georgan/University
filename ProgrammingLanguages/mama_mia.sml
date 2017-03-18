open IntInf




fun puta n a=
   let
     fun myput 0 a z = z
        |myput n a z = myput (n-1) a (a::z)
   in
     myput n a []
   end;



fun encode [] a k = [(k,a)]
   |encode ((n,x)::xs) a k = 
    if (x = a) then ((n+k,x)::xs)
    else ((k,a)::((n,x)::xs))



fun decode z =
   let
     fun helpdecode [] y = y
        |helpdecode ((n,x)::xs) y = helpdecode xs (y @ (puta n x))
   in
     helpdecode z []
   end


fun find_mama a m li hi lo ho z =
    if ((ho >= hi) andalso (li >= lo)) then [z]
    else if ((hi > ho) orelse (hi - li > ho - lo))  then []
    else if (m*(hi - li) > ho - lo) then
       if (ho - hi >= lo - li) then
         let
            val k = (lo - li) div a
         in
         if ((lo - li) mod a = 0) then
            if (ho >= hi + k*a) then [encode z #"A" k]
            else []
         else
           if (ho >= hi + (k+1)*a) then [encode z #"A" (k+1)]
           else []
         end
       else []
    else  (find_mama a m (li*m) (hi*m) lo ho (encode z #"M" 1)) @ (find_mama a m (li+a) (hi+a) lo ho (encode z #"A" 1))




fun add x =
   let
      fun helpadd [] z = z
         |helpadd ((n,x)::xs) z = helpadd xs (z+n)
   in
     helpadd x 0
   end




fun minlength z =
   let
     fun findlength [] z = z
        |findlength (x::xs) [] = findlength xs [x]
        |findlength (x::xs) (z::zs) =
         let
            val m = add x
            val n = add z
         in
         if (m > n) then findlength xs (z::zs)
         else if (n > m) then findlength xs [x]
         else findlength xs (x::(z::zs))
         end
   in
     findlength z []
   end;




fun make_strings x =
    let
      fun helpme [] z = z
         |helpme (x::xs) z = helpme xs ((implode (decode x))::z)
    in
      helpme x []
    end
    

fun merge (nil, ys) = ys
  | merge (xs , nil) = xs
  | merge ((x :string)::xs, y::ys) =
   if (x >= y) then 
     x :: merge (xs, y::ys)
  else 
     y :: merge (x::xs, ys)


 
fun halve nil = (nil, nil)
  | halve [a :string] = ([a], nil)
  | halve (a::b::cs) =
  let
    val (x, y) = halve cs
  in
    (a::x, b::y)
  end;


fun mergeSort nil = nil
  | mergeSort [a :string] = [a]
  | mergeSort theList =
  let
    val (x, y) = halve theList
  in
    merge (mergeSort x, mergeSort y)
  end;



fun mama_mia a 1 li hi lo ho =
    if ((ho >= hi) andalso (li >= lo)) then ""
    else if ((ho > hi) andalso (ho - lo >= hi - li))then
    let
       val d = lo - li
       val k = d div a
    in
      if (d mod a = 0) then
        if (ho >= hi + k*a) then implode ( puta k #"A" )
        else "impossible"
      else 
        if (ho >= hi + (k+1)*a) then implode ( puta (k+1) #"A" )
        else "impossible"
    end
    else "impossible"  
    |mama_mia a m li hi lo ho =
   let
     val solutions = find_mama a m li hi lo ho []
     val min_solution = minlength solutions
     val oh_strings = make_strings min_solution
     val good_solution = mergeSort oh_strings
   in 
     if (solutions = []) then "impossible"
     else implode (rev (explode (hd good_solution)))
   end
