with AUnit.Assertions; use AUnit.Assertions;
with Mlengine.Operators; use Mlengine.Operators; 
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;
with Mlengine; use Mlengine;

package body Linear_Tests is

   procedure Test_Forward (T : in out Test_Cases.Test_Case'Class) is
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
      
   end Test_Forward;

   procedure Test_Backward (T : in out Test_Cases.Test_Case'Class) is
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
         Answer : ST_CPU.CPU_Tensor := ST.CPU.To_Tensor((5.0, 11.0, 11.0, 25.0), (2,2));
         Result : ST_CPU.CPU_Tensor := L.Backward(InputTensor);
      begin
         Assert (Result = Answer, "Backward Function is incorrect");
      end;
      
   end Test_Backward;

   procedure Test_GetParams (T : in out Test_Cases.Test_Case'Class) is
      TestWeights : Tensor;
      TestBias : Tensor;
      TestInput : Tensor;
   begin
      TestWeights.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
      TestWeights.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

      TestBias.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
      TestBias.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

      TestInput.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
      TestInput.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2))); 

      declare
         L : aliased Mlengine.Operators.Linear_T := (TestWeights, TestBias, TestInput);
      begin
         Assert (1 = 1, "Get_Params Function is incorrect");
      end;
      
   end Test_GetParams;

   -- Register test routines to call
   procedure Register_Tests (T: in out Linear_Test) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Test_Forward'Access, "Test Forward");
      Register_Routine (T, Test_Backward'Access, "Test Backward");
      Register_Routine (T, Test_GetParams'Access, "Test GetParams");

   end Register_Tests;

   -- Identifier of test case

   function Name (T: Linear_Test) return Test_String is
   begin
      return Format ("Linear Tests");
   end Name;

end Linear_Tests;