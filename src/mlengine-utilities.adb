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
with Ada.Numerics.Generic_Elementary_Functions;



package body Mlengine.Utilities is

    procedure Add(M : in out Model; Layer: Mlengine.Operators.Func_Access_T) is
        Params : ParamsArray := Layer.Get_Params;
    begin
        M.Graph.Append(Layer);
        
        M.Parameters.Append(Params (1));
        M.Parameters.Append(Params (2));
    end;

    --  procedure InitializeNetwork(M : in out Model) is
    --  begin
    --      for G of M.Graph loop
    --          G.all.InitializeLayer;
    --      end loop; 
    --  end;


    function GenSpiralData(Points_Per_Class : Positive; Num_Classes : Positive) return Batch_Result is
        package Real_Functions is new Ada.Numerics.Generic_Elementary_Functions (Orka.Float_32);
        Batch_Size : Constant Integer := Points_Per_Class * Num_Classes;
        Radians_Per_Class : Constant  Orka.Float_32 := 2.0 * Pi /  Orka.Float_32(Num_Classes);
        Gen : Generator;
        Data : Tensor;
        Target : Target_Array(1 .. Batch_Size);
    
    begin
        Data.Data.all := Zeros((Batch_Size, 2));
        Reset(Gen);
        
        for I in 0 .. Num_Classes - 1 loop
            for J in 1 .. Points_Per_Class loop
                declare
                    Index : Integer := I * Points_Per_Class + J;
                    T :  Orka.Float_32 :=  Orka.Float_32(I) * Radians_Per_Class +  Orka.Float_32(J) /  Orka.Float_32(Points_Per_Class) * Radians_Per_Class + 0.1 *  Orka.Float_32(Random(Gen));
                    R : Float := Float(J) / Float(Points_Per_Class);
                    R_Sin :  Orka.Float_32 := Real_Functions.Sin(T);
                    Idx_I1 : ST.Tensor_Index := (Index, 1);
                    Idx_I2 : ST.Tensor_Index := (Index, 2);
                    R_Cos : Orka.Float_32 := Real_Functions.Cos(T);
                begin
                    Data.Data.Set (Idx_I1, R_Sin);
                    Data.Data.Set (Idx_I2, R_Cos);
                    --Data.Data((Index, 1)) := R * Sin(T);
                    --Data.Data((Index, 2)) := R * Cos(T);
                    Target(Index) := I;
                end;
            end loop;
        end loop;
        -- Pass data and target as output params instead
        --data should be 150x2
        return Batch_Result'(Batch_Size => Batch_Size, Batch_Data => Data, Batch_Target => Target);
    end GenSpiralData;




    procedure Fit(M : in out Model; Data : Tensor; Target : Target_Array; Batch_Size : Integer; Num_Epochs : Integer; Optimizer : in out Optimizers.SGD; Loss_Fn : LossFunctions.SoftLossMax_T) is
        Loss_History : Float_Vector.Vector;
        --Data_Gen : DataGenerator(Batch_Size => Batch_Size, Data => Data, Target => Target);
    
        -- Initialize the Data_Gen record. Note: The direct assignment method for 'Target' needs adjustment
        -- due to the nature of its definition in the record.
        Data_Gen : DataGenerator := (Batch_Size => Batch_Size,
                                    Data => Data, -- Direct assignment from the parameter
                                    Num_Batches => (Data.Data.Shape(1)/Batch_Size), -- Initialize appropriately (300/20)
                                    Target => Target, -- Placeholder, needs proper initialization
                                    Counter => 0);
        Loss : Float;
        Grad : Tensor;
        Batch : Batch_Result := (Batch_Size => Batch_Size, Batch_Data => Data, Batch_Target => Target);
        Itr : Integer := 0;
        Starter : Integer := 1;

    begin
        InitializeNetwork(M);

        for Epoch in 1 .. Num_Epochs loop
            for I in 1 .. Data_Gen.Num_Batches loop
                declare
                    --needs to be first 20, 15 times;
                    Data_Batch : CPU_Tensor := Data_Gen.Data.Data.Get(Range_Type'(Start => Starter, Stop => (Batch_Size*I)));
                    Target_Batch : Target_Array(1 .. Batch_Size) := Target(Starter .. (Batch_Size*I));
                begin
                Optimizer.Zero_Grad;

                -- Forward pass
                --x y in datagen, x is 20x2 tensor, assuming coords, y is 20x1 target array
                for G of M.Graph loop
                    Data_Batch := Mlengine.Operators.Forward(G.all,Data_Batch); --(1,20)(21,40)(41,60)....
                end loop;

                Loss := Loss_Fn.Forward(Data_Batch, Target_Batch);

    --              -- Backward pass
    --              Grad := Loss_Fn.Backward;
    --              for G in Reverse M.Graph loop
    --                  Grad := G.all.Backward(Grad);
    --              end loop;

    --              Optimizer.Step;

    --              Loss_History.Append(Loss);
    --              Ada.Text_IO.Put_Line("Loss at epoch = " & Integer'Image(Epoch) & " and iteration = " & Integer'Image(Itr) & ": " & Float'Image(Loss));

                Itr := Itr + 1;
                end;
            end loop;
             Starter := Starter + Batch_Size;
        end loop;
        
    end Fit;



    --  function Predict(M : in out Model; Data : CPU_Tensor) return CPU_Tensor is
    --      X : CPU_Tensor := Data;
    --  begin
    --      for G of M.Graph loop
    --          X := G.all.Forward(X);
    --      end loop;
    --      return X;
    --  end Predict;

    --  function Calculate_Accuracy(Predicted : CPU_Tensor; TestTargets : Target_Array) return Float is
    --      Correct : Integer := 0;
    --  begin
    --      for I in Predicted'Range loop
    --          if Predicted(I) = Float(TestTargets(I)) then
    --              Correct := Correct + 1;
    --          end if;
    --      end loop;

    --      if Predicted'Length > 0 then
    --          return Float(Correct) / Float(Predicted'Length);
    --      else
    --          return 0.0;
    --      end if;
    --  end Calculate_Accuracy;
end Mlengine.Utilities;
