with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Relu_Tests is
    type relutest is new Test_Cases.Test_Case with null record;

    procedure Register_Tests (T: in out relutest);

    function Name (T: relutest) return Message_String;
    -- Provide name identifying the test case

    -- Test Routines:
    procedure Test_Forward_R (T : in out Test_Cases.Test_Case'Class);
    procedure Test_Backward_R (T : in out Test_Cases.Test_Case'Class);

end Relu_Tests;