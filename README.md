# Single language

This is a functional language only create to operate with variable of type number, the idea is create complex programs

## Example of language

``` single

// Declare variables
var X = 3
var Y = 4
var Z = 5

// Call function
fun add(var a, var b):
    return a + b
end

// call function, expected 12
var Result = add(add(X, Y) Z)
```

``` Mozart
proc {Test}
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
        %{PrintTree {FullFillTree {Join {Infix2Prefix {Str2Lst "square square 2"}} " "}}} %% FUNCTION TREE
        %{Show "\n\n========\n\n"}
        %{PrintTree {FullFillTree {Join {Infix2Prefix {Str2Lst "(x+1) * (x-1)"}} " "}}} %% CALLBACK TREE
        %{Show "\n\n========\n\n"}
        {PrintTree {FullFillTree "square square 3"}}
        {Show "something"}
    end
end
```