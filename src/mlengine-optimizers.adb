---------------------
-      Questions    -
---------------------
--unit tests?
--create Parameter_Array?


package body Mlengine.Optimizers is

-- define Stochastic Gradient Descent
-- lr: learning rate of the engine
-- weight_decay:
-- momentum: 
-- parametersGrad: array of gradients for optimizer (Float_Array)
-- parametersData: array of data for optimizer (Float_Array)
-- velocity: array storing the changes in parameters, all values begin as 0 (Float_Array)
type SGD is tagged record
    lr, weight_decay, momentum : Float;
    parametersGrad : Float_Array
    parametersData : Float_Array
    velocity : Float_Array
end record;

   -- procedure with no parameters
    -- all calculations done with instance variables
    -- loops though instance variables "parameters" and "velocity"
    -- assigns new value to velocity
    -- assigns new value to parameters.data
    procedure step (Float_Array: in out parametersGrad, Float_Array: in out parametersData, Float_Array: in out velocity)
    is
    begin
        for i in velocity'Range loop
            velocity(i) := momentum * velocity(i) + parametersGrad(i) + weight * parametersData(i);
            parametersData(i) := parametersData - lr * velocities(i);
        end loop
    end


--procedure to reset all parameter values to 0
    procedure zero_grad(Float_Array: in out parametersGrad, Float_Array: in out parametersData)
    begin
        for i in parametersData'Range loop
            parametersData(i) := 0.0;
            parametersGrad(i) := 0.0;
        end loop;
    end zero_grad

end Mlengine.Optimizers;




 
