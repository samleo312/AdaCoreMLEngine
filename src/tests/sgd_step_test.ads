with AUnit;
with AUnit.Simple_Test_Cases;

package SGD_Step_Test is

   type SGD_Step_Test is new AUnit.Simple_Test_Cases.Test_Case with null record;

   function Name (T : SGD_Step_Test) return AUnit.Message_String;

   procedure Run_Test (T : in out SGD_Step_Test);

end SGD_Step_Test;