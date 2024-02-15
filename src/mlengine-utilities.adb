with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;
with Mlengine.Optimizers;
with Mlengine.Utilities; use Mlengine.Utilities;
with Orka; use Orka;
with AUnit.Reporter.Text;
with AUnit.Run;
with Linear_Suite;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Ada.Numerics; use Ada.Numerics;

package body Mlengine.Utilities is

    procedure Add(M : in out Model; Layer: Mlengine.Operators.Func_Access_T) is
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


    function GenSpiralData(Points_Per_Class : Positive; Num_Classes : Positive) return Batch_Result is
    
        Batch_Size : Constant Integer := Points_Per_Class * Num_Classes;
        Radians_Per_Class : Constant Float := 2.0 * Pi / Float(Num_Classes);
        Gen : Generator;
        Data : Tensor;
        Target : Target_Array(1 .. Batch_Size);
    
    begin
        Data.Data.all := Zeros(Batch_Size, 2);
        Reset(Gen);
        
        for I in 0 .. Num_Classes - 1 loop
            for J in 1 .. Points_Per_Class loop
                declare
                    Index : Integer := I * Points_Per_Class + J;
                    T : Float := Float(I) * Radians_Per_Class + Float(J) / Float(Points_Per_Class) * Radians_Per_Class + 0.1 * Float(Random(Gen));
                    R : Float := Float(J) / Float(Points_Per_Class);
                begin
                    Data.Data.All(Index, 1) := R * Sin(T);
                    Data.Data.All(Index, 2) := R * Cos(T);
                    Target(Index) := I;
                end;
            end loop;
        end loop;
        -- Pass data and target as output params instead
        return Batch_Result'(Batch_Data => Data, Batch_Target => Target);
    end GenSpiralData;




    procedure Fit(M : in out Model; Data : CPU_Tensor; Target : Target_Array; Batch_Size : Integer; Num_Epochs : Integer; Optimizer : Optimizers.SGD; Loss_Fn : LossFunctions.SoftLossMax_T) is
        Loss_History : Float_Vector.Vector;
        Data_Gen : DataGenerator(Batch_Size => Batch_Size, Data => Data, Target => Target);
        Loss : Float;
        Grad : Tensor;
        Batch : Batch_Result;
        Itr : Integer := 0;
    begin
        InitializeNetwork(M);

        for Epoch in 1 .. Num_Epochs loop
            for I in Data_Gen.Target'Range loop
                Optimizer.Zero_Grad;

                -- Forward pass
                for G of M.Graph loop
                    Data_Gen.Data (I) := G.all.Forward(Data_Gen.Data (I));
                end loop;

                Loss := Loss_Fn.Forward(Data_Gen.Data (I), Data_Gen.Target (I));

                -- Backward pass
                Grad := Loss_Fn.Backward;
                for G in Reverse M.Graph loop
                    Grad := G.all.Backward(Grad);
                end loop;

                Optimizer.Step;

                Loss_History.Append(Loss);
                Ada.Text_IO.Put_Line("Loss at epoch = " & Integer'Image(Epoch) & " and iteration = " & Integer'Image(Itr) & ": " & Float'Image(Loss));

                Itr := Itr + 1;
            end loop;
        end loop;
    end Fit;



    function Predict(M : in out Model; Data : CPU_Tensor) return CPU_Tensor is
        X : CPU_Tensor := Data;
    begin
        for G of M.Graph loop
            X := G.all.Forward(X);
        end loop;
        return X;
    end Predict;

    function Calculate_Accuracy(Predicted : CPU_Tensor; TestTargets : Target_Array) return Float is
        Correct : Integer := 0;
    begin
        for I in Predicted'Range loop
            if Predicted(I) = Float(TestTargets(I)) then
                Correct := Correct + 1;
            end if;
        end loop;

        if Predicted'Length > 0 then
            return Float(Correct) / Float(Predicted'Length);
        else
            return 0.0;
        end if;
    end Calculate_Accuracy;
end Mlengine.Utilities;
