with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators; use Mlengine.Operators;
with Mlengine.Utilities; use Mlengine.Utilities;
with AUnit.Reporter.Text;
with AUnit.Run;
with Linear_Suite; 
with SGD_Suite;
with Orka; use Orka;
with Generate_Gaussian_Random;
with Mlengine.spiraldata; use Mlengine.spiraldata;

procedure Mlengine.Main is
    Points_Per_Class : Integer := 10;
    Num_Classes : Integer := 3;

    M : Model;

    Layer : Func_Access_T := new Linear_T'(Weights => Tensor'(Data => new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2))), 
    Grad => new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)))), Bias => Tensor'(Data => new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2))), 
    Grad => new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)))), Input => Tensor'(Data => new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2))), 
    Grad => new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)))));

    Activation : Func_Access_T := new ReLU_T;

begin
    Put_Line ("Running Mlengine.Main");

    --  M.Graph.Append(Layer);
    --  M.Graph.Append(Activation);

    --  InitializeNetwork(M);
    Put_Line("Done");

    -- Call the procedure to generate spiral data
   Generate_Spiral_Data (Points_Per_Class, Num_Classes);

   -- Perform any further processing or output as needed
   Put_Line ("Spiral data generated successfully.");



    ------------------------ TESTS --------------------------
    --  declare
    --  procedure Runner is new AUnit.Run.Test_Runner (Linear_Suite.Linear_Suite);
    --      Reporter : AUnit.Reporter.Text.Text_Reporter;
    --  begin
    --      Runner (Reporter);
    --  end;

    --  declare
    --  procedure RunnerSGD is new AUnit.Run.Test_Runner (SGD_Suite.SGD_Suite);
    --      ReporterSGD : AUnit.Reporter.Text.Text_Reporter;
    --  begin
    --      RunnerSGD (ReporterSGD);
    --  end;
    
end Mlengine.Main;