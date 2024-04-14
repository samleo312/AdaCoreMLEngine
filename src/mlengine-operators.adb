with Ada.Text_IO; use Ada.Text_IO;
with Orka; use Orka; 
with Orka.Numerics.Singles.Tensors.GPU; use Orka.Numerics.Singles.Tensors.GPU;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;


package body Mlengine.Operators is
   
      function SumOverX(T : ST_GPU.GPU_Tensor) return ST_GPU.GPU_Tensor is
         Result : ST_GPU.GPU_Tensor := ST_GPU.Zeros((1, T.Shape(1)));
      begin
         if T.Shape(1) > 1 then
            for I in 1 .. T.Shape(1) loop

               declare
                  Row_Sum : Float_32 := 0.0;
               begin
               
               for J in 1 .. T.Shape(2) loop
                  Row_Sum := Row_Sum + ST_GPU.Get(T, (I, J));
               end loop;
               ST_GPU.Set(Result, (1, I), Row_Sum);
               end;
            end loop;

            return Result;
         else
            return T;
         end if;
      end SumOverX;


   procedure InitializeLayer(E : in out Linear_T) is
      G : Generator; 
   begin

      for J in 1..(E.Weights.Data.Shape(1)) loop
         for K in 1..(E.Weights.Data.Shape(2)) loop
            E.Weights.Data.Set (((J,K)), Orka.Numerics.Singles.Tensors.Element(Random(G)));
         end loop;
      end loop;

   end;


   -- Change to GPU_Tensor input
   overriding function Forward (E : in out Linear_T; X : in Tensor) return ST_GPU.GPU_Tensor is

   begin

      declare
         Multi : ST_GPU.GPU_Tensor := X.Data.all * E.Weights.Data.all;
         --Multi : ST_GPU.GPU_Tensor := E.Weights.Data.all * X.Data.all;
         --Output : ST_GPU.GPU_Tensor := Add(Multi, E.Bias.Data.all);
      begin
         --Put_Line("-----BIAS----");
         --Put_Line(E.Bias.Data.all.Image);
         E.Input := X;
         return Multi;
      end;

   end;

   -- Change to GPU_Tensor Input
   overriding function Backward (E : in out Linear_T; dY : in Tensor) return ST_GPU.GPU_Tensor is
      GradInput : ST_GPU.GPU_Tensor := (dY.Data.all * Transpose(E.Weights.Data.all));
   begin
      E.Weights.Grad := new ST_GPU.GPU_Tensor'((Transpose(E.Input.Data.all)* dY.Data.all));
      --Add(E.Weights.Grad.all, ... ) ^

      E.Bias.Grad := new ST_GPU.GPU_Tensor'(SumOverX(dY.Data.all));
      return GradInput;
   end;

   overriding function Get_Params (E : Linear_T) return ParamsArray is
      Parameters : ParamsArray; 
   begin
      Parameters(1) := E.Weights;
      Parameters(2) := E.Bias;
      return Parameters;
   end;
   

   overriding function Forward (E : in out ReLU_T; X : in Tensor) return ST_GPU.GPU_Tensor is
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


      overriding function Backward (E : in out ReLU_T; dY : in Tensor) return ST_GPU.GPU_Tensor is
      --current var
      cur : Orka.Float_32;
      begin
      --for i in tensors rows
         for I in 1..(E.Activated.Data.Shape(1)) loop
            --for j in tensors columns
            for J in 1..(E.Activated.Data.Shape(2)) loop
               --set cur to dY[i,j]
               cur := (E.Activated.Data((I,J)));
               --return dY * 1.0 or 0.0
               --these are True and False values of if activated is greater than 0
               if cur <= 0.0 then
                  dY.Data.Set (((I,J)), 0.0);
               end if;

            end loop;
            
         end loop;

         --return modified dy gradient tensor
         return dY.Data.All;
      
      
      end;

      overriding function Get_Params (E : ReLU_T) return ParamsArray is
         BlankArray : ParamsArray;
      begin
         BlankArray (1) := Tensor'(Data => new GPU_Tensor'(ST_GPU.Zeros((2,2))), Grad => new GPU_Tensor'(ST_GPU.Zeros((2,2))));
         BlankArray (2) := Tensor'(Data => new GPU_Tensor'(ST_GPU.Zeros((2,2))), Grad => new GPU_Tensor'(ST_GPU.Zeros((2,2))));
         return BlankArray;
      end; 

      procedure InitializeLayer(E : in out ReLU_T) is
      begin
         null;
      end;


end Mlengine.Operators;
