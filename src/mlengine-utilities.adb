with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;
with Linear_Tests; use Linear_Tests;
with Relu_Tests; use Relu_Tests;
with Orka; use Orka;

package body Mlengine.Utilities is
    procedure Test is
        Test_Linear : Linear_Test;
        Test_ReLU : relutest;
    begin  
        
        Put_Line("Running Linear Tests");
        Test_Forward(Test_Linear);
        Test_Backward(Test_Linear);
        Test_GetParams(Test_Linear);
        Put_Line("Linear Tests Complete");

        Put_Line("Running ReLU Tests");
        Test_Forward_R(Test_ReLU);
        Test_Backward_R(Test_ReLU);
        Put_Line("ReLU Tests Complete");

        
    end;
end Mlengine.Utilities;
