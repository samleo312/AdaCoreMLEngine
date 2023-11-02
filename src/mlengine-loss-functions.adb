package body Mlengine.LossFunctions is

    -- SoftMaxLoss struct
    type SoftMaxLoss is record
        Type_ : Unbounded_String := "normalization";
        Target: Unbounded_String := "target";  -- Placeholder for target
    end record;

    -- Constructor of SoftMaxLoss
    function init_SoftMaxLoss return SoftMaxLoss is 
    begin 
        return (Type_ => "normalization");
    end init_SoftMaxLoss;

    function Unnormalized_prob (X : Float; MaxX: Float ) return Float is 
        (Exp(X - MaxX));

    function FindMax(X: Float_Array) return Float is 
    MaxValue: Float := 0.0;
    begin   
        for F of X loop
            if F > MaxValue then
                MaxValue := F;
            end if;
        end loop;
        return MaxValue;
    end;

    procedure Unnormalized_probs(X: in out Float_Array) is
    MaxVal: Float := FindMax(X);
    begin 
        for F in X'range loop
            X(F) := Unnormalized_prob(X(F), MaxVal);
        end loop;
    end;

    function Forward (Layer: in out SoftMaxLoss; X : Float_Array; Target : Unbounded_String) is
        -- Unnormalized_proba : Float := (Unnormalized_prob()); -- insert: np.exp(x-np.max(x,axis=1,keepdims=True))
        Probability : Float := (Unnormalized_proba/ 1.0); -- insert: unnormalized_proba/np.sum(unnormalized_proba,axis=1,keepdims=True)
        Target : Unbounded_String := Target; -- self.target = target
        Loss : Float_Array(1..1) := (0.0);  -- insert: -np.log(self.proba[range(len(target)),target])
    begin
    Unnormalized_probs(X); -- insert: np.exp(x-np.max(x,axis=1,keepdims=True))
    
    return Loss.mean;    -- return loss.mean()
    end Forward;

    function Backward is 
    Gradient : Float := Probability; --
    begin  
        -- gradient[range(len(self.target)),self.target]-=1.0
        -- gradient/=len(self.target)
    return Gradient;
    end Backward;

end Mlengine.LossFunctions;
