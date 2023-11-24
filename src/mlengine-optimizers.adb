with Orka; --for Float32 type
use Orka; --for operator
with Orka.Numerics.Singles.Tensors.CPU;
use Orka.Numerics.Singles.Tensors.CPU;
with Orka.Numerics.Singles.Tensors.CPU;
use Orka.Numerics.Singles.Tensors.CPU;
with Ada.Text_IO; use Ada.Text_IO;


package body Mlengine.Optimizers is

    -- procedure with no input
    -- loops though instance variables "params" and "velocities"
    -- assigns new value to velocity
    -- assigns new value to params(i) (t.data)
    overriding procedure step (params: in out SGD) is
    grad: ST_CPU.CPU_Tensor := params.t.Grad.all;
    data: ST_CPU.CPU_Tensor := params.t.Data.all;
    begin
        for i in params.velocities'Range loop
            declare
                res: ET;
            begin
                --  Put_Line("I: " & float'Image(float(i)));
                --  Put_Line("velocities(i): " & float'Image(float(params.velocities(i))));
                --  Put_Line(data.get(i).Image);

                --  Put_Line("DATA(I): " & data.get(i).Image);
                --  Put_Line("LR: "& float'Image(float(params.lr)));
                --  Put_Line("v(i): " & float'Image(float(params.velocities(i))));
                --  Put_Line("RES: " & float'Image(float(res)));

                params.velocities(i) := ET(params.momentum) * params.velocities(i) + grad.get(i) + ET(params.weight_decay) * data.get(i);
                res:= data.get(i) - ET(params.lr) * params.velocities(i);
                params.t.data.set(i, res);
                --  Put_Line("DATA: " & data.get(i).Image);
            end;
        end loop;
        --  Put_Line("IN LOOP: " & params.t.Data.Image);
    end;


--procedure to reset all parameter t.gradient values to 0
    overriding procedure zero_grad(params : in out SGD) is
    begin
        params.t.Grad.all := ST_CPU.Zeros(params.t.Grad.Shape);
    end zero_grad;

end Mlengine.Optimizers;




 
