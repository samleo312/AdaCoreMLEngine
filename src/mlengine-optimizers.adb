with Orka.Numerics.Singles.Tensors;
with Orka; use Orka;
with Ada.Text_IO; use Ada.Text_IO;

package body Mlengine.Optimizers is
    -- procedure with no input
    -- loops though instance variables "params" and "velocities"
    -- assigns new value to velocity
    -- assigns new value to params.t.data)

    procedure InitializeSGD(Optim : in out SGD) is
        Velocity : Tensor;
    begin
        for I in Optim.parameters.First_Index .. Optim.parameters.Last_Index loop
            Velocity.Data := new ST_GPU.GPU_Tensor'(Zeros((Optim.parameters (I).Grad.Shape(1), Optim.parameters (I).Grad.Shape(2))));
            Velocity.Grad := new ST_GPU.GPU_Tensor'(Zeros((2,2)));
            Optim.velocities.Append(Velocity);
        end loop;
    end;

    overriding procedure step (Optim: in out SGD) is
    begin
        for I in Optim.parameters.First_Index .. Optim.parameters.Last_Index loop
            Optim.velocities (I).Data.all := ((Orka.Numerics.Singles.Tensors.Element(Optim.momentum) * Optim.velocities (I).Data.all) + Optim.parameters (I).Grad.all) + (Orka.Numerics.Singles.Tensors.Element(Optim.weight_decay) * Optim.parameters (I).Data.all);
            declare
                Momv : GPU_Tensor := Orka.Numerics.Singles.Tensors.Element(Optim.momentum) * Optim.velocities (I).Data.all;
                Wdp : GPU_Tensor := Orka.Numerics.Singles.Tensors.Element(Optim.weight_decay) * Optim.parameters (I).Data.all;
                Added : GPU_Tensor := Momv + Wdp;
            begin
                null;
            end;
            Optim.parameters (I).Data.all := Optim.parameters (I).Data.all - (Orka.Numerics.Singles.Tensors.Element(Optim.lr) * Optim.velocities (I).Data.all);
        end loop; 
    end;


    overriding procedure zero_grad(Optim : in out SGD) is
    begin
        for I of Optim.parameters loop
            I.Grad.all := Zeros(I.Grad.Shape);
        end loop;
    end zero_grad;

end Mlengine.Optimizers;




 
