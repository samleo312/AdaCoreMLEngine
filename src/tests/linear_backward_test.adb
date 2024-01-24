with AUnit.Assertions; use AUnit.Assertions;
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;
with Mlengine; use Mlengine;
with Mlengine.Operators;

package body Linear_Backward_Test is

    function Name (T : Linear_Backward_Test) return AUnit.Message_String is
        pragma Unreferenced (T);
    begin
        return AUnit.Format ("Test Linear Backward Function");
    end Name;

    procedure Run_Test (T : in out Linear_Backward_Test) is
        pragma Unreferenced (T);
        TestWeights : Tensor;
        TestBias : Tensor;
        TestInput : Tensor;
        InputTensor : Tensor;
    begin
        TestWeights.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
        TestWeights.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

        TestBias.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
        TestBias.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

        TestInput.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
        TestInput.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

        InputTensor.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
        InputTensor.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

        declare
            L : aliased Mlengine.Operators.Linear_T := (TestWeights, TestBias, TestInput, "linear");
            Answer : ST_CPU.CPU_Tensor := ST.CPU.To_Tensor((5.0, 11.0, 11.0, 25.0), (2,2));
            Result : ST_CPU.CPU_Tensor := L.Backward(InputTensor);
        begin
            Assert (Result = Answer, "Backward Function is incorrect");
        end;
        
    end Run_Test;

end Linear_Backward_Test;