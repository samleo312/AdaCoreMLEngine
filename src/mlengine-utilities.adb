with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;
with Linear_Tests; use Linear_Tests;
with Orka; use Orka;

package body Mlengine.Utilities is
    procedure Test is
        Test : Linear_Test;
    begin  
        
        Put_Line("Running Tests");
        Test_Forward(Test);
        Test_Backward(Test);
        Test_GetParams(Test);
        Put_Line("Tests Complete");
        
    end;
end Mlengine.Utilities;
