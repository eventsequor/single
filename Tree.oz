functor
import
    System(showInfo:Show)
    StringEder(join:Join replace:Replace contains:Contains split:Split)

export
    FullFillTree
    PrintTree

define

    class Node
        attr value left right
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
    end

    class SubFunctionObj
        attr name expression
        meth init(Name Expression)
            name := Name
            expression := Expression
        end

        meth getName(Return)
            Return = @name
        end
        
        meth getExpression(Return)
            Return = @expression
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

    fun {FullFillTree Expression}
        if {Length Expression} == 0 then
            nil
        else Root Tokens in
            Tokens = {String.tokens Expression & }
            Root = {New Node init("@")}
            {PopulateTree Tokens Root}
            Root
        end
    end

    proc {PopulateTree Tokens NodeRoot}
        local H T in
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
    

    %{Show {Join {Infix2Prefix {Str2Lst "x * x * x"}} " "}}
    %{PrintTree {FullFillTree {Join {Infix2Prefix {Str2Lst "x * (x*x)"}} " "}}} %% CALLBACK TREE

    proc {Virtual}
        local 
            Expression2
            JoinChar = "~" 
            ListSubFun = {NewCell nil}
            FunctionBinder
            RootTree
        in
            Expression2 = "(x + 1) * (x - 1) + 4"
            FunctionBinder = fun {$ Expression} 
                if {Contains Expression "("} andthen {Contains Expression ")"} then Name SubFunction in
                    SubFunction = {GetOneExprIntoBrackets Expression}
                    Name = {Replace {Replace {Replace SubFunction " " JoinChar} "(" "<"} ")" ">"}
                    if @ListSubFun == nil then ListSubFun := [{New SubFunctionObj init(Name SubFunction)}] else ListSubFun := {Append @ListSubFun [{New SubFunctionObj init(Name SubFunction)}]} end
                    
                    {FunctionBinder {Replace Expression SubFunction Name}}
                else
                    Expression
                end
            end
            {Show "========="}
            RootTree = {New Node init("@")} 
            {PrintTree {FullTreeFromExpr RootTree {FunctionBinder Expression2}}}
        end
    end

    fun {FullTreeFromExpr RootTree Expression}
        
        {Show "Fist ==========="}
        {PrintTree {EvaluateOperation "*" RootTree Expression}}
        {Show "\nSecond ==========="}
        _ = {EvaluateOperation "+" RootTree "@"}
        
        RootTree
    end

    fun {EvaluateOperation Oper RootTree Expression}
        if {Contains Expression Oper} andthen (Expression == Oper) == false then H T Tokens LeftNode LeftValue RightNode RightValue in
            H|T = {Split Expression Oper}
            Tokens = [Oper H {Join T Oper}]  
            {PopulateTree Tokens RootTree}
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

    {Virtual}
end