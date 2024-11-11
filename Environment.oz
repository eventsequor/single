functor
import
    System(showInfo:Show)
    StringEder(strip:Strip split:Split replace:Replace join:Join)
    Tree(fullTreeFromFunction:FullTreeFromFunction fullTreeFromCallBack:FullTreeFromCallBack printTree:PrintTree containsAnyElement:ContainsAnyElement)
    InfixPrefix(str2Lst:Str2Lst infix2Prefix:Infix2Prefix)
    Operator(resolve:Resolve)

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

        meth getFunctionNames(Return)
            local Functions in
                {self getFunctions(Functions)}
                Return = {Map Functions fun {$ F} local Name in {F getFuncName(Name)} Name end end}
            end
        end

        meth getVariables(Return)
            Return = @variables
        end

        meth getCallBakcs(Return)
            Return = @callbacks
        end

        meth executeCallBacks
            {Show "===== Starting callbacks resolution ========"}
            for Call in @callbacks do Expression RootTree XValue FuncNamesList in
                {Show "\nNew CallBack"}
                {Call getExpression(Expression)}
                {Show "Expression: " # Expression}

                {self getFunctionNames(FuncNamesList)}
                {Call getTree(FuncNamesList RootTree)}
                {PrintTree RootTree}
                {self reduceTree(RootTree)}
            end
        end

        meth reduceTree(RootTree)
            local NameOfFunctionsInTree = {NewCell nil} ListArgs = {NewCell nil} in
                {Show "\n================ RootTree =================="}
                {PrintTree RootTree}
                {self getFunctionInSheets(RootTree NameOfFunctionsInTree)}
                
                for Value in @NameOfFunctionsInTree do
                    {self replaceNameFuncByTree(RootTree Value)}
                end
                
                {Show "\n============== Reduce Tree ================="}
                {PrintTree RootTree}

                {Show "\n============== Resolution =================="}
                {self resolveTree(RootTree ListArgs)}
                {PrintTree RootTree}
            end
        end

        meth resolveTree(RootTree ListArgs)
            {self reducer(RootTree)}
            
        end

        meth reducer(RootTree)
            local Answer = {NewCell false} in 
                {self checkItNumericTree(RootTree Answer)}
                if @Answer then 
                    {self reduceNumericFunctions(RootTree)} 
                    {self reducer(RootTree)} 
                end
            end
        end

        meth reduceNumericFunctions(RootTree)   
            if (RootTree == nil) == false then RootValue LeftNode LeftValue RightNode RightValue in
                {RootTree getValue(RootValue)}
                {RootTree getLeft(LeftNode)}
                {RootTree getRight(RightNode)}
                if RootValue == "@" andthen (LeftNode == nil) == false andthen (RightNode == nil) ==false then LeftValue RightValue in
                    {LeftNode getValue(LeftValue)}
                    {RightNode getValue(RightValue)}
                    if {ContainsAnyElement LeftValue ["*" "/" "+" "-"]} andthen RightValue == "@" then SubRightNode SubLeftNode in
                        {RightNode getLeft(SubLeftNode)}
                        {RightNode getRight(SubRightNode)}
                        if (SubRightNode == nil) == false andthen (SubLeftNode == nil) == false then LeftValueSub RightValueSub in
                            {SubLeftNode getValue(LeftValueSub)}
                            {SubRightNode getValue(RightValueSub)}
                            if {IsNumber LeftValueSub} andthen {IsNumber RightValueSub} then NewValue in
                                NewValue = {Resolve {StringToNumber LeftValueSub} LeftValue {StringToNumber RightValueSub}}
                                {RootTree setValue({FloatToString NewValue})}
                                {RootTree setLeft(nil)}
                                {RootTree setRight(nil)}
                            end
                        end
                    end
                end
                {self reduceNumericFunctions(LeftNode)}
                {self reduceNumericFunctions(RightNode)}
            end
        end

        meth checkItNumericTree(RootTree Answer)
            if RootTree == nil then
                Answer := false
            else
                local RootValue LeftNode LeftValue RightNode RightValue in
                    {RootTree getValue(RootValue)}
                    {RootTree getLeft(LeftNode)}
                    {RootTree getRight(RightNode)}
                    if RootValue == "@" andthen (LeftNode == nil) == false andthen (RightNode == nil) == false then LeftValue RightValue in
                        {LeftNode getValue(LeftValue)}
                        {RightNode getValue(RightValue)}
                        if {IsNumber LeftValue} andthen {IsNumber RightValue} then
                            Answer := true
                        end
                    end
                    if @Answer == false then
                        {self checkItNumericTree(LeftNode Answer)}
                        {self checkItNumericTree(RightNode Answer)}
                    end
                end
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
                        if {Length LocalFuncs} > 0 then Fun Variables in
                            Fun = {Nth LocalFuncs 1}
                            {Fun getTree(FuncTree)}
                            {Fun getArgs(Variables)} % Get arguments from functions this is a definition
                            {FuncTree setVariablesInfo(Variables)} % The variables represent the arguments that contains a tree

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

        meth getTree(FuncNamesList Return)
            Return = {FullTreeFromCallBack FuncNamesList @expression}
        end
    end

    class Variable
        attr name expression value
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

        meth getValue(Return)
            Return := @value
        end

        meth setValue(NewValue)
            value := NewValue
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
            Return = {FullTreeFromFunction @expression}
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

    fun {IsNumber Input}
        local Value ValueToEvaluate in
            ValueToEvaluate = {Strip Input " "}
                Value = if {IsString ValueToEvaluate} then
                            try {StringToInt ValueToEvaluate} catch X then try {StringToFloat ValueToEvaluate} catch Y then ValueToEvaluate end end 
                        else 
                            ValueToEvaluate 
                        end
                if {IsInt Value} then true elseif {IsFloat Value} then true else false end                       
        end
    end

    fun {StringToNumber Input}
        try {StringToInt Input} catch X then try {StringToFloat Input} catch Y then Input end end         
    end
end