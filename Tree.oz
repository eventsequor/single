functor
import
    System(showInfo:Show)
    String(join:Join)

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

    proc {GetTree Root}    
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

    local 
        Node1
        Node2
        Node3
        Node4
        Node5
        Node6
    in
        Node1 = {New Node init("a")}
        Node2 = {New Node init("baquero")}
        Node3 = {New Node init("casa")}
        Node4 = {New Node init("d")}
        Node5 = {New Node init("e")}
        Node6 = {New Node init("f")}
        % Add children node 1
        {Node1 setLeft(Node2)}
        {Node1 setRight(Node3)}

        % Add children node 2
        {Node2 setLeft(Node4)}
        {Node2 setRight(Node5)}
        {Node5 setLeft(Node6)}
        {GetTree Node1}
    end
    
end