package Mlengine.Optimizers is
    
    -- procedure to adjust values of parameters and velocities for an adjustment towards the optimal solution
    procedure step (Float_Array: in out parametersGrad, Float_Array in out parametersData, Float_Array: in out velocity);

    -- procedure to reset parameter values to 0.0
    procedure zero_grad(Float_Array: in out parametersGrad, Float_Array: in out parametersData);
      

end Mlengine.Optimizers;
