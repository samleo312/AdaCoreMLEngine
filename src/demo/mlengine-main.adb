with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators; use Mlengine.Operators;
with Mlengine.Utilities; use Mlengine.Utilities;
with AUnit.Reporter.Text;
with AUnit.Run;
with Linear_Suite; 
with Orka; use Orka;

procedure Mlengine.Main is
    M : Model;

    Layer : Func_Access_T := new Linear_T'(Weights => Tensor'(Data => new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2))), 
    Grad => new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)))), Bias => Tensor'(Data => new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2))), 
    Grad => new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)))), Input => Tensor'(Data => new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2))), 
    Grad => new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)))));

    Activation : Func_Access_T := new ReLU_T;
begin
    Put_Line ("Running Mlengine.Main");

    M.Graph.Append(Layer);
    M.Graph.Append(Activation);


    --declare
    --procedure Runner is new AUnit.Run.Test_Runner (Linear_Suite.Linear_Suite);
    --    Reporter : AUnit.Reporter.Text.Text_Reporter;
    --begin
    --    Runner (Reporter);
    --end;
    
end Mlengine.Main;