with AUnit.Assertions;                  use AUnit.Assertions;
with Mlengine.Optimizers;               use Mlengine.Optimizers;
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;
with Mlengine;                          use Mlengine;
with Ada.Text_IO;                       use Ada.Text_IO;
with Orka;                              use Orka;

package body SGD_Zero_Grad_Test is

    function Name (T : SGD_Zero_Grad_Test) return AUnit.Message_String is
        pragma Unreferenced (T);
    begin
        return AUnit.Format ("Test SGD Zero Grad Function");
    end Name;

    procedure Run_Test (T : in out SGD_Zero_Grad_Test) is

        -- test variables

        test_lr           : Float;
        test_weight_decay : Float;
        test_momentum     : Float;

        test_ten        : Tensor;
        test_velocities : aliased ST.Element_Array := (1.0, 2.0, 3.0, 4.0);

    begin
        --Test_SGD's tensor
        test_ten.data :=
           new ST_CPU.CPU_Tensor'
              (ST_CPU.To_Tensor ((0.0, 1.0, 2.0, 3.0), (4, 1)));
        test_ten.grad :=
           new ST_CPU.CPU_Tensor'
              (ST_CPU.To_Tensor ((0.0, 1.5, 2.5, 3.5), (4, 1)));
        declare
            S      : aliased Mlengine.Optimizers.SGD :=
               (lr         => test_lr, weight_decay => test_weight_decay,
                momentum   => test_momentum,
                velocities => test_velocities'Unchecked_Access, t => test_ten);
            Answer : ST_CPU.CPU_Tensor               :=
               ST.CPU.To_Tensor ((0.0, 0.0, 0.0, 0.0), (4, 1));
        begin
            S.zero_grad;
            Assert (S.t.grad.all = Answer, "Zero Grad is incorrect");
        end;
    end Run_Test;

    
end SGD_Zero_Grad_Test;