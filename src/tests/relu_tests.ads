with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Relu_Tests is
    type relutest is new Test_Cases.Test_Case with null record;

    procedure relutest (T: in out relutest);
    -- Register routines to be run

    function Name (T: relutest) return Message_String;
    -- Provide name identifying the test case

    -- Test Routines:
    procedure Test_Forward (T : in out Test_Cases.Test_Case'Class);
    procedure Test_Backward (T : in out Test_Cases.Test_Case'Class);

end Relu_Tests;