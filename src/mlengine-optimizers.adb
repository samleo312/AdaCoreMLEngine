---------------------
--      Questions    -
---------------------
--unit tests?
--create Parameter_Array?

with Orka; --for Float32 type
use Orka; --for operator
with Orka.Numerics.Singles.Tensors.CPU;
use Orka.Numerics.Singles.Tensors.CPU;
with Orka.Numerics.Singles.Tensors.CPU;
use Orka.Numerics.Singles.Tensors.CPU;

package body Mlengine.Optimizers is

    -- procedure with no input
    -- loops though instance variables "parameters" and "velocity"
    -- assigns new value to velocity
    -- assigns new value to parameters(1) (data)
    procedure step (parameters: in out Tensor, velocity: in out Float_Array)
    is
    begin
        for i in velocity'Range loop
            velocity(i) := momentum * velocity(i) + parameters(2)(i) + weight_decay * parameters(1)(i);
            parameters(1)(i) := parameters(1)(i) - lr * velocity(i);
        end loop
    end


--procedure to reset all parameter gradient values to 0
    procedure zero_grad(Float_Array: in out parametersGrad, Float_Array: in out parametersData)
    begin
        for i in parameters(2)'Range loop
            parameters(2)(i) := 0;
        end loop;
    end zero_grad

end Mlengine.Optimizers;




 
