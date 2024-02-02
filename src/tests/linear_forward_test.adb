with AUnit.Assertions; use AUnit.Assertions;
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;
with Mlengine; use Mlengine;
with Mlengine.Operators;

package body Linear_Forward_Test is

    function Name (T : Linear_Forward_Test) return AUnit.Message_String is
        pragma Unreferenced (T);
    begin
        return AUnit.Format ("Test Linear Forward Function");
    end Name;

    procedure Run_Test (T : in out Linear_Forward_Test) is
      TestWeights : Tensor;
      TestBias : Tensor;
      TestInput : Tensor;
      InputTensor : Tensor;
   begin
      TestWeights.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
      TestWeights.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

      TestBias.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
      TestBias.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

      TestInput.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
      TestInput.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

      InputTensor.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
      InputTensor.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

      declare
         L : aliased Mlengine.Operators.Linear_T := (TestWeights, TestBias, TestInput);
         Answer : ST_CPU.CPU_Tensor := ST.CPU.To_Tensor((8.0, 12.0, 18.0, 26.0), (2,2));
         Result : ST_CPU.CPU_Tensor := L.Forward(InputTensor);
      begin
         Assert (Result = Answer, "Forward Function is incorrect");
      end;
      
   end Run_Test;

end Linear_Forward_Test;

--procedure Test_GetParams (T : in out Test_Cases.Test_Case'Class) is
--      TestWeights : Tensor;
--      TestBias : Tensor;
--      TestInput : Tensor;
--   begin
--      TestWeights.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
--      TestWeights.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
--
--      TestBias.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
--      TestBias.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
--
--      TestInput.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
--      TestInput.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2))); 
--
--      declare
--         L : aliased Mlengine.Operators.Linear_T := (TestWeights, TestBias, TestInput);
--      begin
--         Assert (1 = 1, "Get_Params Function is incorrect");
--      end;
--      
--   end Test_GetParams;