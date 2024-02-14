with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;
with Mlengine.Optimizers;
with Mlengine.Utilities; use Mlengine.Utilities;
with Orka;
use Orka;
with AUnit.Reporter.Text;
with AUnit.Run;
with Linear_Suite;
with Ada.Numerics. Float_Random; 

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

    procedure GenSpiralData(Data : out CPU_Tensor; Target : out Target_Array; Points_Per_Class, Num_Classes : Integer) is
        Radians_Per_Class : constant Float := 2.0 * Ada.Numerics.Pi / Float(Num_Classes);
        Gen : Ada.Numerics.Float_Random.Generator;
    begin
        Ada.Numerics.Float_Random.Reset(Gen);

        for Class in 0 .. Num_Classes - 1 loop
            for Point_Index in 0 .. Points_Per_Class - 1 loop

                declare
                    R : Float := Float(Point_Index) / Float(Points_Per_Class);
                    Start_Radians : Float := Float(Class) * Radians_Per_Class;
                    End_Radians : Float := (Float(Class) + 1.5) * Radians_Per_Class;
                    T : Float := Start_Radians + (End_Radians - Start_Radians) * R + 0.1 * (Ada.Numerics.Float_Random.Random(Gen) - 0.5);
                    Index : Integer := Class * Points_Per_Class + Point_Index;
                begin
                    Data(Index, 1) := R * Ada.Numerics.Sin(T);
                    Data(Index, 2) := R * Ada.Numerics.Cos(T);
                    Target(Index) := Class;
                end;
            end loop;
        end loop;
    end GenSpiralData;

    procedure Fit(M : in out Model; Data : CPU_Tensor; Target : Target_Array; Batch_Size : Integer; Num_Epochs : Integer; Optimizer : Optimizers.SGD; Loss_Fn : LossFunctions.SoftLossMax_T) is
        Loss_History : Float_Vector.Vector;
        Data_Gen : DataGenerator;
        X : Tensor;
        Y : Target_Array;
        Loss : Float;
        Grad : Tensor;
        Batch : Batch_Result;
    begin
        InitializeNetwork(M);

        for Epoch in 1 .. Num_Epochs loop
            Data_Gen.Counter := 0;
            while Data_Gen.Counter < Data_Gen.Num_Batches loop
                Batch := Data_Gen.Get_Next_Batch;
                X := Batch.Batch_Data;
                Y := Batch.Batch_Target;
                
                Optimizer.Zero_Grad;

                -- Forward pass
                for G of M.Graph loop
                    X := G.all.Forward(X);
                end loop;

                Loss := Loss_Fn.Forward(X, Y);

                -- Backward pass
                Grad := Loss_Fn.Backward;
                for G in Reverse M.Graph loop
                    Grad := G.all.Backward(Grad);
                end loop;

                -- Update parameters
                Optimizer.Step;

                Loss_History.Append(Loss);
                Ada.Text_IO.Put_Line("Loss at epoch = " & Integer'Image(Epoch) & " and iteration = " & Integer'Image(Data_Gen.Counter) & ": " & Float'Image(Loss));

                Data_Gen.Counter := Data_Gen.Counter + 1; -- Increment batch counter
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
