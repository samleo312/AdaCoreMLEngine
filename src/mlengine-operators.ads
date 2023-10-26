package Mlengine.Operators is

    function Forward (Self: in Linear; Output: out Integer);
    function Backward (Self: in Linear; GradInput: out Integer);
    function GetParams(Self: in Linear; ParameterList: out Integer);

end Mlengine.Operators;