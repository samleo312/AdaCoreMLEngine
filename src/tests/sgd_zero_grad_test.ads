with AUnit;
with AUnit.Simple_Test_Cases;

package SGD_Zero_Grad_Test is

   type SGD_Zero_Grad_Test is new AUnit.Simple_Test_Cases.Test_Case with null record;

   function Name (T : SGD_Zero_Grad_Test) return AUnit.Message_String;

   procedure Run_Test (T : in out SGD_Zero_Grad_Test);

end SGD_Zero_Grad_Test;