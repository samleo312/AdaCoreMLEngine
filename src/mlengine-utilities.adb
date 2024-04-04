with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;
with Mlengine.Optimizers;
with Mlengine.LossFunctions; use Mlengine.LossFunctions;
with Orka; use Orka;
with Orka.Numerics.Singles.Tensors; use Orka.Numerics.Singles.Tensors;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Ada.Numerics; use Ada.Numerics;
with Ada.Numerics.Generic_Elementary_Functions;



package body Mlengine.Utilities is

    procedure Add(M : in out Model; Layer: Mlengine.Operators.Func_Access_T) is
        Params : ParamsArray := Layer.Get_Params;
    begin
        M.Graph.Append(Layer);
        
        M.Parameters.Append(Params (1));
        M.Parameters.Append(Params (2));
    end;

    procedure InitializeNetwork(M : in out Model) is
    begin
        for G of M.Graph loop
            G.all.InitializeLayer;
        end loop; 
    end;


    procedure Fit(M : in out Model; Data : Tensor; Target : Target_Array; Batch_Size : Integer; Num_Epochs : Integer; Optimizer : in out Optimizers.SGD; Loss_Fn : in out LossFunctions.SoftLossMax_T) is
        Loss_History : Float32_Vector.Vector;
    
        Num_Batches : Integer := Data.Data.Shape(1)/Batch_Size;
        Counter : Integer := 0;
        
        Loss : Float_32;
        Grad : Tensor;
        Itr : Integer := 0;
        Starter : Integer := 1;

    begin
        InitializeNetwork(M);

        for Epoch in 1 .. Num_Epochs loop
            for I in 1 .. Num_Batches loop
                declare
                    --needs to be first 20, 15 times;
                    Data_Batch : Tensor := Tensor'(Data => new CPU_Tensor'(Data.Data.all.Get(Range_Type'(Start => Starter, Stop => (Batch_Size*I)))),
                    Grad => new CPU_Tensor'(Data.Grad.all.Get(Range_Type'(Start => Starter, Stop => (Batch_Size*I)))));
                    Target_Batch : Mlengine.LossFunctions.Target_Array(1 .. Batch_Size) := Target(Starter .. (Batch_Size*I));
                    X : Tensor := Data_Batch;
                begin
                Optimizer.Zero_Grad;

                -- Forward pass
                --x y in datagen, x is 20x2 tensor, assuming coords, y is 20x1 target array
                
                for G of M.Graph loop
                    X.Data := new CPU_Tensor'(Mlengine.Operators.Forward(G.all,X));
                end loop;



                Loss := Loss_Fn.Forward(Data_Batch.Data.all, Target_Batch);

              -- Backward pass
                Grad.Data := new CPU_Tensor'(Loss_Fn.Backward);
                for G of Reverse M.Graph loop
                    Grad.Data := new CPU_Tensor'(G.all.Backward(Grad));
                end loop;

                Optimizer.Step;

                Loss_History.Append(Loss);
                Put_Line("Loss at epoch = " & Integer'Image(Epoch) & " and iteration = " & Integer'Image(Itr) & ": " & Float'Image(Float(Loss)));

                Itr := Itr + 1;
                end;

                Starter := Starter + Batch_Size;

            end loop;
        end loop;
        
    end Fit;

    --  function Predict(M : in out Model; Data : Tensor) return CPU_Tensor is
    --      X : Tensor := Data;
    --  begin
    --      for G of M.Graph loop
    --          X.Data.all := G.all.Forward(X);
    --      end loop;
    --      return X.Data.all;
    --  end Predict;

    function Calculate_Accuracy(Predicted : CPU_Tensor; TestTargets : Target_Array) return Float is
        function ArgMax (Row : CPU_Tensor) return Natural is
            Max_Index : Integer := 1;
        begin
            for I in 2 .. Row.Shape(2) loop
                declare
                    Row_Value : Float_32 := Row(I);
                    Max_Value : Float_32 := Row(Max_Index);
                begin
                    if Row_Value > Max_Value then
                        Max_Index := I;
                    end if;
                end;
            end loop;
            return Max_Index;
        end ArgMax;

        Correct_Predictions : Natural := 0;
        Accuracy : Float;
    begin        
        -- Calculate the number of correct predictions
        for I in 1 .. Predicted.Shape(1) loop
            if ArgMax (Predicted (I)) = TestTargets(I) then
                Correct_Predictions := Correct_Predictions + 1;
            end if;
        end loop;

        -- Calculate accuracy
        Accuracy := Float(Correct_Predictions / TestTargets'Length);
        return Accuracy;
    end Calculate_Accuracy;
end Mlengine.Utilities;
