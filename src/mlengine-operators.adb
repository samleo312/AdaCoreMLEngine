with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with Orka; --for Float32 type
use Orka; --for operator
with Orka.Numerics.Singles.Tensors.CPU;
use Orka.Numerics.Singles.Tensors.CPU;
with Orka.Numerics.Singles.Tensors.CPU;
use Orka.Numerics.Singles.Tensors.CPU;

package body Mlengine.Operators is

   overriding function Forward (E : in out Linear_T; X : in Tensor) return ST_CPU.CPU_Tensor is
      Output : ST_CPU.CPU_Tensor := Add((E.Weights.Data.all * X.Data.all), E.Bias.Data.all);
      --Output : ST_CPU.CPU_Tensor := Add((E.Weights.Data.all * X.Data.all), E.Bias.Data.all);
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

   --overriding function Get_Params (E : Linear_T) return ST_CPU.CPU_Tensor is
   --   Tensor : ST_CPU.CPU_Tensor := ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0, 5.0, 6.0), Shape => (3, 2));
   --begin
   --   Put_Line (E'Image);
   --   return Tensor;
   --end;

   overriding function Forward (E : in out ReLU_T; X : in Tensor) return ST_CPU.CPU_Tensor is
      --current var
      cur : Orka.Float_32;
      begin
         --for i in tensors rows
         for I in 1..(X.Data.Shape(1)) loop
            --for j in tensors columns
            for J in 1..(X.Data.Shape(2)) loop
               --set cur to input[i,j]
               cur := (X.Data((I,J)));
               --check if negative, if so set to 0.0
               if cur < 0.0 then
                  X.Data.Set (((I,J)), 0.0);
               end if;

            end loop;
            
         end loop;

         --set ReLU activated in place to modified x
         E.Activated := X;

         --return something even tho we do inplace
         return E.activated.data.all;

      end;

      --place holder still needs implemented
      overriding function Backward (E : in out ReLU_T; dY : in Tensor) return ST_CPU.CPU_Tensor is
      todo : Tensor;
   begin
      todo.data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
      return todo.data.all;
   end;

end Mlengine.Operators;
