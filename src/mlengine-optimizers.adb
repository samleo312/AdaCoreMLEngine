---------------------
-      Questions    -
---------------------
where does    "type Index is range 1 .. X;" go?



package body Mlengine.Optimizers is

type SGD is tagged record
    lr, weight_decay, momentum : double;
    -- parameters : arary of parameters for optimizer
    -- velocity : array same size as "parameters" list but all values are 0
end record;

   -- procedure with no parameters
    -- all calculations done with instance variables
    -- loops though instance variables "parameters" and "velocity"
    -- assigns new value to velocity
    -- assigns new value to parameters.data
    procedure step()
    is
    begin
    -- cannot determine logic until parameters and velocity are concrete
    -- pseudo logic is as follows
    -- for i = 0, i < velocity.length(), i++
        -- velocity[i] = momentum * velocity[i] + parameters.grad + weight_decay * parameters.data
        -- parameters.data = parameters.data - lr * velocity[i]

end Mlengine.Optimizers;




 
