with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;
with Mlengine.Optimizers;
with SGD_Tests; use SGD_Tests;
with Orka;
use Orka;

package body Mlengine.Utilities is
    procedure Test is
        --SGD variables
        Slr : float;
        Sweight_decay : float;
        Smomentum : float;

        Sten : Tensor;
        Svelocities : aliased ST.Element_Array := (1.0, 2.0, 3.0, 4.0);


    begin  
        --SGD's base parameters
        Slr := 0.001;
        Sweight_decay := 0.01;
        Smomentum := 0.9;

        --SGD's tensor
        Sten.data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor((0.0, 1.0, 2.0, 3.0), (4,1)));
        Sten.grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor((0.0, 1.5, 2.5, 3.5), (4,1)));

        declare
            --S: SGD instance
            S : aliased Mlengine.Optimizers.SGD := (lr           => Slr, 
                                                    weight_decay => Sweight_decay, 
                                                    momentum     => Smomentum, 
                                                    velocities   => Svelocities'Unchecked_Access, 
                                                    t            => Sten);
            
            Test_1 : SGD_Test;
        
        begin
            SGD_Test.Register_Tests(Test_Zero_Grad);
            --  Put_Line("Running Tests");
            --  Test_Step(Test_1);
            --  Test_Zero_Grad(Test_1);
            --  Put_Line("Tests Complete");
        
            --  --print contents of SGD
            --  Put_Line("Data before step: ");
            --  Put_Line(S.t.Data.Image);
            --  Put_Line("Initial Gradient: ");
            --  Put_Line(S.t.Grad.Image);
            --  Put_Line("Velocities before step: ");
            --  for I in S.velocities'Range loop
            --      Put_Line(Float'Image(Float(S.velocities(I))));
            --  end loop;
            --  Put_Line("Data after Step called: ");
            --  S.step;
            --  Put_Line("OFFICIAL: ");
            --  Put_Line(S.t.Data.Image);
            --  S.zero_grad;
            --  Put_Line("Gradients after zero_grad called: ");
            --  Put_Line(S.t.Grad.Image);

            --  Put_Line("Velocities after Step called: ");
            --  for I in S.velocities'Range loop
            --      Put_Line(Float'Image(Float(S.velocities(I))));
            --  end loop;
        


        end;
    end;
end Mlengine.Utilities;
