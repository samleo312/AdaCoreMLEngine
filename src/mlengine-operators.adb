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
         if T.Shape'Length > 1 then
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
         end if;
         
      end loop;
      return Result; 
   end;

   overriding function Forward (E : in out Linear_T; X : in Tensor) return ST_CPU.CPU_Tensor is
      Output : ST_CPU.CPU_Tensor := Add((X.Data.all * E.Weights.Data.all), E.Bias.Data.all);
   begin
      E.Input := X; 
      return Output;
   end;

   overriding function Backward (E : in out Linear_T; dY : in Tensor) return ST_CPU.CPU_Tensor is
      GradInput : ST_CPU.CPU_Tensor := (dY.Data.all * Transpose(E.Weights.Data.all));
   begin
      E.Weights.Grad := new ST_CPU.CPU_Tensor'(Add(E.Weights.Grad.all, (dY.Data.all * Transpose(E.Input.Data.all))));
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
   

end Mlengine.Operators;
