with Ada.Text_IO; use Ada.Text_IO;

package body Mlengine.Utilities is
    procedure Test is
        Floats : ST.Element_Array := (1.0, 2.0, 3.0);
    begin
        for F of Floats loop
            Put_Line(F'Image);
        end loop;
    end;
end Mlengine.Utilities;
