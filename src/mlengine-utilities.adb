with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;

package body Mlengine.Utilities is
    procedure Test is
        LWeights : Tensor;
        LBias : Tensor;
        LInput : Tensor;

        Tensor1 : Tensor;
    begin  
        LWeights.Data := new ST_CPU.CPU_Tensor'(ST_CPU.Zeros((2,2)));
        LWeights.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.Zeros((2,2)));

        LBias.Data := new ST_CPU.CPU_Tensor'(ST_CPU.Zeros((2,2)));
        LBias.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.Zeros((2,2)));

        LInput.Data := new ST_CPU.CPU_Tensor'(ST_CPU.Zeros((2,2)));
        LInput.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.Zeros((2,2)));

        Tensor1.Data := new ST_CPU.CPU_Tensor'(ST_CPU.Zeros((2,2)));
        Tensor1.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.Zeros((2,2)));

        declare
            L : aliased Mlengine.Operators.Linear_T := (LWeights, LBias, LInput);
            Tensor : ST_CPU.CPU_Tensor := L.Forward(Tensor1);
        begin
            Put_Line(Tensor.Image);
        end;
    end;
end Mlengine.Utilities;
