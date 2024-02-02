with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;
with Mlengine.Optimizers;
with SGD_Tests; use SGD_Tests;
with Orka;
use Orka;
with AUnit.Reporter.Text;
with AUnit.Run;
with Linear_Suite; 

package body Mlengine.Utilities is
    procedure Test is
        --SGD variables
        Slr : float;
        Sweight_decay : float;
        Smomentum : float;

        Sten : Tensor;
        Svelocities : aliased ST.Element_Array := (1.0, 2.0, 3.0, 4.0);


    begin  
        --SGD's base parameters
        Slr := 0.001;
        Sweight_decay := 0.01;
        Smomentum := 0.9;

        --SGD's tensor
        Sten.data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor((0.0, 1.0, 2.0, 3.0), (4,1)));
        Sten.grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor((0.0, 1.5, 2.5, 3.5), (4,1)));

        declare
            --S: SGD instance
            S : aliased Mlengine.Optimizers.SGD := (lr           => Slr, 
                                                    weight_decay => Sweight_decay, 
                                                    momentum     => Smomentum, 
                                                    velocities   => Svelocities'Unchecked_Access, 
                                                    t            => Sten);
            
            Test_1 : SGD_Test;
        
        begin
            SGD_Test.Register_Tests(Test_Zero_Grad);
            --  Put_Line("Running Tests");
            --  Test_Step(Test_1);
            --  Test_Zero_Grad(Test_1);
            --  Put_Line("Tests Complete");
        
            --  --print contents of SGD
            --  Put_Line("Data before step: ");
            --  Put_Line(S.t.Data.Image);
            --  Put_Line("Initial Gradient: ");
            --  Put_Line(S.t.Grad.Image);
            --  Put_Line("Velocities before step: ");
            --  for I in S.velocities'Range loop
            --      Put_Line(Float'Image(Float(S.velocities(I))));
            --  end loop;
            --  Put_Line("Data after Step called: ");
            --  S.step;
            --  Put_Line("OFFICIAL: ");
            --  Put_Line(S.t.Data.Image);
            --  S.zero_grad;
            --  Put_Line("Gradients after zero_grad called: ");
            --  Put_Line(S.t.Grad.Image);

            --  Put_Line("Velocities after Step called: ");
            --  for I in S.velocities'Range loop
            --      Put_Line(Float'Image(Float(S.velocities(I))));
            --  end loop;
        


        end;
    end;



    procedure Add(M : in out Model; Layer: Func_Access_T) is
    begin
        M.Graph.Append(Layer);
    end;

    procedure InitializeNetwork(M : in out Model) is
    begin
        for G of M.Graph loop
            G.all.InitializeLayer;
        end loop; 
    end;

    --function Fit(M: in out Model; Data : Tensor; Target : Tensor; Batch_Size : Integer; Num_Epochs : Integer; Optimizer : SGD ; Loss_Fn : SoftmaxWithLoss) is
    --begin
    --    InitializeNetwork(M);
        --imported data from python func here somehow
        --Data_Gen = 
    --    for Epoch in 1 .. Num_Epochs loop
    --        for I in 1 .. Data_Gen'Length loop
    --            Optimizer.zero_grad;
    --            for F in M.Graph.First_Index .. M.Graph.Last_Index loop

     --               X := M.Graph(F).Forward(X);
                    --stef needs to finish his forward and backward and call from a loss_func object like how relu and linear r set up
    --            end loop;
    --            Optimizer.step;
    --        end loop;
    --    end loop;
    --end;

    --function Predict(M : in out Model; Data : Tensor) is
    --    X : Tensor := Data;
    --begin
        
    --end;
end Mlengine.Utilities;
