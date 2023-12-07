with AUnit.Assertions; use AUnit.Assertions;
with Mlengine.Operators; use Mlengine.Operators; 
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;
with Mlengine; use Mlengine;
with Orka; use Orka;

package body Relu_Tests is

   procedure Test_Forward_R (T : in out Test_Cases.Test_Case'Class) is
       --ReLU vars
        R_Activated : Tensor;
        R_Test_Input : Tensor;
   begin
      R_Activated.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((0.0, 0.0, 0.0, 0.0), (2, 2)));
      R_Activated.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((0.0, 0.0, 0.0, 0.0), (2, 2)));

      R_Test_Input.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, -3.0, 4.0, -5.0), (2, 2)));
      R_Test_Input.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, -3.0, 4.0, -5.0), (2, 2)));

      declare
         --ReLU object
        R : aliased Mlengine.Operators.ReLU_T := (Activated => R_Activated);
        --expected answer
        Answer : ST_CPU.CPU_Tensor := ST.CPU.To_Tensor((1.0, 0.0, 4.0, 0.0), (2,2));
        --result
        Result : ST_CPU.CPU_Tensor := R.Forward(R_Test_Input);
      begin
         Assert (R.Activated.Data.all = Answer, "Forward Function is incorrect");
      end;
      
   end Test_Forward_R;

   procedure Test_Backward_R (T : in out Test_Cases.Test_Case'Class) is
      --ReLU vars
        R_Activated : Tensor;
        R_dY : Tensor;
   begin
      R_Activated.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((0.0, 0.0, 0.0, 0.0), (2, 2)));
      R_Activated.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((0.0, 0.0, 0.0, 0.0), (2, 2)));

      R_dY.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, -3.0, 4.0, -5.0), (2, 2)));
      R_dY.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, -3.0, 4.0, -5.0), (2, 2)));

      declare
         L : aliased Mlengine.Operators.ReLU_T := (Activated => R_Activated);
         Answer : ST_CPU.CPU_Tensor := ST.CPU.To_Tensor((1.0, 0.0, 4.0, 0.0), (2,2));
         Result : ST_CPU.CPU_Tensor := L.Backward(R_dY);
      begin
         Assert (Result = Answer, "Backward Function is incorrect");
      end;
      
   end Test_Backward_R;


   -- Register test routines to call
   procedure Register_Tests (T: in out relutest) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Test_Forward_R'Access, "Test Forward");
      Register_Routine (T, Test_Backward_R'Access, "Test Backward");

   end Register_Tests;

   -- Identifier of test case

   function Name (T: relutest) return Test_String is
   begin
      return Format ("ReLU Tests");
   end Name;

end Relu_Tests;