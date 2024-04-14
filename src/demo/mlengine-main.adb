  with Ada.Text_IO; use Ada.Text_IO;
  with Mlengine; use Mlengine;
  with Mlengine.Optimizers; use Mlengine.Optimizers;
  with Mlengine.Operators; use Mlengine.Operators;
  with Mlengine.LossFunctions;
  with Mlengine.Utilities; use Mlengine.Utilities;
  with Mlengine.spiraldata; use Mlengine.spiraldata;
  with Orka.Numerics.Singles.Tensors.GPU; use Orka.Numerics.Singles.Tensors.GPU;

procedure Main is
    package ST renames Orka.Numerics.Singles.Tensors;
    package ST_GPU renames Orka.Numerics.Singles.Tensors.GPU;

    Batch_Size        : constant Integer := 10;
    Num_Epochs        : constant Integer := 100;
    Samples_Per_Class : constant Integer := 100;
    Num_Classes       : constant Integer := 3;
    Hidden_Units      : constant Integer := 100;

    Data              : Tensor;-- := Tensor'(Data => new GPU_Tensor'(ST_GPU.Zeros((Samples_Per_Class, 2))), Grad => new GPU_Tensor'(ST_GPU.Zeros((Samples_Per_Class * Num_Classes, 2))));
    Target_A            : LossFunctions.Target_Array(1 .. Batch_Size) := (others => 1);
    M                 : Model;
    Optim             : SGD;

    Proba_Tensor : Tensor := Tensor'(Data => new GPU_Tensor'(ST_GPU.Zeros((Batch_Size, 3))), Grad => new GPU_Tensor'(ST_GPU.Zeros((Batch_Size, 3))));
    Target : Mlengine.LossFunctions.Target_Array (1..(Num_Classes * Samples_Per_Class)) := (others => 1);
    Loss_Fn           : aliased Mlengine.LossFunctions.SoftLossMax_T := (Size => Batch_Size, Proba => Proba_Tensor, Target => Target_A);

    Predicted_Labels  : Tensor;
    Accuracy          : Float;

    use ST_GPU;
 
    Layer1_Tensor : constant GPU_Tensor := Zeros ((2, Hidden_Units));
    Layer2_Tensor : constant GPU_Tensor := Zeros ((Hidden_Units, Num_Classes));
    Activated_Tensor : Tensor;

    Weights_Data, Weights_Grad, Bias_Data, Bias_Grad, Input_Data, Input_Grad 
        : constant Tensor_Access := new GPU_Tensor'(Layer1_Tensor);

    Weights_Tensor : constant Tensor := (Weights_Data, Weights_Grad);
    Bias_Tensor    : constant Tensor := (Bias_Data, Bias_Grad);
    Input_Tensor   : constant Tensor := (Input_Data, Input_Grad);

    Layer1 : aliased Func_Access_T := new Linear_T'(Weights => Weights_Tensor, 
                                 Bias    => Bias_Tensor, 
                                 Input   => Input_Tensor);

    ReLU_Object : aliased Func_Access_T := new ReLU_T'(Activated => Activated_Tensor);


    Layer2_Weights_Data, Layer2_Weights_Grad, Layer2_Bias_Data, Layer2_Bias_Grad, Layer2_Input_Data, Layer2_Input_Grad 
        : constant Tensor_Access := new GPU_Tensor'(Layer2_Tensor);


    Layer2_Weights_Tensor : constant Tensor := (Layer2_Weights_Data, Layer2_Weights_Grad);
    Layer2_Bias_Tensor    : constant Tensor := (Layer2_Bias_Data, Layer2_Bias_Grad);
    Layer2_Input_Tensor   : constant Tensor := (Layer2_Input_Data, Layer2_Input_Grad);

    Layer2 : aliased Func_Access_T := new Linear_T'(Weights => Layer2_Weights_Tensor, 
                                 Bias    => Layer2_Bias_Tensor, 
                                 Input   => Layer2_Input_Tensor);
begin
    Data.Data := new GPU_Tensor'(Generate_Spiral_Data(Samples_Per_Class, Num_Classes, Target));
    Data.Grad := new GPU_Tensor'(Zeros(Data.Data.Shape));
    
    --Put_Line("Data " & Data.Data.all.Image);
    InitializeNetwork(M);

    Add(M, Layer1);
    Add(M, ReLU_Object); --RELU is breaking because the activated tensor is not initialized to anything above. Initialize it to fix.
    Add(M, Layer2);

    Optim.Parameters := M.Parameters;
    Optim.Lr := 0.1;
    Optim.Weight_Decay := 0.001;
    Optim.Momentum := 0.9;

    InitializeSGD(Optim);

    Fit(M, Data, Target, Batch_Size, Num_Epochs, Optim, Loss_Fn);

    Predicted_Labels.Data := new GPU_Tensor'(Predict(M, Data));
    Accuracy := Calculate_Accuracy(Predicted_Labels.Data.all, Target);

    Put_Line("Model Accuracy = " & Float'Image(Accuracy));

end Main;
