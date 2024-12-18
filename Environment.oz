functor
import
    System(showInfo:Show print:Print)
    StringEder(join:Join strip:Strip split:Split replace:Replace contains:Contains)
    Tree(addNodeToRightEnd:AddNodeToRightEnd reduceTree:ReduceTree isAnyElementIn:IsAnyElementIn resolvePendingFunc:ResolvePendingFunc isNumber:IsNumber fullTreeFromFunction:FullTreeFromFunction fullTreeFromCallBack:FullTreeFromCallBack printTree:PrintTree containsAnyElement:ContainsAnyElement)
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

        meth getFunctions(Return)
            Return = @functions 
        end

        meth getFunctionNames(Return)
            local Functions in
                {self getFunctions(Functions)}
                Return = {Map Functions fun {$ F} local Name in {F getFuncName(Name)} Name end end}
            end
        end

        meth getFunctionExpressionArgs(FunctionName Return)
            local Functions Found in
                {self getFunctions(Functions)}
                Found = {Filter Functions fun {$ F} local Name in {F getFuncName(Name)} FunctionName == Name end end}
                if (Found == nil) == false andthen {Length Found} > 0 then
                    {{Nth Found 1} getExpressionArgs(Return)}
                else
                    Return = nil
                end
            end
        end

        meth getFunctionParameter(FunctionName Return)
            local Functions Result in
                {self getFunctions(Functions)}
                Result = {Filter Functions fun {$ F} local FunNam in {F getFuncName(FunNam)} FunNam == FunctionName end end}
                if {Length Result} > 0 then
                    {{Nth Result 1} getArgs(Return)}
                else
                    Return = nil
                end
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
            for Call in @callbacks do Expression RootTree FuncNamesList in
                {Show "\nNew CallBack"}
                {Call getExpression(Expression)}

                {self getFunctionNames(FuncNamesList)}
                {Call getTree(FuncNamesList RootTree)}
                {self reduceTree(RootTree FuncNamesList)}
            end
        end

        meth reduceTree(RootTree FuncNamesList)
            {Show "\n================ RootTree =================="}
            {PrintTree RootTree}
            
            {self replaceNameByItsFun(RootTree FuncNamesList)}

            {Show "\n============== Reduce tree =================="}
            {self reducer(RootTree)}
            {PrintTree RootTree}

            
            {self resolveFunction(RootTree)}

            {Show "\n============== Final Result ================="}
            {PrintTree RootTree}
        end

        meth replaceNameByItsFun(RootTree FuncNamesList)
            local NameOfFunctionsInTree = {NewCell nil} in
                {self getFunctionInSheets(RootTree NameOfFunctionsInTree)}
                if {Length @NameOfFunctionsInTree} > 0 then
                    {Show "\n===== Replace names func by its tree ========"}
                    for Value in @NameOfFunctionsInTree do FunctionNames VariableList in
                        {self replaceNameFuncByTree(RootTree Value)}
                        {self getFunctionNames(FunctionNames)}
                        {self getFunctionExpressionArgs(Value VariableList)}

                        if (VariableList == nil) == false andthen {Length VariableList} > 0 then
                            {self replaceVariableValue(RootTree VariableList)}              
                            {ReduceTree RootTree}      
                        end
                    end
                    {ResolvePendingFunc FuncNamesList RootTree}
                    {PrintTree RootTree}
                    {self replaceNameByItsFun(RootTree FuncNamesList)}
                end
            end
        end
        

        meth resolveFunction(RootTree)
            {Show "\n=========== Replace Argument ==============="}
            % This function replace the argmentes into the function trees
            {self functionArgReplacement(RootTree)}

            % This function replace the arguments into the any kind of tree
            {self functionArgReplacement2(RootTree)}
            {PrintTree RootTree}
            

            {Show "\n=========== And Reduce tree ================"}
            {self reducer(RootTree)}
            {self checkIfTheAnswerIsInRight(RootTree)}
            {PrintTree RootTree}
            local FunctionNames in 
                {self getFunctionNames(FunctionNames)}
                if {IsAnyFunctionToResolveInTree RootTree FunctionNames} then
                   {self resolveFunction(RootTree)}
                end
            end
        end

        meth checkIfTheAnswerIsInRight(RootTree)
            if (RootTree == nil) == false then
                local LeftNode RightNode SubLeftNode SubRightNode RightValue in
                    {RootTree getLeft(LeftNode)}
                    {RootTree getRight(RightNode)}
                    if LeftNode == nil andthen (RightNode == nil) == false then
                        {RightNode getLeft(SubLeftNode)}
                        {RightNode getRight(SubRightNode)}
                        {RightNode getValue(RightValue)}
                        
                        if LeftNode == nil 
                        andthen (RightNode == nil) == false 
                        andthen {IsNumber RightValue} 
                        andthen SubLeftNode == nil
                        andthen SubRightNode == nil
                        then
                            {RootTree setValue(RightValue)}
                            {RootTree setRight(nil)}
                        end
                    end
                end
            end
        end

        meth getContantAndRemoveSheet(RootTree ValuesList)
            if (RootTree == nil) == false then
                local Value RightNode in
                    {RootTree getValue(Value)}
                    if (Value == "@") == false then
                        if @ValuesList == nil then
                            ValuesList := [Value]
                        else
                            ValuesList := {Append @ValuesList [Value]}
                        end
                        {RootTree getRight(RightNode)}
                        {self getContantAndRemoveSheet(RightNode ValuesList)}
                    end                    
                end
            end
        end

        meth replaceVariableValue(RootTree VariableList)
            if (RootTree == nil) == false andthen (VariableList == nil) == false then
                local Value Result RightNode LeftNode in
                    {RootTree getValue(Value)}
                    Result = {Filter VariableList fun {$ Var} local VarName in {Var getName(VarName)} Value == VarName end end}
                    if (Result == nil) == false then Variable VariableValue in
                        Variable = {Nth Result 1}
                        {Variable getValue(VariableValue)}
                        if (VariableValue == nil) == false then {RootTree setValue({Strip VariableValue " "})} end
                    end
                    {RootTree getLeft(LeftNode)}
                    {RootTree getRight(RightNode)}

                    {self replaceVariableValue(LeftNode VariableList)}
                    {self replaceVariableValue(RightNode VariableList)}
                end
            end
        end

        meth replaceVariableValueInFunctions(FunctionNames RootTree VariableList Result)
            if (RootTree == nil) == false then ReplaceProc in
                ReplaceProc = proc {$ RootTree} 
                    local Value Result LeftNode RightNode in
                        {RootTree getValue(Value)}
                        Result = {Filter VariableList fun {$ Var} local VarName in {Var getName(VarName)} Value == VarName end end}
                        if (Result == nil) == false then Variable VariableValue in
                            Variable = {Nth Result 1}
                            {Variable getValue(VariableValue)}
                            if (VariableValue == nil) == false then {RootTree setValue(VariableValue)} end
                        end
                    end                
                end

                local LeftNode RightNode in
                    {RootTree getLeft(LeftNode)}
                    {RootTree getRight(RightNode)}
                    if (LeftNode == nil) == false andthen (RightNode == nil) == false then FunctionName RightValue in
                        {LeftNode getFunctionName(FunctionName)}
                        {RightNode getValue(RightValue)}
                        if {ContainsAnyElement FunctionName FunctionNames} andthen {IsNumber RightValue} then
                            {ReplaceProc RightNode}
                            Result := true
                        end
                        {self replaceVariableValueInFunctions(FunctionNames LeftNode VariableList Result)}
                        {self replaceVariableValueInFunctions(FunctionNames RightNode VariableList Result)}
                    end
                end
            end
        end

        meth matchVariable(VariableList ValuesList)
            local Counter = {NewCell 1} in
                for Variable in VariableList do
                    if @Counter < ({Length VariableList} + 1) then
                        {Variable setValue({Nth ValuesList @Counter})}
                        Counter := @Counter + 1
                    end
                end
            end
        end

        meth functionArgReplacement(RootTree)
            if (RootTree == nil) == false then
                local Value FunctionName RightNode RightValue LeftNode FunctionNames in
                    {RootTree getValue(Value)}

                    {RootTree getLeft(LeftNode)}
                    {RootTree getRight(RightNode)}

                    if (LeftNode == nil) == false andthen (RightNode == nil) == false then LeftValue RightValue in
                        {LeftNode getFunctionName(FunctionName)}
                        {self getFunctionNames(FunctionNames)}
                        {RightNode getValue(RightValue)}
                        {LeftNode getValue(LeftValue)}

                        if ({IsNumber LeftValue} andthen {IsNumber RightValue}) == false then
                            if Value == "@" andthen {ContainsAnyElement RightValue ["*" "/" "+" "-" "@" " "]} == false andthen {ContainsAnyElement FunctionName FunctionNames} then VariableList in
                                {self getFunctionParameter(FunctionName VariableList)}                                
                                if (VariableList == nil) == false then ValuesList = {NewCell nil} FunctionNameLeft SubRigh2 Result = {NewCell false} in
                                    
                                    {self getContantAndRemoveSheet(RightNode ValuesList)}    

                                    if {Length @ValuesList} >= {Length VariableList} then NodeIsNoVariable in

                                        NodeIsNoVariable = {LookForLastRightNode RightNode 1 {Length VariableList}}

                                        {self matchVariable(VariableList @ValuesList)}                                    
                                        {self replaceVariableValueInFunctions(FunctionNames LeftNode VariableList Result)}
                                        if @Result then
                                            local LeftValue SubLeftNode SubRightNode in    
                                                {LeftNode getValue(LeftValue)}
                                                
                                                {LeftNode getLeft(SubLeftNode)}
                                                {LeftNode getRight(SubRightNode)}

                                                {AddNodeToRightEnd SubRightNode NodeIsNoVariable}
            
                                                {RootTree setValue(LeftValue)}
                                                {RootTree setLeft(SubLeftNode)}
                                                {RootTree setRight(SubRightNode)}
                                            end      
                                        end
                                    end
                                    %==========                                                                                                 
                                end
                            end                            
                        end
                    end

                    % Recursive call
                    {self functionArgReplacement(LeftNode)}     
                    {self functionArgReplacement(RightNode)}
                end
            end
        end

        meth functionArgReplacement2(RootTree)
            if (RootTree == nil) == false then
                local Value FunctionName RightNode RightValue LeftNode FunctionNames in
                    {RootTree getValue(Value)}

                    {RootTree getLeft(LeftNode)}
                    {RootTree getRight(RightNode)}

                    if (LeftNode == nil) == false andthen (RightNode == nil) == false then LeftValue RightValue in
                        {LeftNode getFunctionName(FunctionName)}
                        {self getFunctionNames(FunctionNames)}
                        {RightNode getValue(RightValue)}
                        {LeftNode getValue(LeftValue)}

                        if ({IsNumber LeftValue} andthen {IsNumber RightValue}) == false then
                            if Value == "@" andthen {ContainsAnyElement RightValue ["*" "/" "+" "-" "@" " "]} == false andthen {ContainsAnyElement FunctionName FunctionNames} then VariableList in
                            
                                {self getFunctionParameter(FunctionName VariableList)}
                                if (VariableList == nil) == false then ValuesList = {NewCell nil} FunctionNameLeft SubRigh2 in
                                    {self getContantAndRemoveSheet(RightNode ValuesList)}

                                    if {Length @ValuesList} >= {Length VariableList} then NodeIsNoVariable in

                                        NodeIsNoVariable = {LookForLastRightNode RightNode 1 {Length VariableList}}
                                        {self matchVariable(VariableList @ValuesList)}
                                        {self replaceVariableValue(LeftNode VariableList)}
                                        
                                        local LeftValue SubLeftNode SubRightNode in    
                                            {LeftNode getValue(LeftValue)}
                                            
                                            {LeftNode getLeft(SubLeftNode)}
                                            {LeftNode getRight(SubRightNode)}

                                            {AddNodeToRightEnd SubRightNode NodeIsNoVariable}
        
                                            {RootTree setValue(LeftValue)}
                                            {RootTree setLeft(SubLeftNode)}
                                            {RootTree setRight(SubRightNode)}
                                        end
                                    end
                                    %===========
                                end
                            end                            
                        end
                    end

                    % Recursive call
                    {self functionArgReplacement2(LeftNode)}     
                    {self functionArgReplacement2(RightNode)}
                end
            end
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
            if (RootTree == nil) == false then RootValue LeftNode RightNode in
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
                            if {IsNumber LeftValueSub} andthen {IsNumber RightValueSub} then NewValue SubRightNode2 in
                                NewValue = {Resolve {StringToNumber LeftValueSub} LeftValue {StringToNumber RightValueSub}}
                                {RootTree setValue({FloatToString NewValue})}
                                {SubRightNode getRight(SubRightNode2)}
                                {RootTree setLeft(nil)}
                                {RootTree setRight(SubRightNode2)}
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
                local RootValue LeftNode RightNode in
                    {RootTree getValue(RootValue)}
                    {RootTree getLeft(LeftNode)}
                    {RootTree getRight(RightNode)}
                    if RootValue == "@" andthen (LeftNode == nil) == false andthen (RightNode == nil) == false then RightValue in
                        {RightNode getValue(RightValue)}
                        if RightValue == "@" then SubLeftNode SubRightNode in
                            {RightNode getLeft(SubLeftNode)}
                            {RightNode getRight(SubRightNode)}
                            if (SubLeftNode == nil) == false andthen (SubRightNode == nil) == false then SubRightValue SubLeftValue in
                                {SubLeftNode getValue(SubLeftValue)}
                                {SubRightNode getValue(SubRightValue)}
                                if {IsNumber SubLeftValue} andthen {IsNumber SubRightValue} then
                                    Answer := true
                                end
                            end
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
                {RootTree getLeft(LeftNode)}
                {RootTree getRight(RightNode)}

                % Left node                
                if (LeftNode == nil) == false then FunctionName in
                    {LeftNode getFunctionName(FunctionName)}
                    {LeftNode getValue(LeftValue)}
                    if LeftValue == FunctionName then Functions LocalFuncs FuncTree in
                        {self getFunctions(Functions)}
                        LocalFuncs = {Filter Functions fun {$ F} local Nm in {F getFuncName(Nm)} Nm == FunctionName  end end}
                        if {Length LocalFuncs} > 0 then Fun FuncNamesList in
                            Fun = {Nth LocalFuncs 1}

                            {self getFunctionNames(FuncNamesList)}
                            {Fun getTree(FuncNamesList FuncTree)}

                            {FuncTree setFunctionName(FunctionName)}
                            {RootTree setLeft(FuncTree)}
                        end
                    end
                    {self replaceNameFuncByTree(LeftNode FunctionName)}
                end

                % Right node                
                if (RightNode == nil) == false then FunctionName in
                    {RightNode getFunctionName(FunctionName)}
                    {RightNode getValue(RightValue)}
                    if RightValue == FunctionName then Functions LocalFuncs FuncTree in
                        {self getFunctions(Functions)}
                        LocalFuncs = {Filter Functions fun {$ F} local Nm in {F getFuncName(Nm)} Nm == FunctionName  end end}
                        if {Length LocalFuncs} > 0 then Fun FuncNamesList in
                            Fun = {Nth LocalFuncs 1}

                            {self getFunctionNames(FuncNamesList)}
                            {Fun getTree(FuncNamesList FuncTree)}

                            {FuncTree setFunctionName(FunctionName)}
                            {RootTree setRight(FuncTree)}
                        end
                    end
                    {self replaceNameFuncByTree(RightNode FunctionName)}
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

    fun {LookForLastRightNode RootNode Number Level} 
        if Number =< Level then RightN NewLevel in
            {RootNode getRight(RightN)}
            NewLevel = (Number + 1)
            {LookForLastRightNode RightN NewLevel Level}
        else
            RootNode
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
                name := {Strip Instruction " "}
                expression := ""
                value := nil
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
            Return = @value
        end

        meth setValue(NewValue)
            value := NewValue
        end
    end

    class Function
        attr name args expression expressionArgs
        meth init(Line)
            name := {GetNameVariableOrFunction Line}
            args := nil
            expressionArgs := nil
            for Arg in {GetArgs Line} do
                if @args == nil then
                    args := [{New Variable init(Arg)}]
                else
                    args := {Append @args [{New Variable init(Arg)}]}
                end
            end

            local T in
                _|T = {Split Line "="}
                {self checkFunction({Strip {Join T "="} " "})}
            end
        end

        meth getExpressionArgs(Return)
            Return = @expressionArgs
        end

        meth checkFunction(Expression)
            {Show "what is the expr " # Expression}
            if {Contains Expression "in"} then H T Variables in
                H|T = {Split Expression "in"}
                expression := {Strip {Join T ""} " "}
                for Var in {Filter {Split H "var"} fun {$ V} {Contains V "="} end} do H T VarNam VarValue in
                    H|T = {Split Var "="}
                    VarNam = H
                    VarValue = {Join T ""}
                    if @expressionArgs == nil then Arg in
                        Arg = {New Variable init(VarNam)}
                        {Arg setValue(VarValue)}
                        expressionArgs := [Arg]
                    else Arg in
                        Arg = {New Variable init(VarNam)}
                        {Arg setValue(VarValue)}
                        expressionArgs := {Append @expressionArgs [Arg]}
                    end
                end
            else
                expression := {Strip {Replace Expression "=" ""} " "}
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

        meth getTree(FuncNamesList Return)
            if {IsAnyElementIn @expression ["*" "/" "+" "-"]} then
                Return = {FullTreeFromFunction @expression}
            elseif {Length {Split @expression " "}} == 1 then
                Return = {FullTreeFromFunction @expression}
            else
                Return = {FullTreeFromCallBack FuncNamesList @expression} 
            end            
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

    fun {StringToNumber Input}
        try {StringToInt Input} catch X then try {StringToFloat Input} catch Y then Input end end         
    end

    fun {IsAnyFunctionToResolveInTree RootTree ElemList}
        local Result = {NewCell false} in
            for Elem in ElemList do
                if @Result == false then {CheckIfANodeContainsFunction RootTree Elem Result} end
            end
            @Result            
        end
    end

    proc {CheckIfANodeContainsFunction RootTree LookFor Result}
        if (RootTree == nil) == false then Value LeftNode RightNode in
            {RootTree getFunctionName(Value)}
            if {Contains Value LookFor} then
                Result := true
            else
                {RootTree getLeft(LeftNode)}
                {RootTree getRight(RightNode)}
                {CheckIfANodeContainsFunction LeftNode LookFor Result} 
                {CheckIfANodeContainsFunction RightNode LookFor Result}            
            end            
        end      
    end
end