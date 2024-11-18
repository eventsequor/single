functor 
import 
   System(showInfo:Show)
   Open
   StringEder(split:Split replace:Replace strip:Strip)
   Environment(scope:Scope)
   Tree(printTree:PrintTree)
   
define 
   fun {ReadProgram Path}
      % Read the entry file
      {Show "Reading program on path: <" # Path # ">"}
      local F Ls Lines in
         F = {New Open.file init(name:Path flags:[read])}
         {F read(list:Ls)}
         Lines = {Filter {Split Ls "\n"} fun {$ Line} {Length {Split {Replace Line " " ""} " "}} > 0 end}
         {Filter {Map Lines fun {$ L} {Strip L " "} end} fun {$ Line} local H T in H|T = Line ("#" == [H]) == false end end} 
      end      
   end

   proc {PrintProgram Lines}
      {Show "\n========= Starting print the program ======="}
      for Line in Lines do
         {Show Line}
      end
      {Show "============= End of program ===============\n"}
   end
   
   proc {Test1}
      local Path ProgramLines RootScope Functions in
         Path = "programs/program.sl"
         ProgramLines = {ReadProgram Path}
         {PrintProgram ProgramLines}
         RootScope = {New Scope init(ProgramLines)}
         {RootScope executeCallBacks()}
      end
   end

   {Test1}
end 