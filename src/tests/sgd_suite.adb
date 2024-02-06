with AUnit.Simple_Test_Cases; use AUnit.Simple_Test_Cases;
with SGD_Step_Test;
with SGD_Zero_Grad_Test;

package body SGD_Suite is

   function SGD_Suite return Access_Test_Suite is
      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test (Test_Case_Access'(new SGD_Step_Test.SGD_Step_Test));
      Ret.Add_Test (Test_Case_Access'(new SGD_Zero_Grad_Test.SGD_Zero_Grad_Test));
      return Ret;
   end SGD_Suite;

end SGD_Suite;