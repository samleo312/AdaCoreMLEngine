  with Ada.Text_IO; use Ada.Text_IO;
  with Mlengine; use Mlengine;
  with Mlengine.Optimizers; use Mlengine.Optimizers;
  with Mlengine.Operators; use Mlengine.Operators;
  with Mlengine.LossFunctions;
  with Mlengine.Utilities; use Mlengine.Utilities;
<<<<<<< HEAD
--  with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;
=======
  with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;
>>>>>>> 18ffd91a4d057a1d602731f69dfe2d674230d296

procedure Main is
    --  package ST renames Orka.Numerics.Singles.Tensors;
    --  package ST_CPU renames Orka.Numerics.Singles.Tensors.CPU;

    --  Batch_Size        : constant Integer := 20;
    --  Num_Epochs        : constant Integer := 200;
    --  Samples_Per_Class : constant Integer := 100;
    --  Num_Classes       : constant Integer := 3;
    --  Hidden_Units      : constant Integer := 100;

    --  Data              : CPU_Tensor := ST_CPU.Zeros((Samples_Per_Class, Num_Classes));
    --  Target_A            : LossFunctions.Target_Array(1 .. Samples_Per_Class) := (others => 0);
    --  M                 : Model;
    --  Optim             : SGD;

    --  Proba_Tensor : Tensor;
    --  Target : Target_Array(1 .. Samples_Per_Class) := (others => 0);
    --  Loss_Fn           : aliased Mlengine.LossFunctions.SoftLossMax_T := (Size => Samples_Per_Class, Proba => Proba_Tensor, Target => Target_A);

    --  Predicted_Labels  : CPU_Tensor := ST_CPU.Zeros((Samples_Per_Class, Num_Classes));
    --  Accuracy          : Float;

    --   use ST_CPU;
 
    --  Layer1_Tensor : constant CPU_Tensor := Zeros ((2, Hidden_Units));
    --  Layer2_Tensor : constant CPU_Tensor := Zeros ((Hidden_Units, Num_Classes));
    --  Activated_Tensor : Tensor;

    --  Weights_Data, Weights_Grad, Bias_Data, Bias_Grad, Input_Data, Input_Grad 
    --      : constant Tensor_Access := new CPU_Tensor'(Layer1_Tensor);

    --  Weights_Tensor : constant Tensor := (Weights_Data, Weights_Grad);
    --  Bias_Tensor    : constant Tensor := (Bias_Data, Bias_Grad);
    --  Input_Tensor   : constant Tensor := (Input_Data, Input_Grad);

    --  Layer1 : aliased Func_Access_T := new Linear_T'(Weights => Weights_Tensor, 
    --                               Bias    => Bias_Tensor, 
    --                               Input   => Input_Tensor);

    --  ReLU_Object : aliased Func_Access_T := new ReLU_T'(Activated => Activated_Tensor);


    --  Layer2_Weights_Data, Layer2_Weights_Grad, Layer2_Bias_Data, Layer2_Bias_Grad, Layer2_Input_Data, Layer2_Input_Grad 
    --      : constant Tensor_Access := new CPU_Tensor'(Layer2_Tensor);


    --  Layer2_Weights_Tensor : constant Tensor := (Layer2_Weights_Data, Layer2_Weights_Grad);
    --  Layer2_Bias_Tensor    : constant Tensor := (Layer2_Bias_Data, Layer2_Bias_Grad);
    --  Layer2_Input_Tensor   : constant Tensor := (Layer2_Input_Data, Layer2_Input_Grad);

    --  Layer2 : aliased Func_Access_T := new Linear_T'(Weights => Layer2_Weights_Tensor, 
    --                               Bias    => Layer2_Bias_Tensor, 
    --                               Input   => Layer2_Input_Tensor);
    Optim : SGD;
    M: Model;

<<<<<<< HEAD
begin

    --  Optim.lr :=
    --  Optim.weight_decay :=
    --  Optim.momentum :=
    --  Optim
    --  lr, weight_decay, momentum : Float;
    --      t : Tensor;
    --      velocities : Elements_Access;
    null;




=======
    Layer1_Tensor : constant CPU_Tensor := To_Tensor((1.0, 2.0, 3.0, 4.0, 5.0, 6.0), (2,3));
    Weights_Data, Weights_Grad, Bias_Data, Bias_Grad, Input_Data, Input_Grad 
        : constant Tensor_Access := new CPU_Tensor'(Layer1_Tensor);
>>>>>>> 18ffd91a4d057a1d602731f69dfe2d674230d296

    Weights_Tensor : constant Tensor := (Weights_Data, Weights_Grad);
    Bias_Tensor    : constant Tensor := (Bias_Data, Bias_Grad);
    Input_Tensor   : constant Tensor := (Input_Data, Input_Grad);

    Layer1 : aliased Func_Access_T := new Linear_T'(Weights => Weights_Tensor, 
                                 Bias    => Bias_Tensor, 
                                 Input   => Input_Tensor);
begin
    Add(M, Layer1);

    Optim.lr := 0.1;
    Optim.weight_decay := 0.0001;
    Optim.momentum := 0.9;
    Optim.parameters := M.Parameters;

    InitializeSGD(Optim);
    Optim.step;

      for I in Optim.velocities.First_Index .. Optim.velocities.Last_Index loop
          Put_Line(Optim.velocities (I).Data.all.Image);
      end loop;
    
    null;

    --  GenSpiralData(Data, Target, Samples_Per_Class, Num_Classes);

    --  InitializeNetwork(M);

    --  Add(M, Layer1);
    --  Add(M, ReLU_Object);
    --  Add(M, Layer2);

    --  Optim.Parameters := M.Parameters;
    --  Optim.Lr := 1.0;
    --  Optim.Weight_Decay := 0.001;
    --  Optim.Momentum := 0.9;


    --  Fit(M, Data, Target, Batch_Size, Num_Epochs, Optim, Loss_Fn);

    --  Predicted_Labels := Predict(M, Data);
    --  Accuracy := Calculate_Accuracy(Predicted_Labels, Target);

    --  Put_Line("Model Accuracy = " & Float'Image(Accuracy));

end Main;
