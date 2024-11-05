functor
import
    System(showInfo:Show)
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

    proc {PrintTree Root}    
        {BuildTree2 Root 1 "" ""}
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
                    {BuildTree2 LeftNode (Level + 1) (Prefix # "|" # {MultiString " " " " (ValueLenght)}) "├─"}  
                end                
            end
            if (RightNode == nil) == false then
                if Level == 1 then
                    {BuildTree2 RightNode (Level + 1) Prefix "└─"}
                else
                    {BuildTree2 RightNode (Level + 1) (Prefix # "|" # {MultiString " " " " (ValueLenght)}) "└─"}  
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
        {PrintTree {FullFillTree {Join {Infix2Prefix {Str2Lst "x * x"}} " "}}}
    end
    

    %             a
    %           /   \
    %          b     c
    %
end