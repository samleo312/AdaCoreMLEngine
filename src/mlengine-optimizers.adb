with Orka.Numerics.Singles.Tensors;
with Orka.Numerics.Singles.Tensors.CPU;
with Ada.Text_IO; use Ada.Text_IO;

package body Mlengine.Optimizers is

    type Tensor_Array is array (1 .. 2) of Tensor;
    type Parameter_Groups is array (Natural range <>) of Tensor_Array;

    procedure Step(SGD_Params : in out Parameter_Groups; Velocities : in out Parameter_Groups; Learning_Rate : Float; Momentum : Float; Weight_Decay : Float) is
    begin
        for Group_Index in SGD_Params'Range loop
            for Tensor_Index in SGD_Params(Group_Index)'Range loop
                Velocities(Group_Index)(Tensor_Index).Data.all := Momentum * Velocities(Group_Index)(Tensor_Index).Data.all +
                                                                  Learning_Rate * (SGD_Params(Group_Index)(Tensor_Index).Grad.all +
                                                                  Weight_Decay * SGD_Params(Group_Index)(Tensor_Index).Data.all);
                SGD_Params(Group_Index)(Tensor_Index).Data.all := SGD_Params(Group_Index)(Tensor_Index).Data.all -
                                                                 Velocities(Group_Index)(Tensor_Index).Data.all;
            end loop;
        end loop;
    end Step;

    procedure Zero_Grad(Params : in out Parameter_Groups) is
    begin
        for Group_Index in Params'Range loop
            for Tensor_Index in Params(Group_Index)'Range loop
                Params(Group_Index)(Tensor_Index).Grad.all := ST_CPU.Zeros(Params(Group_Index)(Tensor_Index).Grad.all'Length);
            end loop;
        end loop;
    end Zero_Grad;

--      -- procedure with no input
--      -- loops though instance variables "params" and "velocities"
--      -- assigns new value to velocity
--      -- assigns new value to params.t.data)
--      overriding procedure step (params: in out SGD) is
--      grad: ST_CPU.CPU_Tensor := params.t.Grad.all;
--      data: ST_CPU.CPU_Tensor := params.t.Data.all;
--      begin
--          for i in params.velocities'Range loop
--              declare
--                  res: ET;
--              begin
--                  params.velocities(i) := ET(params.momentum) * params.velocities(i)
--                   + grad.get(i) + ET(params.weight_decay) * data.get(i);
--                  res:= data.get(i) - ET(params.lr) * params.velocities(i);
--                  params.t.data.set(i, res);
--              end;
--          end loop;
--      end;


--  --procedure to reset all parameter t.gradient values to 0
--      overriding procedure zero_grad(params : in out SGD) is
--      begin
--          --  Put_Line(params'Image);
--          params.t.Grad.all := ST_CPU.Zeros(params.t.Grad.Shape);
--      end zero_grad;

--  --getters
--      overriding function get_data(params : in out SGD) return ST_CPU.CPU_Tensor is
--          begin
--              return params.t.data.all;
--          end;
        
--      overriding function get_grad(params : in out SGD) return ST_CPU.CPU_Tensor is
--          begin
--              return params.t.grad.all;
--          end;

end Mlengine.Optimizers;




 
