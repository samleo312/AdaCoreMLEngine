with AUnit.Simple_Test_Cases; use AUnit.Simple_Test_Cases;
with Linear_Backward_Test;
with Linear_Forward_Test;

package body Linear_Suite is

   function Linear_Suite return Access_Test_Suite is
      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test (Test_Case_Access'(new Linear_Forward_Test.Linear_Forward_Test));
      Ret.Add_Test (Test_Case_Access'(new Linear_Backward_Test.Linear_Backward_Test));
      return Ret;
   end Linear_Suite;

end Linear_Suite;