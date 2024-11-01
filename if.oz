functor
import
    System(showInfo:Show)
    Application(exit:Exit)
    String(replace:Replace split:Split strip:Strip)
define
   
    local AA in
        class If
            attr env_variables condition arraysubfunctions % the if stament always has only two options

            meth init(EnvVariables Sentence)
                env_variables := EnvVariables
                condition := Sentence
                {self eval(Sentence)}
            end

            meth eval(Sentence)
                local Head Tail in
                    Head|Tail|nil = {Split {Replace {Replace Sentence "if" ""} "end" ""} "?"}
                    condition := Head
                    if {Length {Split Tail ":"}} == 1 then
                        arraysubfunctions := [Tail]
                    else
                        arraysubfunctions := {Split Tail ":"}
                    end                
                    for P in @arraysubfunctions do
                        {Show P}
                    end
                end
            end
        end
    end

    Obj = {New If init(nil "if true ? 5 + 3 : 6 + 1 end")}
    %{Obj eval("if true ? Correct  Incorrect end")}
end