with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with Orka.Numerics.Singles.Tensors.CPU;
use Orka.Numerics.Singles.Tensors.CPU;
with Orka.Numerics.Singles.Tensors.CPU;
use Orka.Numerics.Singles.Tensors.CPU;

package body Mlengine.Operators is

   overriding function Forward (E : in out Linear_T; X : in Tensor) return ST_CPU.CPU_Tensor is
      Output : ST_CPU.CPU_Tensor := Add((E.Weights.Data.all * X.Data.all), E.Bias.Data.all);
   begin
      E.Input := X; 
      return Output;
   end;

   overriding function Backward (E : in out Linear_T; dY : in Tensor) return ST_CPU.CPU_Tensor is
      GradInput : ST_CPU.CPU_Tensor := (dY.Data.all * Transpose(E.Weights.Data.all));
   begin
      E.Weights.Grad := new ST_CPU.CPU_Tensor'(Add(E.Weights.Grad.all, (Transpose(E.Input.Data.all) * dY.Data.all)));
      return GradInput;
   end;

   overriding function Get_Params (E : Linear_T) return ParamsArray is
      Parameters : ParamsArray; 
   begin
      Parameters(1) := E.Weights;
      Parameters(2) := E.Bias;
      return Parameters;
   end;
end Mlengine.Operators;
