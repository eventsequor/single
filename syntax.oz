functor 
import 
   System(showInfo:Show)
   Open
   
define 
   F={New Open.file init(name:'program.txt' flags:[read])}
   Ls
   {F read(list:Ls)}
   {Show Ls}

   fun 
end 