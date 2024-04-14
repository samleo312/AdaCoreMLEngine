with AUnit.Test_Cases;
with Mlengine.LossFunctions; use Mlengine.LossFunctions;

package Softmax_Loss_Test is

   type Softmax_Loss_Test_Case is new AUnit.Test_Cases.Test_Case with private;

   -- Factory function to create test cases
   function Create return AUnit.Test_Cases.Test_Case_Access;

private

   type Softmax_Loss_Test_Case is new AUnit.Test_Cases.Test_Case with null record;

end Softmax_Loss_Test;