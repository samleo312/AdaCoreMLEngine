with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;

package body Mlengine.Utilities is
    procedure Test is
        L : aliased Mlengine.Operators.Linear_T := (2, 2);
    begin  
        declare
            Tensor : ST_CPU.CPU_Tensor := L.Forward;
        begin
            Put_Line(Tensor.Image);
        end;
    end;
end Mlengine.Utilities;
