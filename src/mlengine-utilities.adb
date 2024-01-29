with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;
with AUnit.Reporter.Text;
with AUnit.Run;
with Linear_Suite; 
with Orka; use Orka;

package body Mlengine.Utilities is

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
