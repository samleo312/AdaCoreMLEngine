with Orka; --for Float32 type
use Orka; --for operator
with Orka.Numerics.Singles.Tensors.CPU;
use Orka.Numerics.Singles.Tensors.CPU;
with Orka.Numerics.Singles.Tensors.CPU;
use Orka.Numerics.Singles.Tensors.CPU;

package body Mlengine.Optimizers is

    -- procedure with no input
    -- loops though instance variables "params" and "velocity"
    -- assigns new value to velocity
    -- assigns new value to params(1) (t.data)
    overriding procedure step (params: in out SGD) is
    grad: ST_CPU.CPU_Tensor := params.t.Grad.all;
    data: ST_CPU.CPU_Tensor := params.t.Data.all;
    begin
        for i in params.velocity'Range loop
            declare
                res: ET := data.get(i) - ET(params.lr) * params.velocity(i);
            begin
                params.velocity(i) := ET(params.momentum) * params.velocity(i) + grad.get(i) + ET(params.weight_decay) * data.get(i);
                data.set(i, res);
            end;
        end loop;
    end;


--procedure to reset all parameter t.gradient values to 0
    overriding procedure zero_grad(params : in out SGD) is
    begin
        params.t.Grad.all := ST_CPU.zeros(params.t.Grad.Elements);
    end zero_grad;

end Mlengine.Optimizers;




 
