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
      Maximums : Float_Array := (others => 0.0);
      Losses   : Float_Array := (others => 0.0);
      UP_Sums  : Float_Array := (others => 0.0);
      Unnormalized_Proba : ST_CPU.CPU_Tensor := ST.CPU.To_Tensor((0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0), 
                                                                  (20,3));
      
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
              Sums (I) := (Sums (I) + Un_Prob.Get ((I, J)));
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
         for I in 1 .. 20 loop
            declare
            J : Standard.Integer := Target(I);
            Element : Orka.Float_32 := Data.Get ((I, J));
            Log_Of : Orka.Float_32 := Real_Functions.Log (Element, 10.0);
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
      Negative_Log (Target, X);

      --return
      for I in 1 .. 20 loop
            Losses_Sum := Losses(I) + Losses_Sum;
      end loop;

      declare
         Average_Losses : Orka.Float_32 := 0.0;
         begin
            Average_Losses := Losses_Sum / 20.0;
         
      
         return Average_Losses;

         end;

   end Forward;

   function Backward (SLM : in out SoftLossMax_T) return ST_CPU.CPU_Tensor is 
      -- Gradient : ST_CPU.CPU_Tensor := SLM.Proba; 
      Gradient : Tensor := SLM.Proba;
      Target : Integer;
   begin

      --  for I in E.Target'Range loop
      --     Target := Integer (E.Target (I));
      --     Gradient (I)(Target) := Gradient (I)(Target) - 1;

      --     for J in Gradient.Shape(1) loop
      --        for K in Gradient.Shape(2) loop
      --           Gradient (J)(K) := Gradient (J)(K) / 2;
      --        end loop;
      --     end loop;
      --  end loop; 

      return Gradient.Data.all;
   end;
end Mlengine.LossFunctions;