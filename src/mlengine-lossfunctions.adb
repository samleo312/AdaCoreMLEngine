with Ada.Numerics;  
--with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Orka; use Orka; 
with Orka.Numerics.Singles.Tensors; use Orka.Numerics.Singles.Tensors;
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;

with Ada.Numerics.Generic_Elementary_Functions;

package body Mlengine.LossFunctions is

   function Forward (SLM    : in out SoftLossMax_T; 
                     X      : in out ST_CPU.CPU_Tensor; 
                     Target : in out Target_Array) return Orka.Float_32 is

      Losses_Sum : Orka.Float_32 := 0.0;
      Maximums : Float_Array(1 .. SLM.Size) := (others => 0.0);
      Losses   : Float_Array(1 .. SLM.Size) := (others => 0.0);
      UP_Sums  : Float_Array(1 .. SLM.Size) := (others => 0.0);
      Unnormalized_Proba : ST_CPU.CPU_Tensor := Zeros((SLM.Size,3));
      
      procedure Find_Rows_Max (Data : in ST_CPU.CPU_Tensor; 
                               Maxs : in out Float_Array) is
         Max         : Orka.Float_32 := 0.0;
         Element     : Orka.Float_32 := 0.0;
      begin
         for I in 1 .. (Data.Shape (1)) loop
            for J in 1 .. (Data.Shape (2)) loop
               Element := Data.Get ((I, J));
               Max := (if Element > Max then Element else Max);
            end loop;
            Maxs (I) := Max;
            Max := 0.0;
         end loop;
      end;

      procedure Compute_Rowwise_Exponentials (Data    : in ST_CPU.CPU_Tensor; 
                                              Maxs    : in Float_Array; 
                                              Un_Prob : in out ST_CPU.CPU_Tensor) is
         package Real_Functions is new Ada.Numerics.Generic_Elementary_Functions (Orka.Float_32);
      begin
         for I in 1 .. (Data.Shape (1)) loop
            for J in 1 .. (Data.Shape (2)) loop
               declare
                  Element : Orka.Float_32 := Data.Get ((I, J));
                  Row_Max : Orka.Float_32 := Maxs (I);
                  Diff    : Orka.Float_32 := Element - Row_Max;
                  Euler   : Orka.Float_32 := Real_Functions."**" (Ada.Numerics.e, Diff);
               begin
                  Unnormalized_Proba.Set((I, J), Euler);
               end;                                                                                  
            end loop;
         end loop;
      end;

      procedure Sum_Unnormalized_Probabilities (Un_Prob : in ST_CPU.CPU_Tensor; 
                                                Sums    : in out Float_Array) is
      begin
         for I in 1 .. Un_Prob.Shape (1) loop
            for J in 1 .. Un_Prob.Shape (2) loop
              declare
               E : Orka.Float_32 := Un_Prob.Get ((I, J));
              begin
                  Sums (I) := (Sums (I) + E);
              end;
            
            end loop;
         end loop;
      end;

      procedure Normalize_Probabilities (Un_Prob : in ST_CPU.CPU_Tensor; 
                                         Sums    : in Float_Array; 
                                         Data    : in out ST_CPU.CPU_Tensor) is
      begin
         for I in 1 .. Un_Prob.Shape (1) loop
            for J in 1 .. Un_Prob.Shape (2) loop
               declare
                  T_Idx : ST.Tensor_Index := (I, J);
                  Normalization : Orka.Float_32 := Un_Prob.Get (T_Idx) / Sums(I);
               begin
                  Data.Set (T_Idx, Normalization);
               end;
            end loop;
         end loop;
         
      end;

      procedure Negative_Log  (Target: in Target_Array;
                               Data : in out ST_CPU.CPU_Tensor) is
      package Real_Functions is new Ada.Numerics.Generic_Elementary_Functions (Orka.Float_32);
      begin
         for I in 1 .. SLM.Size loop
            declare
            J : Standard.Integer := Target(I);
            Element : Orka.Float_32 := Data.Get ((I, J));
            Log_Of : Orka.Float_32 := Real_Functions.Log (Element, Ada.Numerics.e);
            Negative_Log_Of : Orka.Float_32 := -(Log_Of);
            begin
               Losses(I) := Negative_Log_Of;
            end;
         end loop;
      end;

      

   begin
      Find_Rows_Max (X, Maximums);
      Compute_Rowwise_Exponentials (X, Maximums, Unnormalized_Proba);
      Sum_Unnormalized_Probabilities (Unnormalized_Proba, UP_Sums);

      Normalize_Probabilities (Unnormalized_Proba, UP_Sums, SLM.Proba.Data.all);
      --Put_Line(SLM.Proba.Data.all.Image);
      Negative_Log (Target, SLM.Proba.Data.all);
      

      --return
      for I in 1 .. SLM.Size loop
            Losses_Sum := Losses(I) + Losses_Sum;
      end loop;

      declare
         Average_Losses : Orka.Float_32 := 0.0;
         begin
            Average_Losses := Losses_Sum / 20.0;
         Put_Line("Loss mean");
         Put_Line(Average_Losses'Image);
         return Average_Losses;

         end;

   end Forward;

   function Backward (SLM : in out SoftLossMax_T) return ST_CPU.CPU_Tensor is 
      Gradient : Tensor := SLM.Proba;
      Target : Integer;
   begin

      for I in 1 .. SLM.Target'Length loop
         Target := SLM.Target (I);
         declare
            Idx : ST.Tensor_Index := (I, Target);
            Grad_Minus_1 : Orka.Float_32 := Gradient.Data.all.Get(Idx) - 1.0;
         begin
            Gradient.Data.Set (Idx, Grad_Minus_1);
         end;

         
      end loop; 

      for J in 1 .. Gradient.Data.all.Shape(1) loop
         for K in 1 .. Gradient.Data.all.Shape(2) loop
            declare
               T_Idx : ST.Tensor_Index := (J, K);
               Size_Of_Target : Orka.Float_32 := Orka.Float_32(SLM.Target'Last);
               Grad_Div_Length : Orka.Float_32 :=  Gradient.Data.all.Get(T_Idx) / Size_Of_Target;
            begin
               Gradient.Data.Set (T_Idx, Grad_Div_Length);
            end;
            
         end loop;
      end loop;
      return Gradient.Data.all;
   end;
end Mlengine.LossFunctions;