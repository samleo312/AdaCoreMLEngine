with Ada.Text_IO; use Ada.Text_IO;
with Mlengine; use Mlengine;
with Mlengine.Optimizers; use Mlengine.Optimizers;
with Mlengine.Operators; use Mlengine.Operators;
with Mlengine.LossFunctions;
with Mlengine.Utilities; use Mlengine.Utilities;
with Mlengine.spiraldata; use Mlengine.spiraldata;
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;

procedure Mlengine.Main is
    Batch_Size        : constant Integer := 10;
    Num_Epochs        : constant Integer := 100;
    Samples_Per_Class : constant Integer := 100;
    Num_Classes       : constant Integer := 3;
    Hidden_Units      : constant Integer := 1000;

    Data       : Tensor;
    M          : aliased Model;
    Optim      : SGD;
    Target     : Mlengine.LossFunctions.Target_Array
                   (1 .. Num_Classes * Samples_Per_Class);
    Target_Batch : Mlengine.LossFunctions.Target_Array
                   (1 .. Batch_Size) := (others => 1);

    Proba_Tensor : Tensor :=
         (Data => new CPU_Tensor'(Zeros ((Batch_Size, Num_Classes))),
       Grad => new CPU_Tensor'(Zeros ((Batch_Size, Num_Classes))));
    Loss_Fn : aliased Mlengine.LossFunctions.SoftLossMax_T :=
      (Size => Batch_Size, Proba => Proba_Tensor, Target => Target_Batch);

    Predicted_Labels : Tensor;
    Accuracy          : Float;

    Layer1 : aliased Linear_T :=
      (Weights =>
         (Data => new CPU_Tensor'(Zeros ((2, Hidden_Units))),
          Grad => new CPU_Tensor'(Zeros ((2, Hidden_Units)))),
       Bias =>
         (Data => new CPU_Tensor'(Zeros ((1, Hidden_Units))),
          Grad => new CPU_Tensor'(Zeros ((1, Hidden_Units)))),
       Input =>
         (Data => null, Grad => null));

    ReLU_Object : aliased ReLU_T :=
      (Activated =>
         (Data => null, Grad => null));

    Layer2 : aliased Linear_T :=
      (Weights =>
         (Data => new CPU_Tensor'(Zeros ((Hidden_Units, Num_Classes))),
          Grad => new CPU_Tensor'(Zeros ((Hidden_Units, Num_Classes)))),
       Bias =>
         (Data => new CPU_Tensor'(Zeros ((1, Num_Classes))),
          Grad => new CPU_Tensor'(Zeros ((1, Num_Classes)))),
       Input =>
         (Data => null, Grad => null));
begin
    Data.Data := new CPU_Tensor'
      (Generate_Spiral_Data (Samples_Per_Class, Num_Classes, Target));
    Data.Grad := new CPU_Tensor'(Zeros (Data.Data.Shape));

    Add (M, Layer1'Unchecked_Access);
    Add (M, ReLU_Object'Unchecked_Access);
    Add (M, Layer2'Unchecked_Access);

    Optim.Parameters := M.Parameters'Unchecked_Access;
    Optim.Lr := 0.1;
    Optim.Weight_Decay := 0.001;
    Optim.Momentum := 0.9;

    Fit (M, Data, Target, Batch_Size, Num_Epochs, Optim, Loss_Fn);

    Predicted_Labels.Data := new CPU_Tensor'(Predict (M, Data));
    Accuracy := Calculate_Accuracy (Predicted_Labels.Data.all, Target);

    Put_Line ("Model Accuracy = " & Float'Image (Accuracy));

    -- Release allocations owned by the layers, dataset, prediction, and
    -- loss object.  Model/optimizer parameter references are non-owning.
    FreeSGD (Optim);
    Free_Tensor (Layer1.Weights);
    Free_Tensor (Layer1.Bias);
    Free_Tensor (Layer1.Input);
    Free_Tensor (Layer2.Weights);
    Free_Tensor (Layer2.Bias);
    Free_Tensor (Layer2.Input);
    Free_Tensor (ReLU_Object.Activated);
    Free_Tensor (Data);
    Free_Tensor (Predicted_Labels);
    Free_Tensor (Loss_Fn.Proba);
end Mlengine.Main;
