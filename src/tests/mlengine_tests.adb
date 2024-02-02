with AUnit.Reporter.Text;
with AUnit.Run;
with AUnit.Test_Suites;

with Test_Tensors_CPU_Singles_Vectors;

procedure mlengine_tests is

   function Suite return AUnit.Test_Suites.Access_Test_Suite;

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
      Result : constant AUnit.Test_Suites.Access_Test_Suite :=
        AUnit.Test_Suites.New_Suite;
   begin

    --    Result.Add_Test (Test_Tensors_CPU_Singles_Vectors.Suite);

      return Result;
   end Suite;

   procedure Runner is new AUnit.Run.Test_Runner (Suite);

   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Reporter.Set_Use_ANSI_Colors (True);
   Runner (Reporter);
end mlengine_tests;
