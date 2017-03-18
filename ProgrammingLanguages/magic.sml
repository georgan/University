open IntInf



fun create n =
   let
      fun creat(1,z) = 1::z :int list
         |creat(n,z) = creat(n-1,0::z)
    in
     creat(n,nil)
    end;


fun apply ((_::xs),1,n) = (n::xs)
   |apply ((x::xs),i,n) = x::(apply (xs,i-1,n))


fun reverse xs = 
   let 
      fun rev (nil,z) = z
         |rev (y::ys,z) = rev(ys,y::z)
   in
   rev(xs,nil)
end;


fun nth ((x::xs),1) = x
   |nth ((x::xs),n) = nth (xs,n-1) 


fun substract (0,list,B,cuury) = nil 
   |substract (i,list,B,curry) =
   let
    val revlist = reverse(list)
   in
    if (nth(list, i) > nth(revlist, i)) then
       substract (i-1,list,B,0) @ [nth(list, i) - nth(revlist, i) - curry]
    else if (nth(revlist, i) > nth(list, i)) then
       substract (i-1,list,B,1) @ [nth(list, i) - nth(revlist, i) + B - curry]
    else
      if curry = 1 then
         substract(i-1,list,B,1) @ [B-1]
      else 
         substract(i-1,list,B,0) @ [0]
   end;


fun pow (nil, b) = 0
   |pow ((x::xs), b) = (pow (xs, b))*b + x
   

fun merge (nil, ys) = ys
  | merge (xs, nil) = xs
  | merge (x::xs, y::ys) =
   if (x > y) then 
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


fun    next_number (alist, 1, b, n) = 
       if (hd(alist) < (b-1) ) then
         (apply (alist, 1, hd(alist)+1), 1) 
       else 
         (nil, 0) 
    |next_number (alist, i, b, n) = 
       if (i = (n div 2)+1) then
         next_number (alist, i-1, b, n)
       else if (nth(alist, i) < nth(alist, i-1)) then
         (apply (alist, i, nth(alist, i)+1), i)
       else 
       
         next_number (apply (alist, i, 0), i-1, b, n)
 


      

fun find (nil, b, n, pos) = [0]
   |find (alist, b, n, pos) = 
    let 
       val result = substract(n, alist, b, 0)
       val sort_result = mergeSort(result)
       val new_result = substract(n, sort_result, b, 0)
       val next = next_number (alist, pos+1, b, n)
    in 
    if (new_result = result) then
       result
         
     else
        
          find (#1next, b, n, #2next)
        
      
     end;   
    


fun magic b n = 
   let
     val begin = create n
   in
     pow(reverse(find (begin, b, n, 1)), b)
   end;

