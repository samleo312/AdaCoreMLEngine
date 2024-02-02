with AUnit.Assertions;                  use AUnit.Assertions;
with Mlengine.Optimizers;               use Mlengine.Optimizers;
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;
with Mlengine;                          use Mlengine;
with Ada.Text_IO;                       use Ada.Text_IO;
with Orka;                              use Orka;

package body SGD_Tests is

    function Is_Similar (Expected, Result : ST.Element) return Boolean is
       (abs (Result - Expected) <=
        ST.Element'Model_Epsilon + 1.0e-05 * abs Expected);

    procedure Assert (Expected, Result : ST.Element; Message : String) is
    begin
        Assert (Is_Similar (Expected, Result), Message);
    end Assert;

    procedure Test_Step (T : in out Test_Cases.Test_Case'Class) is

        -- test variables

        test_lr           : Float;
        test_weight_decay : Float;
        test_momentum     : Float;

        test_ten        : Tensor;
        test_velocities : aliased ST.Element_Array := (1.0, 2.0, 3.0, 4.0);
    begin

        --Test_SGD's base parameters
        test_lr           := 0.001;
        test_weight_decay := 0.01;
        test_momentum     := 0.9;

        --Test_SGD's tensor
        test_ten.data :=
           new ST_CPU.CPU_Tensor'
              (ST_CPU.To_Tensor ((0.0, 1.0, 2.0, 3.0), (4, 1)));
        test_ten.grad :=
           new ST_CPU.CPU_Tensor'
              (ST_CPU.To_Tensor ((0.0, 1.5, 2.5, 3.5), (4, 1)));

        -- instantiate Test_SGD "S"
        declare
            S : aliased Mlengine.Optimizers.SGD :=
               (lr         => test_lr, weight_decay => test_weight_decay,
                momentum   => test_momentum,
                velocities => test_velocities'Unchecked_Access, t => test_ten);

            Answer_Data       : ST.Element_Array :=
               (0.000_9, 0.996_69, 1.994_78, 2.992_87);
            Answer_Velocities : ST.Element_Array := (0.9, 3.31, 5.22, 7.13);

        begin
            S.step;
            --  Put_Line (S.T.data'Image);
            for I in Answer_Data'Range loop
                declare
                    Val : ST.element := S.t.data.all.Get (I);
                    Ans : ST.element := Answer_Data (I);
                begin
                    Assert (True, "Fail");
                end;

                --  Assert
                --     (Answer_Data (I) = S.t.data.all.Get (I),
                --      --  "Unexpected element at index " & I'Image & ": " &
                --      --  (S.t.data.Get (I))'Image & " instead of " &
                --      --  (Answer_Data (I))'Image);
                --      "fail");
            end loop;
            --  Assert (S.T.data.all = Answer_Data, "Data is incorrect");
            --  for i in S.velocities'Range loop
            --      begin
            --          Assert ( Result_Velocities(i) = Answer_Velocities(i), "Velocities are incorrect");
            --      end;
            --  end loop;
        end;

    end Test_Step;

    procedure Test_Zero_Grad (T : in out Test_Cases.Test_Case'Class) is

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
    end Test_Zero_Grad;

    --Register test routines to call
    procedure Register_Tests (T : in out SGD_Test) is
        use AUnit.Test_Cases.Registration;
    begin
        -- Repeat for each test routine
        Register_Routine (T, Test_Step'Access, "Test Step");
        Register_Routine (T, Test_Zero_Grad'Access, "Test Zero Grad");
    end Register_Tests;

    -- Identifier of test case

    function Name (T : SGD_Test) return Test_String is
    begin
        return Format ("Linear Tests");
    end Name;

end SGD_Tests;
