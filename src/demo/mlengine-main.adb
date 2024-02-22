  with Ada.Text_IO; use Ada.Text_IO;
  with Mlengine; use Mlengine;
  with Mlengine.Optimizers; use Mlengine.Optimizers;
  with Mlengine.Operators; use Mlengine.Operators;
  with Mlengine.LossFunctions; use Mlengine.LossFunctions;
  with Mlengine.Utilities; use Mlengine.Utilities;
  with Orka; use Orka;
  with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;

procedure Main is

    TestWeights : Tensor;
    TestBias : Tensor;
    TestInput : Tensor;
    InputTensor : Tensor;    

    R_Forward_Activated : Tensor;
    R_Backward_Activated : Tensor;
    R_Test_Input : Tensor;

    R_dY : Tensor;

    Proba : Tensor;
    Target : Target_Array(1 .. 20);
    X: Tensor; --input
    X_Target : Target_Array := (1, 3, 3, 2, 1, 2, 3, 3, 2, 2, 3, 2, 1, 1, 2, 3, 2, 3, 1, 2);
    E : aliased Mlengine.LossFunctions.SoftLossMax_T(Size => 20);

    Optim : SGD;
    M: Model;

    Layer1_Tensor : constant CPU_Tensor := To_Tensor((1.0, 2.0, 3.0, 4.0, 5.0, 6.0), (2,3));
    Weights_Data, Weights_Grad, Bias_Data, Bias_Grad, Input_Data, Input_Grad 
        : constant Tensor_Access := new CPU_Tensor'(Layer1_Tensor);

    Weights_Tensor : constant Tensor := (Weights_Data, Weights_Grad);
    Bias_Tensor    : constant Tensor := (Bias_Data, Bias_Grad);
    Input_Tensor   : constant Tensor := (Input_Data, Input_Grad);

    Layer1 : aliased Mlengine.Operators.Func_Access_T := new Linear_T'(Weights => Weights_Tensor, 
                                 Bias    => Bias_Tensor, 
                                 Input   => Input_Tensor);

