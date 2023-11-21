with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with Orka; --for Float32 type
use Orka; --for operator
with Orka.Numerics.Singles.Tensors.CPU;
use Orka.Numerics.Singles.Tensors.CPU;
with Orka.Numerics.Singles.Tensors.CPU;
use Orka.Numerics.Singles.Tensors.CPU;
with Orka;
use Orka;

package body Mlengine.Operators is
   
   function SumOverX(T : ST_CPU.CPU_Tensor) return ST_CPU.CPU_Tensor is 
      Result : ST_CPU.CPU_Tensor := ST_CPU.Empty((1,1));
      Counter : Orka.Float_32;
   begin
      for I in 1 .. (T.Shape(1)) loop
         Counter := 0.0;
         for J in 1 .. (T.Shape(2)) loop
            Counter := Counter + ST_CPU.Get(T, (I, J));
         end loop;   
         declare 
            Single : ST_CPU.CPU_Tensor := ST_CPU.Zeros((1,1));
         begin 
            Single.Set (((1,1)), Counter);
            if I = 1 then
               ST_CPU.Set(Result, (1,1), Counter);
            else
               Result := Result & Single;
            end if; 
            
         end;
         
      end loop;
      return Result; 
   end;

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
      E.Bias.Grad := new ST_CPU.CPU_Tensor'(SumOverX(dY.Data.all));
      return GradInput;
   end;

   overriding function Get_Params (E : Linear_T) return ParamsArray is
      Parameters : ParamsArray; 
   begin
      Parameters(1) := E.Weights;
      Parameters(2) := E.Bias;
      return Parameters;
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


      overriding function Backward (E : in out ReLU_T; dY : in Tensor) return ST_CPU.CPU_Tensor is
      --current var
      cur : Orka.Float_32;
      begin
      --for i in tensors rows
         for I in 1..(E.Activated.Data.Shape(1)) loop
            --for j in tensors columns
            for J in 1..(E.Activated.Data.Shape(2)) loop
               Put_Line("ran");
               --set cur to dY[i,j]
               cur := (E.Activated.Data((I,J)));
               --return dY * 1.0 or 0.0
               --these are True and False values of if activated is greater than 0
               if cur < 0.0 then
                  dY.Grad.Set (((I,J)), 0.0);
                  Put_Line("ranny");
               end if;

            end loop;
            
         end loop;


         --return modified dy gradient tensor
         return dY.Grad.All;
   end;

end Mlengine.Operators;
