package Mlengine.Optimizers is
    
    -- is constructor required? if so, only parameter required is "parameters"

    -- procedure to adjust values of parameters and velocities for an adjustment towards the optimal solution
    procedure step (Float_Array: in out parameters, Float_Array: in out velocity)

    -- procedure to reset parameters to 0
    procedure zeroGrad(Float_Array: in out parameters)

end Mlengine.Optimizers;