with Orka.Numerics.Singles.Tensors;
with Orka.Numerics.Singles.Tensors.CPU;
with Ada.Text_IO; use Ada.Text_IO;

package body Mlengine.Optimizers is



    -- procedure with no input
    -- loops though instance variables "params" and "velocities"
    -- assigns new value to velocity
    -- assigns new value to params.t.data)
    overriding procedure step (params: in out SGD) is
    grad: ST_CPU.CPU_Tensor := params.t.Grad.all;
    data: ST_CPU.CPU_Tensor := params.t.Data.all;
    begin
        for i in params.velocities'Range loop
            declare
                res: ET;
            begin
                params.velocities(i) := ET(params.momentum) * params.velocities(i)
                 + grad.get(i) + ET(params.weight_decay) * data.get(i);
                res:= data.get(i) - ET(params.lr) * params.velocities(i);
                params.t.data.set(i, res);
            end;
        end loop;
    end;


--procedure to reset all parameter t.gradient values to 0
    overriding procedure zero_grad(params : in out SGD) is
    begin
        --  Put_Line(params'Image);
        params.t.Grad.all := ST_CPU.Zeros(params.t.Grad.Shape);
    end zero_grad;

--getters
    overriding function get_data(params : in out SGD) return ST_CPU.CPU_Tensor is
        begin
            return params.t.data.all;
        end;
        
    overriding function get_grad(params : in out SGD) return ST_CPU.CPU_Tensor is
        begin
            return params.t.grad.all;
        end;

end Mlengine.Optimizers;




 
