with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;
with Mlengine.Optimizers;
with Orka;
use Orka;

package body Mlengine.Utilities is
    procedure Test is
        LWeights : Tensor;
        LBias : Tensor;
        LInput : Tensor;

        Tensor1 : Tensor;

        --ReLU vars
        R_Activated : Tensor;
        R_Test_Input : Tensor;
        R_dY : Tensor;

        --SGD variables
        Slr : float;
        Sweight_decay : float;
        Smomentum : float;

        Sten : Tensor;
        Svelocities : aliased ST.Element_Array := (1.0, 2.0, 3.0, 4.0);


    begin  
        LWeights.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
        LWeights.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

        LBias.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
        LBias.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

        LInput.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
        LInput.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

        Tensor1.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
        Tensor1.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

        --relu's activation tensor
        R_Activated.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((0.0, 0.0, 0.0, 0.0), (2, 2)));
        R_Activated.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((0.0, 0.0, 0.0, 0.0), (2, 2)));

        --relu test input data
        R_Test_Input.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, -2.0, 3.0, -4.0), (2, 2)));
        R_Test_Input.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, -2.0, 3.0, -4.0), (2, 2)));

        --relu's dY tensor
        R_dY.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((0.0, 0.0, 0.0, 0.0), (2, 2)));
        R_dY.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, -2.0, 3.0, -4.0), (2, 2)));
        
        --SGD's base parameters
        Slr := 0.001;
        Sweight_decay := 0.01;
        Smomentum := 0.9;

        --SGD's tensor
        Sten.data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor((0.0, 1.0, 2.0, 3.0), (4,1)));
        Sten.grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor((0.0, 1.5, 2.5, 3.5), (4,1)));

        declare
            --ReLU object
            R : aliased Mlengine.Operators.ReLU_T := (Activated => R_Activated);
            --relu tensor to print and show output
            R_Tensor : ST_CPU.CPU_Tensor := R.Forward(R_Test_Input);

            --relu tensor to print and show backward output
            R_Tensor_2 : ST_CPU.CPU_Tensor := R.Backward(R_dY);


            L : aliased Mlengine.Operators.Linear_T := (LWeights, LBias, LInput);
            Tensor : ST_CPU.CPU_Tensor := L.Backward(Tensor1);
            Params : Mlengine.Operators.ParamsArray := L.Get_Params; 

            S : aliased Mlengine.Optimizers.SGD := (lr           => Slr, 
                                                    weight_decay => Sweight_decay, 
                                                    momentum     => Smomentum, 
                                                    velocities   => Svelocities'Unchecked_Access, 
                                                    t            => Sten);
        
        begin
            --Put_Line(Params(1).Data.Image);
            --Put_Line(Tensor.Image);

            --print returned dY grad (works but at this pt ReLU already changed)
            --Put_Line(R_Tensor_2.Image);
            --done in place
            --Put_Line(R.Activated.Data.Image);
            
            --print contents of SGD
            Put_Line("SGD Optimizer:");
            Put_Line("Data before changes: ");
            Put_Line(S.t.Data.Image);
            Put_Line("Grad before changes: ");
            Put_Line(S.t.Grad.Image);
            Put_Line("Data after Step called: ");
            S.step;
            Put_Line("OFFICIAL: ");
            Put_Line(S.t.Data.Image);
            S.zero_grad;
            Put_Line("Gradients after zero_grad called: ");
            Put_Line(S.t.Grad.Image);

            Put_Line("Velocities (also after Step called): ");
            for I in S.velocities'Range loop
                Put_Line(Float'Image(Float(S.velocities(I))));
            end loop;


        end;
    end;
end Mlengine.Utilities;
