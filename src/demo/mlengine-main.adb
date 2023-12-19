with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;
with AUnit.Reporter.Text;
with AUnit.Run;
with Linear_Suite; 
with Orka; use Orka;

procedure Mlengine.Main is
begin
    Put_Line ("Running Mlengine.Main");

    declare
    procedure Runner is new AUnit.Run.Test_Runner (Linear_Suite.Linear_Suite);
        Reporter : AUnit.Reporter.Text.Text_Reporter;
    begin
        Runner (Reporter);
    end;
    
end Mlengine.Main;