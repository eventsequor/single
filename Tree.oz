functor
import
    System(showInfo:Show)
    StringEder(join:Join replace:Replace contains:Contains split:Split strip:Strip)

export
    PrintTree
    FullTreeFromCallBack
    FullTreeFromFunction

define

    class Node
        attr value left right nickname
        meth init(Value)
            value := Value
            left := nil
            right := nil
        end

        meth getValue(ReturnValue)
            ReturnValue = @value
        end

        meth setValue(NewValue)
            value := NewValue
        end

        meth setLeft(Node)
            left := Node
        end

        meth setRight(Node)
            right := Node
        end

        meth getLeft(ReturnNode)
            ReturnNode = @left
        end

        meth getRight(ReturnRight)
            ReturnRight = @right
        end

        meth setNickName(NewNickName)
            nickname := NewNickName
        end

        meth getNickName(Return)
            Return := @nickname
        end
    end

    fun {MultiString Character Acu Times}
        if {Length Acu} < Times then
            {MultiString Character {Join [Character Acu] ""} Times}
        else
            Acu
        end
    end

    proc {PrintTree Root}    
        if Root == nil then
            {Show "There is nothing to print"}
        else
            {BuildTree2 Root 1 "" ""}
        end
    end

    proc {BuildTree2 Root Level Prefix Symbol}
        local Value RightNode LeftNode ValueLenght in
            {Root getValue(Value)}
            ValueLenght = {Length Value}
            {Root getLeft(LeftNode)}
            {Root getRight(RightNode)}
            %Print
            if Level == 1 then
                {Show Symbol # Value}
            else 
                {Show Prefix # Symbol # Value}
            end

            if (LeftNode == nil) == false then
                if Level == 1 then
                    {BuildTree2 LeftNode (Level + 1) Prefix "├─"}  
                else
                    {BuildTree2 LeftNode (Level + 1) (Prefix # " " # {MultiString " " " " (ValueLenght)}) "├─"}  
                end                
            end
            if (RightNode == nil) == false then
                if Level == 1 then
                    {BuildTree2 RightNode (Level + 1) Prefix "└─"}
                else
                    {BuildTree2 RightNode (Level + 1) (Prefix # " " # {MultiString " " " " (ValueLenght)}) "└─"}  
                end
            end
        end
    end

    proc {PopulateTree Tokens NodeRoot}
        if {Length Tokens} == 1 then NodeValue in
            {NodeRoot getValue(NodeValue)}
            if {Contains {Nth Tokens 1} "~"} == false andthen NodeValue == "@" then {NodeRoot setRight({New Node init({Nth Tokens 1})})} end
        else H T in
            H|T = Tokens
            {NodeRoot setLeft({New Node init(H)})}
            if (T == nil) == false then
                if {IsList T} then RightNode in
                    if {Length T} == 1 then
                        {NodeRoot setRight({New Node init({Nth T 1})})}
                    else
                        RightNode = {New Node init("@")}
                        {NodeRoot setRight(RightNode)}
                        {PopulateTree T RightNode}
                    end                    
                else
                    {NodeRoot setRight({New Node init(T)})}
                end
            end
        end
    end

    fun {FullTreeFromFunction Expression}
        if {Length Expression} == 0 then
            nil
        else ProcessedExpr Delete RootTree = {New Node init("@")} in
            ProcessedExpr = {FunctionBinder {RemoveBrackers Expression}}
            _ = {ResolveMainTree RootTree {FunctionBinder ProcessedExpr}}
            {ReduceTree RootTree}       
            RootTree
        end      
    end

    proc {ReduceTree RootTree}
        if {IsAnyElementInTree RootTree [" * " " / " " + " " - " "(" ")" "~"]} then 
            {ResolveSubNodes RootTree}
            {Debinding RootTree}
            {Rebinding RootTree}
            {ReduceTree RootTree}
        end
    end

    fun {FunctionBinder Expression} 
        if {Contains Expression "("} andthen {Contains Expression ")"} then Name SubFunction JoinChar = "~" in
            SubFunction = {GetOneExprIntoBrackets Expression}
            Name = {Replace {Replace {Replace SubFunction " " JoinChar} "(" "<"} ")" ">"}                    
            {FunctionBinder {Replace Expression SubFunction Name}}
        else
            Expression
        end
    end

    proc {Rebinding RootTree}
        if (RootTree == nil) == false then Value LeftNode RightNode in
            {RootTree getValue(Value)}
            if {IsAnyElementIn Value ["(" ")"]} then {RootTree setValue({Strip {FunctionBinder Value} " "})} end

            {RootTree getLeft(LeftNode)}
            {RootTree getRight(RightNode)}
            {Rebinding LeftNode}
            {Rebinding RightNode}
        end 
    end

    fun {IsAnyElementIn String ElemList}
        local Result = {NewCell false} in
            for Elem in ElemList do
                if @Result == false then Result := {Contains String Elem} end
            end
            @Result            
        end
    end

    fun {IsAnyElementInTree RootTree ElemList}
        local Result = {NewCell false} in
            for Elem in ElemList do
                if @Result == false then {CheckIfANodeContains RootTree Elem Result} end
            end
            @Result            
        end
    end

    proc {CheckIfANodeContains RootTree LookFor Result}
        if (RootTree == nil) == false then Value LeftNode RightNode in
            {RootTree getValue(Value)}
            if {Contains Value LookFor} then
                Result := true
            else
                {RootTree getLeft(LeftNode)}
                {RootTree getRight(RightNode)}
                {CheckIfANodeContains LeftNode LookFor Result} 
                {CheckIfANodeContains RightNode LookFor Result}            
            end            
        end      
    end

    proc {Debinding RootTree}
        local Value LeftNode RightNode in
            {RootTree getValue(Value)}
            if {IsAnyElementIn Value ["~" "<" ">"]} then NewValue in
                NewValue = {Replace {Replace {Replace Value "~" " "} "<" "("} ">" ")"}
                {RootTree setValue({Strip {RemoveBrackers NewValue} " "})}
            end

            {RootTree getLeft(LeftNode)}
            {RootTree getRight(RightNode)}
            if (LeftNode == nil) == false then {Debinding LeftNode} end
            if (RightNode == nil) == false then {Debinding RightNode} end
        end
    end

    fun {RemoveBrackers Expression}
        if [{Nth Expression 1}] == "(" andthen [{Nth {Reverse Expression} 1}] == ")" andthen {Length Expression} > 2 then T ST NewValue in
            if {GetOneExprIntoBrackets Expression} == Expression then
                _|T = Expression
                _|ST = {Reverse T}            
                {RemoveBrackers {Reverse ST}}
            else
                Expression
            end
        else
            Expression
        end
    end

    proc {ResolveSubNodes RootTree}
        local Value LeftNode RightNode in
            {RootTree getValue(Value)}
            {RootTree getLeft(LeftNode)}
            {RootTree getRight(RightNode)}
            if (LeftNode == nil) == false then {ResolveSubNodes LeftNode} end
            if (RightNode == nil) == false then {ResolveSubNodes RightNode} end
            if (Value == "@") == false then _ = {ResolveMainTree RootTree Value} end  
        end
    end

    fun {ResolveMainTree RootTree Expression}
        if {Contains Expression " * "} then {EvaluateOperation "*" RootTree Expression}
        elseif {Contains Expression " / "} then {EvaluateOperation "/" RootTree Expression} 
        elseif {Contains Expression " + "} then {EvaluateOperation "+" RootTree Expression} 
        elseif {Contains Expression " - "} then {EvaluateOperation "-" RootTree Expression}
        elseif (Expression == "@") == false then {EvaluateOperation "±" RootTree Expression} % ± this symbol will never exist
        else RootTree end
    end

    fun {EvaluateOperation Oper RootTree Expression}
        if {Contains Expression Oper} andthen (Expression == Oper) == false then H T Tokens LeftNode LeftValue RightNode RightValue in
            H|T = {Split Expression {Join [" " Oper " "] ""}}
            if T == nil then
                Tokens = [H]
                {PopulateTree Tokens RootTree}
            else             
                Tokens = [{Strip Oper " "} H {Join T Oper}]
                {PopulateTree Tokens RootTree}
            end                       

            {RootTree getLeft(LeftNode)}
            {RootTree getRight(RightNode)}
            if (LeftNode == nil) == false andthen {Contains Expression Oper} andthen (Expression == Oper) == false then
                {LeftNode getValue(LeftValue)}                
                if (LeftValue == Oper) == false then
                    {RootTree setValue("@")}
                    {LeftNode setLeft({EvaluateOperation Oper LeftNode LeftValue})}
                end                
            end
            if (RightNode == nil) == false andthen {Contains Expression Oper} andthen (Expression == Oper) == false then
                {RightNode getValue(RightValue)}
                if (RightValue == nil) == false then
                    {RootTree setValue("@")}
                    {RootTree setRight({EvaluateOperation Oper RightNode RightValue})}
                end                
            end
        end

        if Oper == "±" then Tokens = [Expression] in
            {PopulateTree Tokens RootTree}
        end

        if Expression == "@" then RightNode LeftNode LeftValue RightValue in
            {RootTree getLeft(LeftNode)}
            {RootTree getRight(RightNode)}
            
            if (LeftNode == nil) == false then                
                {LeftNode getValue(LeftValue)}
                {RootTree setLeft({EvaluateOperation Oper LeftNode LeftValue})}
            end
            if (RightNode == nil) == false then
                {RightNode getValue(RightValue)}
                {RootTree setRight({EvaluateOperation Oper RightNode RightValue})}
            end
        end
        RootTree
    end

    fun {GetOneExprIntoBrackets String}
        local OutPut = {NewCell ""} BracketNumber = {NewCell 0} Collect = {NewCell true} in
            for Char in String do
                if [Char] == "(" andthen @Collect then
                    BracketNumber := @BracketNumber + 1
                end
                if @BracketNumber > 0 then
                    OutPut := {Join [@OutPut [Char]] ""}
                end
                if [Char] == ")" then
                    BracketNumber := @BracketNumber - 1
                    if @BracketNumber == 0 then Collect := false end
                end
            end
            @OutPut
        end
    end

    fun {OperationBinder Expression}
        local NewExpr = {NewCell Expression} in
            for Oper in [" * " " / " " + " " - "] do
                NewExpr := {Replace @NewExpr Oper {Replace Oper " " "°"}}
            end
            @NewExpr
        end
    end

    fun {OperationDebinder Expression}
        local NewExpr = {NewCell Expression} in
            for Oper in ["°*°" "°/°" "°+°" "°-°"] do
                NewExpr := {Replace @NewExpr Oper {Replace Oper "°" " "}}
            end
            @NewExpr
        end
    end

    fun {FullTreeFromCallBack FuncNamesList Expression}
        if {Length Expression} == 0 then
            nil
        else RootTree = {New Node init("@")} in
            {ResolveMainTreeCallBack RootTree FuncNamesList {Strip {FunctionBinder {OperationBinder Expression}} " "}}
            {OperationDebinderOnTree RootTree}
            {ReduceTree RootTree}
            RootTree
        end  
    end

    proc {OperationDebinderOnTree RootTree}
        local Value LeftNode RightNode NewValue in
            {RootTree getValue(Value)}
            {RootTree setValue({RemoveBrackers {Replace {Replace {Replace {OperationDebinder Value} "~" " "} "<" "("} ">" ")"}})}

            {RootTree getLeft(LeftNode)}
            {RootTree getRight(RightNode)}
            if (LeftNode == nil) == false then {OperationDebinderOnTree LeftNode} end
            if (RightNode == nil) == false then {OperationDebinderOnTree RightNode} end
        end
    end

    proc {ResolveMainTreeCallBack RootTree FuncNamesList Expression}
        if {Contains Expression " "} then H T in
            H|T = {Split Expression " "}
            if {ContainsAnyElement H FuncNamesList} then
                {RootTree setLeft({New Node init(H)})}
                if (T == nil) == false then NewExpr = {Join T " "} H1 T1 RightNode in
                    H1|T1 = {Split NewExpr " "}
                    if {ContainsAnyElement H1 FuncNamesList} then
                        RightNode = {New Node init("@")}
                        {RootTree setRight(RightNode)}
                        {ResolveMainTreeCallBack RightNode FuncNamesList NewExpr}    
                    else
                        RightNode = {New Node init(H1)}
                        {RootTree setRight(RightNode)}
                        if (T1 == nil) == false then {ResolveMainTreeCallBack RightNode FuncNamesList {Join T1 " "}} end
                    end                    
                end
            else RightNode = {New Node init(H)} in
                {RootTree setRight(RightNode)}     
                if (T == nil) == false then
                    {ResolveMainTreeCallBack RightNode FuncNamesList {Join T " "}}           
                end
            end            
        else
            {RootTree setRight({New Node init(Expression)})}
        end
    end

    fun {ContainsAnyElement String ElemList}
        local Result = {NewCell false} in
            for Elem in ElemList do
                if @Result == false then Result := String == Elem end
            end
            @Result            
        end
    end

    proc {Virtual}
        local 
            Expression2 FuncNamesList
        in
            %Expression2 = "squence 4 1"
            Expression2 = "x * x"
            FuncNamesList = ["square" "sqr"]
            %Expression2 = "squence sequence y"
            %Expression2 = "x * x"
            
            {PrintTree {FullTreeFromFunction Expression2}} % Full fill from function
            %{PrintTree {FullTreeFromCallBack FuncNamesList Expression2}}
        end
    end

    %{Virtual}
end