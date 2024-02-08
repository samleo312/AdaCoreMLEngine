with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;
with Mlengine.Optimizers;
with Mlengine.Utilities; use Mlengine.Utilities;
with Orka;
use Orka;
with AUnit.Reporter.Text;
with AUnit.Run;
with Linear_Suite; 

package body Mlengine.Utilities is

    procedure Add(M : in out Model; Layer: Func_Access_T) is
    begin
        M.Graph.Append(Layer);
        M.Parameters.Append(Layer.Get_Params);
    end;

    procedure InitializeNetwork(M : in out Model) is
    begin
        for G of M.Graph loop
            G.all.InitializeLayer;
        end loop; 
    end;

    function Fit(M: in out Model; Data : Tensor; Target : Tensor; Batch_Size : Integer; Num_Epochs : Integer; Optimizer : SGD ; Loss_Fn : SoftLossMax_T) is
        Gen_Data : DataGenerator;
        LossHistory : Float_Vector.Vector;
        Itr : Integer := 0;
    begin
        InitializeNetwork(M);


        Gen_Data.Data.Data := ST.CPU.To_Tensor((0.05419138, 0.10842358, -0.16752893, 0.561395, 0.7311231, 0.60580504, -0.26001516, -0.46796957, 0.5362811, -0.39603913, 0.26051527, 0.15478744, -0.10809994, 0.5860736, 0.05174225, -0.04818951, -0.24336624, 0.09871892, 0.14073071, -0.86744624, 0.35767263, -0.78053826, -0.26843658, 0.35422122, 0.57703453, -0.35361794, -0.3348171, 0.11351098, -0.60558337, -0.32412556, -0.79294413, -0.08950639, -0.05379663, -0.359635, 0.5690315, -0.08774939, 0.00433535, 0.0604508, -0.8164081, -0.05384514), 
                                            (20,2));
        Gen_Data.Target := (1, 3, 3, 2, 1, 1, 3, 2, 3, 1, 1, 3, 1, 3, 2, 2, 2, 1, 1, 2);

        for Epoch in 1 .. Num_Epochs loop
            for I in 1 .. Data_Gen.Target'Range loop
                Optimizer.zero_grad;
                for F in M.Graph.First_Index .. M.Graph.Last_Index loop
                    Data_Gen.Data (I) := F.Forward;
                end loop;
                
                declare
                    Loss : Orka.Float_32 := Forward(Loss_Fn, Data_Gen.Data, Data.Gen.Target);
                    Grad : Tensor;
                begin
                    Grad.Data := new ST_CPU.CPU_Tensor'(Loss_Fn.Backward);

                    for F in reverse M.Graph'Range loop
                        Grad.Data.all := F.Backward(Grad);
                    end loop;

                    LossHistory.Append(Loss);
                    Itr := Itr + 1; 
                end;

                
                Optimizer.step;
            end loop;
        end loop;
        return LossHistory;
    end;

    function Predict(M : in out Model; Data : Tensor) is
        X : Tensor := Data;
    begin
        
    end;
end Mlengine.Utilities;
