with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;

package body Mlengine.Operators is

   overriding function Forward (E : in out Linear_T; X : in Tensor) return ST_CPU.CPU_Tensor is
      Output : ST_CPU.CPU_Tensor := (E.Weights.Data.all * X.Data.all) + E.Bias.Data.all;
   begin
      E.Input := X; 
      return Output;
   end;

   --overriding function Backward (E : Linear_T) return ST_CPU.CPU_Tensor is
   --   Tensor : ST_CPU.CPU_Tensor := ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0, 5.0, 6.0), Shape => (3, 2));
   --begin
   --   Put_Line (E'Image);
   --   return Tensor;
   --end;

   --overriding function Get_Params (E : Linear_T) return ST_CPU.CPU_Tensor is
   --   Tensor : ST_CPU.CPU_Tensor := ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0, 5.0, 6.0), Shape => (3, 2));
   --begin
   --   Put_Line (E'Image);
   --   return Tensor;
   --end;
end Mlengine.Operators;
