functor
import
    System(showInfo:Show)
    Application(exit:Exit)
    StringEder(strip:Strip)
export 
    Resolve
    
define
    Add = fun {$ A B} A + B end
    Subtract = fun {$ A B} A - B end
    Multi = fun {$ A B}  A * B end
    Divi = fun {$ A B}  A / B end
    Mod = fun {$ A B}  A mod B end
    
   
    % This is a kind of map of operations    
    fun {GetOper Symbol}
        local 
            Operations = [{New Oper init("+" Add)} {New Oper init("-" Subtract)} {New Oper init("*" Multi)} {New Oper init("/" Divi)} {New Oper init("%" Mod)}]            
            Result = {NewCell nil} 
        in
            for Op in Operations do
                local Sym Operation in
                    {Op getKey(Sym)}                    
                    if Symbol == Sym then 
                        {Op getFunction(Operation)}
                        Result := Operation
                    end
                end
            end
            @Result
        end
    end


    class Oper
        attr key function
        meth init(Key Function)
            key :=  Key
            function := Function            
        end
        meth getKey(Return)
            Return = @key
        end
        meth getFunction(Return)
            Return = @function
        end
    end

    fun {Resolve A Symbol B}
        case Symbol of nil then "no operation: "#Symbol
        else 
            {{GetOper {Strip Symbol " "}} {StringToFloat A} {StringToFloat B}}
        end
    end    
    
    proc {Test}
        {Show {Resolve 6 "/" 3}}
        {Exit 0}
    end
    %{Test}
end