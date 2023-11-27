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
        LWeights.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
        LWeights.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

        LBias.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
        LBias.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

        LInput.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
        LInput.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

        Tensor1.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
        Tensor1.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

    
        declare
            L : aliased Mlengine.Operators.Linear_T := (LWeights, LBias, LInput);
            Tensor : ST_CPU.CPU_Tensor := L.Backward(Tensor1);
            Params : Mlengine.Operators.ParamsArray := L.Get_Params; 
            Test : Linear_Test;
        begin
            --Put_Line(Params(1).Data.Image);
            --Put_Line(L.Bias.Grad.Image);
            --Put_Line(Tensor.Image);
            Put_Line("Running Tests");
            Test_Forward(Test);
            Test_Backward(Test);
            Test_GetParams(Test);
            Put_Line("Tests Complete");
        end;
    end;
end Mlengine.Utilities;
