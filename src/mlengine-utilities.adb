with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;
with Linear_Tests; use Linear_Tests;
with Orka;
use Orka;

package body Mlengine.Utilities is
    procedure Test is
        LWeights : Tensor;
        LBias : Tensor;
        LInput : Tensor;
        Tensor1 : Tensor;

    begin  
        LWeights.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0, 5.0, 6.0), (3,2)));
        LWeights.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0, 5.0, 6.0), (3,2)));

        LBias.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0)));
        LBias.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0)));

        LInput.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0, 5.0, 6.0), (3,2)));
        LInput.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0, 5.0, 6.0), (3,2)));

        Tensor1.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0)));
        Tensor1.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0)));

    
        declare
            L : aliased Mlengine.Operators.Linear_T := (LWeights, LBias, LInput);
            Tensor : ST_CPU.CPU_Tensor := L.Backward(Tensor1);
        begin
            Put_Line("---------------Input Tensor---------------");
            Put_Line(Tensor1.Data.Image);
            Put_Line("------------------------------------------");

            Put_Line("---------------Layer Weights--------------");
            Put_Line(LWeights.Data.Image);
            Put_Line("------------------------------------------");

            Put_Line("-------------------Bias-------------------");
            Put_Line(LBias.Data.Image);
            Put_Line("------------------------------------------");

            Put_Line("-------------------Output-----------------");
            Put_Line(Tensor.Image);
            Put_Line("------------------------------------------");
        end;
    end;
end Mlengine.Utilities;