begin
  ----------------------------- LINEAR LAYERS -------------------------------------
    --  TestWeights.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
    --  TestWeights.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

    --  TestBias.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
    --  TestBias.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

    --  TestInput.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
    --  TestInput.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

    --  InputTensor.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
    --  InputTensor.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

    --  declare
    --      L : aliased Mlengine.Operators.Linear_T := (TestWeights, TestBias, TestInput);
    --      Answer : ST_CPU.CPU_Tensor := ST.CPU.To_Tensor((8.0, 12.0, 18.0, 26.0), (2,2));
    --      ForwardResult : ST_CPU.CPU_Tensor := L.Forward(InputTensor);
    --      BackwardResult : ST_CPU.CPU_Tensor := L.Backward(InputTensor);
    --  begin
    --      Put_Line("Linear Forward Result: ");
    --      Put_Line(ForwardResult.Image);

    --      Put_Line("Linear Backward Result: ");
    --      Put_Line(BackwardResult.Image);
    --  end;
  ----------------------------------------------------------------------------------
  ----------------------------------- RELU -----------------------------------------
    --  R_Forward_Activated.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((0.0, 0.0, 0.0, 0.0), (2, 2)));
    --  R_Forward_Activated.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((0.0, 0.0, 0.0, 0.0), (2, 2)));

    --  R_Backward_Activated.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 0.0, 4.0, 0.0), (2, 2)));
    --  R_Backward_Activated.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 0.0, 4.0, 0.0), (2, 2)));

    --  R_Test_Input.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, -3.0, 4.0, -5.0), (2, 2)));
    --  R_Test_Input.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, -3.0, 4.0, -5.0), (2, 2)));

    --  R_dY.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 3.0, 4.0, 5.0), (2, 2)));
    --  R_dY.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((9.0, 10.0, 11.0, 12.0), (2, 2)));

    --  declare
    --      --ReLU object
    --    F : aliased Mlengine.Operators.ReLU_T := (Activated => R_Forward_Activated);
    --    B : aliased Mlengine.Operators.ReLU_T := (Activated => R_Backward_Activated);

    --    --expected answer
    --    Answer : ST_CPU.CPU_Tensor := ST.CPU.To_Tensor((1.0, 0.0, 4.0, 0.0), (2,2));
    --    --result
    --    ForwardResult : ST_CPU.CPU_Tensor := F.Forward(R_Test_Input);
    --    BackwardResult :  ST_CPU.CPU_Tensor := B.Backward(R_dY);
    --  begin
    --      Put_Line("ReLU Forward Result:");
    --      Put_Line(ForwardResult.Image);
    --      Put_Line("ReLU Backward Result:");
    --      Put_Line(BackwardResult.Image);

    --  end;
  ----------------------------------------------------------------------------------
  ------------------------------------SoftMaxLoss-----------------------------------

    --  X.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((2.71177099, 3.11687473, -5.89971407, -0.87466922, -3.9512139, 4.77711541, -3.5347833, 0.16200897, 3.31276371, -7.64252927, 5.56109235, 1.98503507, 3.65512365, 1.10249348, -4.79523851, -6.13127804, 4.47953644, 1.57189616, -0.76463076, -4.18947765, 4.90467281, 1.74722258, -5.82359028, 4.02702799, -6.11230341, 4.8847165, 1.14003711, -7.59722608, 4.83939614, 2.63926706, 1.91036662, -5.67953439, 3.71832932, -0.30490472, 1.94281725, -1.67547115, -1.05855491, -0.42666605, 1.44974343, 4.55495162, 2.10680767, -6.70982412, -1.14406615, 0.15799687, 0.94951404, 1.12446581, -6.26501505, 5.0978815, -3.66827415, 3.34621609, 0.25903371, -3.27215393, -0.1624845, 3.37794116, 2.44174734, -1.15686176, -1.3226696, -8.16869057, 6.32266961, 1.73834261


    --                                                                 ), (20,3)));
    --  E.Target := X_Target;
    --  E.Proba.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor (      (0.666907621, 1.0, 0.000121379471, 0.00351124488, 0.00016193277, 1.0, 0.00106205772, 0.0428197968, 1.0, 1.84391115e-06, 1.0, 0.0279858213, 1.0, 0.0778765676, 0.000213822963, 2.46480077e-05, 1.0, 0.0546044292, 0.0034502673, 0.000112320916, 1.0, 0.102304111, 5.27145906e-05, 1.0, 1.67515476e-05, 1.0, 0.0236432082, 3.97048535e-06, 1.0, 0.110788857, 0.163987889, 8.29009776e-05, 1.0, 0.105639601, 1.0, 0.0268285568, 0.0814066475, 0.153138968, 1.0, 1.0, 0.0864539, 1.28165182e-05, 0.123245103, 0.453156755, 1.0, 0.0188090774, 1.16186784e-05, 1.0, 0.000898763847, 1.0, 0.0456303424, 0.00129389906, 0.02900098, 1.0, 1.0, 0.0273617536, 0.0231811242, 5.08724014e-07, 1.0, 0.0102106192
    --                                                                 ), (20,3)));
    --  Proba.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((0.0, 0.0), (1,2)));
    
    --  declare
    --  Fwd : Orka.Float_32;
    --  Bck : Tensor;
    --  begin
    --      Put_Line("SoftMaxLoss Forward Result:");
    --      Fwd := Forward(E, X.Data.All, X_Target);
    --      Put_Line("SoftMaxLoss Backward Result:");
    --      Bck.Data := new ST_CPU.CPU_Tensor'(Backward(E));
    --  end;
  ----------------------------------------------------------------------------------
  ------------------------------------SGD Optimizer---------------------------------
    Add(M, Layer1);

    Optim.lr := 0.1;
    Optim.weight_decay := 0.0001;
    Optim.momentum := 0.9;
    Optim.parameters := M.Parameters;

    InitializeSGD(Optim);
    Optim.step;

      Put_Line("SGD Optimizer Result:");
      for I in Optim.velocities.First_Index .. Optim.velocities.Last_Index loop
          Put_Line(Optim.velocities (I).Data.all.Image);
      end loop;
  ----------------------------------------------------------------------------------
end Main;
