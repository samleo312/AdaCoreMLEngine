with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators; use Mlengine.Operators;
with Mlengine.Utilities; use Mlengine.Utilities;

procedure Mlengine.Main is
    M : Model;

    use ST_CPU;
    Base_Tensor : constant CPU_Tensor := To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2));

    Weights_Data, Weights_Grad, Bias_Data, Bias_Grad, Input_Data, Input_Grad 
        : constant Tensor_Access := new CPU_Tensor'(Base_Tensor);

    Weights_Tensor : constant Tensor := (Weights_Data, Weights_Grad);
    Bias_Tensor    : constant Tensor := (Bias_Data, Bias_Grad);
    Input_Tensor   : constant Tensor := (Input_Data, Input_Grad);

    Layer : aliased Linear_T := (Weights => Weights_Tensor, 
                                 Bias    => Bias_Tensor, 
                                 Input   => Input_Tensor);

    Activation : aliased ReLU_T;
begin
    Put_Line ("Running Mlengine.Main");

    M.Graph.Append(Layer'Unchecked_Access);
    M.Graph.Append(Activation'Unchecked_Access);

    InitializeNetwork(M);

    Put_Line("Done");



    ------------------------ TESTS --------------------------
    --declare
    --procedure Runner is new AUnit.Run.Test_Runner (Linear_Suite.Linear_Suite);
    --    Reporter : AUnit.Reporter.Text.Text_Reporter;
    --begin
    --    Runner (Reporter);
    --end;
    
end Mlengine.Main;