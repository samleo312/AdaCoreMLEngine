with AUnit.Assertions; use AUnit.Assertions;
with Mlengine.LossFunctions; use Mlengine.LossFunctions;
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;

package body Softmax_Loss_Test is

   function Create return AUnit.Test_Cases.Test_Case_Access is
   begin
      return new Softmax_Loss_Test_Case'Access;
   end Create;

   overriding procedure Set_Up (T : in out Softmax_Loss_Test_Case) is
   begin
      -- Initialization code before each test
   end Set_Up;

   overriding procedure Tear_Down (T : in out Softmax_Loss_Test_Case) is
   begin
      -- Clean up code after each test
   end Tear_Down;

   overriding procedure Test (T : in out Softmax_Loss_Test_Case) is
      -- Example data for testing
      Data : constant ST_CPU.CPU_Tensor := ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2))); -- Initialize with test data
      Target : constant Target_Array := ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2))); -- Initialize with test targets
      SLM : SoftLossMax_T := 0; -- Initialize SoftLossMax_T
      Expected_Loss : constant Orka.Float_32 := 0.05; -- Expected loss value
      Loss : Orka.Float_32;
   begin
      -- Test the Forward function
      Loss := Forward (SLM, Data, Target);
      Assert (Loss = Expected_Loss, "Forward function failed");

   end Test;

end Softmax_Loss_Test;

