with AUnit;
with AUnit.Simple_Test_Cases;

package Linear_Backward_Test is

   type Linear_Backward_Test is new AUnit.Simple_Test_Cases.Test_Case with null record;

   function Name (T : Linear_Backward_Test) return AUnit.Message_String;

   procedure Run_Test (T : in out Linear_Backward_Test);

end Linear_Backward_Test;