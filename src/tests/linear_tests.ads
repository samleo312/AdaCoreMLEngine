with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Linear_Tests is
    type Linear_Test is new Test_Cases.Test_Case with null record;

    procedure Register_Tests (T: in out Linear_Test);
    -- Register routines to be run

    function Name (T: Linear_Test) return Message_String;
    -- Provide name identifying the test case

    -- Test Routines:
    procedure Test_Forward (T : in out Test_Cases.Test_Case'Class);
    procedure Test_Backward (T : in out Test_Cases.Test_Case'Class);
    procedure Test_GetParams (T : in out Test_Cases.Test_Case'Class);

end Linear_Tests;
