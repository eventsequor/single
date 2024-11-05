functor 
import 
   System(showInfo:Show)
   Open
   StringEder(split:Split)
   Environment(scope:Scope)
   
define 
   F={New Open.file init(name:'program.txt' flags:[read])}
   Ls
   {F read(list:Ls)}
   %for Line in {Split Ls "\n"} do
   %   {Show Line}
   %end
   RootScope = {New Scope init({Split Ls "\n"})}
   Functions 
   {RootScope getFunctions(Functions)}
   for Fun in Functions do Name Exp in
      {Fun getFuncName(Name)}
      {Show "Function name: "#Name}
      {Fun getExpression(Exp)}
      {Show "Get expression: "#Exp}
   end

   Variables
   {RootScope getVariables(Variables)}
   for Var in Variables do Name Expr in
      {Var getName(Name)}
      {Var getExpression(Expr)}
      {Show "Name variable: " # Name}
      {Show "Get Expression: " # Expr}
   end
   
end 