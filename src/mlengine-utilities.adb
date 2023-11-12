with Ada.Text_IO; use Ada.Text_IO;

package body Mlengine.Utilities is
    procedure Test is
        MLTensor : Grad_Tensor;
        Tensor : ST_CPU.CPU_Tensor := ST_CPU.Zeros((4,8));
    begin
        MLTensor.Data := new ST_CPU.CPU_Tensor'(ST_CPU.Zeros((4,8)));
        MLTensor.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.Ones((4,8)));

        Put_Line(MLTensor.Data.Image);
        Put_Line(MLTensor.Grad.Image);
    end;
end Mlengine.Utilities;
