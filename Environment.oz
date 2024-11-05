functor
import
    System(showInfo:Show)
    StringEder(strip:Strip split:Split replace:Replace print:Print)

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
                    if @callbacks == nil then callbacks := [{GetNameCallBack Instruction}] else callbacks := {Append @callbacks [{GetNameCallBack Instruction}]} end
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
                local H T Expression in
                    H|T = {Split Instruction "="}
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
            
            for Arg in {GetArgs Line} do Instr in
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
end