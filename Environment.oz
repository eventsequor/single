functor
import
    System(showInfo:Show print:Print)
    Application(exit:Exit)
    String(strip:Strip split:Split join:Join make:Make replace:Replace nextSplitSEP:NextSplitSEP)

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
                    if @variables == nil then variables := [{New Variable init({GetNameVariableOrFunction Instruction})}] else variables := {Append @variables [{New Variable init({GetNameVariableOrFunction Instruction})}]}end
                end
                if Type == function then
                    if @functions == nil then functions := [{New Function init(Instruction)}] else functions := {Append @functions [{New Function init(Instruction)}]} end
                end
                if Type == callback then 
                    if @callbacks == nil then callbacks := [{GetNameCallBack Instruction}] else callbacks := {Append @callbacks [{GetNameCallBack Instruction}]} end
                end
            end
        end

        meth line_evaluator(Line)
            {Show ""}
        end
        meth getFunctions(Return)
            Return = @functions 
        end
    end

    class Variable
        attr name value
        meth init(Name)
             name := Name
        end

        meth getName(Return)
            Return = @name
        end

        meth getValue(Return)
            Return = @value
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

            local H T Expression in
                H|T = {Split Line "="}
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
            Out
        end
    end
    Obj 
    Obj = {New Function init("fun square x y = x * x")}
    Args
    {Obj getArgs(Args)}
    for Arg in Args do Name in
        {Arg getName(Name)}
        {Show "Name arg: "#Name}
    end
    
end