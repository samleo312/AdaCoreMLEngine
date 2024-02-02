with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package SGD_Tests is
    type SGD_Test is new Test_Cases.Test_Case with null record;

    procedure Register_Tests (T: in out SGD_Test);
    -- Register routines to be run

    function Name (T: SGD_Test) return Message_String;
    -- Provide name to identify test case

    -- Test Routines:
    procedure Test_Step(T: in out Test_Cases.Test_Case'Class);
    procedure Test_Zero_Grad(T: in out Test_Cases.Test_Case'Class);

end SGD_Tests;
