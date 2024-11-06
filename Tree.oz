functor
import
    System(showInfo:Show print:Print)
    StringEder(join:Join)
    InfixPrefix(str2Lst:Str2Lst infix2Prefix:Infix2Prefix)    

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

    fun {MultiString Character Acu Times}
        if {Length Acu} < Times then
            {MultiString Character {Join [Character Acu] ""} Times}
        else
            Acu
        end
    end

    proc {PrintTree Root Reduc}    
        {BuildTree2 Root 1 "" "" Reduc}
    end

    proc {BuildTree2 Root Level Prefix Symbol Reduc}
        local Value RightNode LeftNode ValueLenght Operators Numbers in
            Operators=["+" "-" "*" "/"]

            {Root getValue(Value)}
            ValueLenght = {Length Value}
            {Root getLeft(LeftNode)}
            {Root getRight(RightNode)}
            %Print
            if Level == 1 then
                {Show Symbol # Value}
            else
                if (Reduc == " ")==false andthen {List.member Value Operators} == false andthen {Int.is Value} == false andthen (Value == "@")==false  then
                    {BuildTree2 Reduc 2 Prefix "├─" " "}  
                else
                    {Show Prefix # Symbol # Value}
                end
            end

            if (LeftNode == nil) == false then
                if Level == 1 then
                    {BuildTree2 LeftNode (Level + 1) Prefix "├─" Reduc}  
                else
                    {BuildTree2 LeftNode (Level + 1) (Prefix # "|" # {MultiString " " " " (ValueLenght)}) "├─" Reduc}  
                end                
            end
            if (RightNode == nil) == false then
                if Level == 1 then
                    {BuildTree2 RightNode (Level + 1) Prefix "└─" Reduc}
                else
                    {BuildTree2 RightNode (Level + 1) (Prefix # "|" # {MultiString " " " " (ValueLenght)}) "└─" Reduc}  
                end
                
            end
        end
    end

    fun {FullFillTree Expression}
        local Root Tokens in
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

    

    local 
        Node1
        Node2
        Node3
        Node4
        Node5
        Node6
        Tokens
        Root
        Square 
        Base 
    in
        %Node1 = {New Node init("a")}
        %Node2 = {New Node init("b")}
        %Node3 = {New Node init("c")}
        %Node4 = {New Node init("d")}
        %Node5 = {New Node init("e")}
        %Node6 = {New Node init("f")}
        %% Add children node 1
        %{Node1 setLeft(Node2)}
        %{Node1 setRight(Node3)}

        % Add children node 2
        %{Node2 setLeft(Node4)}
        %{Node2 setRight(Node5)}
        %{Node5 setLeft(Node6)}
        %{PrintTree Node1}
        Square = {FullFillTree {Join {Infix2Prefix {Str2Lst "x * x"}} " "}}
        {Show "\n\n========\n\n"}
        Base = {FullFillTree {Join {Infix2Prefix {Str2Lst "square square 3"}} " "} }
            
            %Ver Bases sin funcion para reduccion
            {PrintTree Base " "} 
            {Show "\n\n========\n\n"}
            {PrintTree Square " "} 

            {Show "\n\n========\n\n"}
            %Base con reduccion
            {PrintTree Base Square } 


        % Twice ={FullFillTree {Join {Infix2Prefix {Str2Lst "id p * p"}} " "}}
        % T = {FullFillTree {Join {Infix2Prefix {Str2Lst "f sqrt 4"}} " "}}
        %     {Show "\n\n========\n\n"}
        %     {PrintTree T Twice} 
        Comp = {FullFillTree {Join {Infix2Prefix {Str2Lst "x * x in y + y"}} " "} }
        Fourtimes = {FullFillTree {Join {Infix2Prefix {Str2Lst "fourtimes 2"}} " "} }

            {Show "\n\n========\n\n"}
            {PrintTree Fourtimes " " } 

            {PrintTree Fourtimes Comp } 


            

    end
end