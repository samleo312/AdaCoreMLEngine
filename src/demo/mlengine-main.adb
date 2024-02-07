with Ada.Text_IO; use Ada.Text_IO;
--with Mlengine.Operators;
--with Mlengine.Utilities; use Mlengine.Utilities;
with Mlengine.LossFunctions; use Mlengine.LossFunctions;
with AUnit.Reporter.Text;
with AUnit.Run;
with Linear_Suite;
with SGD_Suite;
with Orka; use Orka;

procedure Mlengine.Main is
--    M : Model;

--    use ST_CPU;
--    Base_Tensor : constant CPU_Tensor := To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2));

--    Weights_Data, Weights_Grad, Bias_Data, Bias_Grad, Input_Data, Input_Grad 
--        : constant Tensor_Access := new CPU_Tensor'(Base_Tensor);

--    Weights_Tensor : constant Tensor := (Weights_Data, Weights_Grad);
--    Bias_Tensor    : constant Tensor := (Bias_Data, Bias_Grad);
--    Input_Tensor   : constant Tensor := (Input_Data, Input_Grad);

--    Layer : aliased Linear_T := (Weights => Weights_Tensor, 
--                                 Bias    => Bias_Tensor, 
--                                 Input   => Input_Tensor);

    --Activation : aliased ReLU_T;
Proba : Tensor;
Target : Target_Array;
X: Tensor; --input
X_Target : Target_Array := (1,1,3,1,3,3,2,2,2,3,1,2,3,1,1,3,3,2,3,2);
E : aliased Mlengine.LossFunctions.SoftLossMax_T := (Proba, Target);
 
begin
    X.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor (          (2.71177099, 3.11687473, -5.89971407, -0.87466922, -3.9512139, 4.77711541, -3.5347833, 0.16200897, 3.31276371, -7.64252927, 5.56109235, 1.98503507, 3.65512365, 1.10249348, -4.79523851, -6.13127804, 4.47953644, 1.57189616, -0.76463076, -4.18947765, 4.90467281, 1.74722258, -5.82359028, 4.02702799, -6.11230341, 4.8847165, 1.14003711, -7.59722608, 4.83939614, 2.63926706, 1.91036662, -5.67953439, 3.71832932, -0.30490472, 1.94281725, -1.67547115, -1.05855491, -0.42666605, 1.44974343, 4.55495162, 2.10680767, -6.70982412, -1.14406615, 0.15799687, 0.94951404, 1.12446581, -6.26501505, 5.0978815, -3.66827415, 3.34621609, 0.25903371, -3.27215393, -0.1624845, 3.37794116, 2.44174734, -1.15686176, -1.3226696, -8.16869057, 6.32266961, 1.73834261


                                                                   ), (20,3)));
    E.Target := X_Target;
    E.Proba.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor (      (0.909008014,0.00851531049,0.0824766752,
0.902740177,0.097185781,7.40422121e-05,
0.0206512568,0.211544918,0.767803825,
0.949638878,0.0503255303,3.5591679e-05,
0.79280356,0.00015467397,0.207041766,
0.13614113,0.458941635,0.404917235,
8.40648511e-05,0.958926075,0.0409898603,
4.45417806e-05,0.865714536,0.134240922,
0.0440007426,0.936160141,0.019839116,
0.630273727,0.000179469083,0.369546804,
0.491830588,0.0371782189,0.470991193,
0.243013451,0.739924022,0.0170625265,
0.0922639209,3.11283751e-05,0.907704951,
0.804683267,0.0108225478,0.184494186,
0.758127029,0.00940912267,0.232463848,
0.0970982974,3.97196887e-05,0.902861983,
0.0178991547,0.320087738,0.662013108,
1.64660031e-05,0.957658695,0.0423248388,
0.0245114187,0.00590118254,0.969587399,
0.651577542,0.247758245,0.100664213
                                                                   ), (20,3)));
    Proba.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((0.0, 0.0), (1,2)));
    Put_Line ("Running Mlengine.Main");
    
    declare
    Fwd : Orka.Float_32;
    Bck : Tensor;
    begin
        --Fwd := Forward(E, X.Data.All, X_Target);
        Bck.Data := new ST_CPU.CPU_Tensor'(Backward(E));
    end;

    --M.Graph.Append(Layer'Unchecked_Access);
    --M.Graph.Append(Activation'Unchecked_Access);

    --InitializeNetwork(M);

    --Put_Line("Done");



    ------------------------ TESTS --------------------------
    --  declare
    --  procedure Runner is new AUnit.Run.Test_Runner (SGD_Suite.SGD_Suite);
    --      Reporter : AUnit.Reporter.Text.Text_Reporter;
    --  begin
    --      Runner (Reporter);
    --  end;
    
end Mlengine.Main;