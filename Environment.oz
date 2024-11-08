functor
import
    System(showInfo:Show)
    StringEder(strip:Strip split:Split replace:Replace join:Join)
    Tree(fullFillTree:FullFillTree printTree:PrintTree)
    InfixPrefix(str2Lst:Str2Lst infix2Prefix:Infix2Prefix)  

export
    Scope
    Variable

define
    class Scope
        attr variables functions callbacks instructions

        meth init(ListOfInstructions)
            variables := nil
            functions := nil
            callbacks := nil
            instructions := ListOfInstructions
            
            %Identify variables and functions
            for Instruction in @instructions do Type in
                
                Type = {GetTypes Instruction}
                if Type == var then
                    if @variables == nil then variables := [{New Variable init(Instruction)}] else variables := {Append @variables [{New Variable init(Instruction)}]}end
                end
                
                if Type == callback then 
                    if @callbacks == nil then callbacks := [{New CallBack init(Instruction)}] else callbacks := {Append @callbacks [{New CallBack init(Instruction)}]} end
                end

                if Type == function then
                    if @functions == nil then functions := [{New Function init(Instruction)}] else functions := {Append @functions [{New Function init(Instruction)}]} end
                end
            end
        end

        meth line_evaluator(Line)
            {Show ""}
        end
        meth getFunctions(Return)
            Return = @functions 
        end

        meth getVariables(Return)
            Return = @variables
        end

        meth getCallBakcs(Return)
            Return = @callbacks
        end

        meth executeCallBacks
            {Show "===== Starting callbacks resolution ========"}
            for Call in @callbacks do Expression RootTree XValue in
                {Show "\nNew CallBack"}
                {Call getExpression(Expression)}
                {Show "Expression: " # Expression}
                {Call getTree(RootTree)}
                {self reduceTree(RootTree)}
            end
        end

        meth getXValue(RootTree XValue)
            local RootTree in
                
            end
        end

        meth reduceTree(RootTree)
            local NameOfFunctionsInTree = {NewCell nil} in
                {Show "\n================ RootTree =================="}
                {PrintTree RootTree}
                {self getFunctionInSheets(RootTree NameOfFunctionsInTree)}
                
                for Value in @NameOfFunctionsInTree do
                    {self replaceNameFuncByTree(RootTree Value)}
                end
                
                {Show "\n============== Reduce Tree ================="}
                {PrintTree RootTree}
            end
        end

        meth replaceNameFuncByTree(RootTree FunctionName)
            local LeftValue LeftNode RightValue RightNode in
                % Left node
                {RootTree getLeft(LeftNode)}
                if (LeftNode == nil) == false then
                    {LeftNode getValue(LeftValue)}
                    if LeftValue == FunctionName then Functions LocalFuncs FuncTree in
                        {self getFunctions(Functions)}
                        LocalFuncs = {Filter Functions fun {$ F} local Nm in {F getFuncName(Nm)} Nm == FunctionName  end end}
                        if {Length LocalFuncs} > 0 then Fun in
                            Fun = {Nth LocalFuncs 1}
                            {Fun getTree(FuncTree)}
                            {RootTree setLeft(FuncTree)}
                        end
                    else
                        {self replaceNameFuncByTree(LeftNode FunctionName)}
                    end
                end

                % Right node
                {RootTree getRight(RightNode)}
                if (RightNode == nil) == false then
                    {RightNode getValue(RightValue)}
                    if RightValue == FunctionName then Functions LocalFuncs FuncTree in
                        {self getFunctions(Functions)}
                        LocalFuncs = {Filter Functions fun {$ F} local Nm in {F getFuncName(Nm)} Nm == FunctionName  end end}
                        if {Length LocalFuncs} > 0 then Fun in
                            Fun = {Nth LocalFuncs 1}
                            {Fun getTree(FuncTree)}
                            {RootTree setRight(FuncTree)}
                        end
                    else
                        {self replaceNameFuncByTree(RightNode FunctionName)}
                    end
                end

            end
        end

        meth getFunctionInSheets(Tree Return)
            local Value LeftNode RightNode Functions in
                {Tree getValue(Value)}
                {Tree getLeft(LeftNode)}
                {Tree getRight(RightNode)}
                {self getFunctions(Functions)}
                if {Member Value {Map Functions fun {$ F} local Name in {F getFuncName(Name)} Name end end}} then
                    if @Return == nil then Return := [Value] else Return := {Append @Return [Value]} end
                end
                if (LeftNode == nil) == false then
                    {self getFunctionInSheets(LeftNode Return)}
                end
                if (RightNode == nil) == false then
                    {self getFunctionInSheets(RightNode Return)}
                end
            end
            
        end
    end    

    class CallBack
        attr name expression

        meth init(Instruction)
            name := {GetNameCallBack Instruction}
            expression := Instruction
        end

        meth getName(Return)
            Return = @name
        end
    
        meth getExpression(Return)
            Return = @expression
        end

        meth getTree(Return)
            Return = {FullFillTree @expression}
        end
    end

    class Variable
        attr name expression
        meth init(Instruction) 
            if {Length {Split Instruction " "}} == 1 then
                name := Instruction
                expression := ""
            else
                name := {GetNameVariableOrFunction Instruction}
                expression := Instruction
                local T Expression in
                    _|T = {Split Instruction "="}
                    {VirtualString.toString {FoldL T fun {$ X Y} X#"="#Y end ""} ?Expression}
                    expression := {Strip {Strip Expression "="} " "}
                end
            end
        end

        meth getName(Return)
            Return = @name
        end

        meth getExpression(Return)
            Return = @expression
        end
    end

    class Function
        attr name args expression
        meth init(Line)
            name := {GetNameVariableOrFunction Line}
            args := nil
            
            for Arg in {GetArgs Line} do
                if @args == nil then
                    args := [{New Variable init(Arg)}]
                else
                    args := {Append @args [{New Variable init(Arg)}]}
                end
            end

            local T Expression in
                _|T = {Split Line "="}
                {VirtualString.toString {FoldL T fun {$ X Y} X#"="#Y end ""} ?Expression}
                expression := {Strip {Strip Expression "="} " "}
            end
        end

        meth getArgs(Return)
            Return = @args
        end

        meth getExpression(Return)
            Return = @expression
        end

        meth getFuncName(Return)
            Return = @name
        end

        meth getTree(Return)
            Return = {FullFillTree {Join {Infix2Prefix {Str2Lst @expression}} " "}}
        end        
    end

    fun {GetTypes Line}
        local Type in
            Type = {Nth {Split {Replace Line "  " " "} " "} 1}
            if Type == "var" then
                var
            elseif Type == "fun" then
                function
            elseif (Type == "var") == false andthen (Type == "fun") == false then
                callback
            end
        end
    end

    fun {GetArgs Function}
        {Split {Strip {Replace {Replace {Nth {Split {Replace Function "  " " "} "="} 1} "fun " ""} {GetNameVariableOrFunction Function} ""} " "}" "}
    end

    fun {GetNameCallBack Line}
        local Name Out in 
            Name = {Nth {Split {Strip Line " "} " "} 1}
            {VirtualString.toString Name ?Out}
            Out
        end
    end

    fun {GetNameVariableOrFunction Line}
        local Name Out in
            Name = {Nth {Split {Replace Line "  " " "} " "} 2}
            {VirtualString.toString Name ?Out}
            {Strip Out " "}
        end
    end
end