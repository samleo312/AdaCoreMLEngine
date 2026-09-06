with Ada.Text_IO; use Ada.Text_IO;
with Orka; use Orka; 
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Ada.Numerics.Elementary_Functions;


package body Mlengine.Operators is
   Initialization_Generator : Generator;
   
      function SumOverX(T : ST_CPU.CPU_Tensor) return ST_CPU.CPU_Tensor is
         Result : ST_CPU.CPU_Tensor := ST_CPU.Zeros((1, T.Shape(2)));
      begin
         if T.Shape(1) > 1 then

            for J in 1 .. T.Shape(2) loop
               declare
                  Column_Sum : Float_32 := 0.0;
               begin

                  for I in 1 .. T.Shape(1) loop
                     Column_Sum := Column_Sum + ST_CPU.Get(T, (I, J));
                  end loop;

                  ST_CPU.Set(Result, (1, J), Column_Sum);
               end;
            end loop;

            return Result;
         else
            return T;
         end if;
      end SumOverX;


   procedure InitializeLayer(E : in out Linear_T) is
      use Ada.Numerics.Elementary_Functions;
   begin

      for J in 1..(E.Weights.Data.Shape(1)) loop
         for K in 1..(E.Weights.Data.Shape(2)) loop

            declare
               U : constant Float := Float'Max
                 (Random (Initialization_Generator), Float'Model_Small);
               V : constant Float := Random (Initialization_Generator);
               W : constant Orka.Float_32 := Orka.Float_32
                 (0.01 * Sqrt (-2.0 * Log (U)) * Cos (2.0 * Ada.Numerics.Pi * V));
            begin
               E.Weights.Data.Set (ST.Tensor_Index'(J, K), W);
            end;

         end loop;
      end loop;
      E.Bias.Data.all := Zeros (E.Bias.Data.Shape);
   end;


   -- Change to CPU_Tensor input
   overriding function Forward (E : in out Linear_T; X : in out Tensor) return ST_CPU.CPU_Tensor is

   begin

      if X.Data.Shape'Length /= 2 or else E.Weights.Data.Shape'Length /= 2
        or else X.Data.Shape (2) /= E.Weights.Data.Shape (1)
        or else E.Bias.Data.Shape (1) /= 1
        or else E.Bias.Data.Shape (2) /= E.Weights.Data.Shape (2)
      then
         raise Constraint_Error with "Linear forward: incompatible input, weights or bias";
      end if;

      declare
         Multi : ST_CPU.CPU_Tensor :=
           ST_CPU."*" (X.Data.all, E.Weights.Data.all);
         --Multi : ST_CPU.CPU_Tensor := E.Weights.Data.all * X.Data.all;
         --Output : ST_CPU.CPU_Tensor := Add(Multi, E.Bias.Data.all);
      begin

         -- CPU_Tensor.Add does not broadcast a 1 x N bias across rows, so
         -- perform the broadcast explicitly.
         for I in 1 .. Multi.Shape (1) loop
            for J in 1 .. Multi.Shape (2) loop
               ST_CPU.Set
                 (Multi, ST.Tensor_Index'(I, J),
                  Orka.Float_32
                    (ST_CPU.Get (Multi, ST.Tensor_Index'(I, J)) +
                     ST_CPU.Get (E.Bias.Data.all, ST.Tensor_Index'(1, J))));
            end loop;
         end loop;

         --Put_Line("-----BIAS----");
         --Put_Line(E.Bias.Data.all.Image);

          -- Own a snapshot for backward, independent of activation buffers.
          if E.Input.Data /= null then
             Mlengine.Free_CPU_Tensor (E.Input.Data);
          end if;
          E.Input.Data := new ST_CPU.CPU_Tensor'(X.Data.all);
          E.Input.Grad := null;
          return Multi;
      end;

   end;

   -- Change to CPU_Tensor Input
   overriding function Backward (E : in out Linear_T; dY : in out Tensor) return ST_CPU.CPU_Tensor is
      use type ST.Tensor_Shape;
   begin
      if E.Input.Data = null or else dY.Data.Shape'Length /= 2
        or else dY.Data.Shape (1) /= E.Input.Data.Shape (1)
        or else dY.Data.Shape (2) /= E.Weights.Data.Shape (2)
        or else E.Weights.Grad.Shape /= E.Weights.Data.Shape
        or else E.Bias.Grad.Shape /= E.Bias.Data.Shape
      then
         raise Constraint_Error with "Linear backward: incompatible gradient or missing forward";
      end if;
      E.Weights.Grad.all := ST_CPU.Add (E.Weights.Grad.all,
        ST_CPU."*" (Transpose (E.Input.Data.all), dY.Data.all));

      E.Bias.Grad.all := ST_CPU.Add (E.Bias.Grad.all, SumOverX (dY.Data.all));
      return ST_CPU."*" (dY.Data.all, Transpose (E.Weights.Data.all));
   end;

   overriding function Get_Params (E : in out Linear_T) return ParamsArray is
      Parameters : ParamsArray; 
   begin
      -- The layer objects are caller-owned and remain alive for the model's
      -- lifetime; Unchecked_Access expresses that borrowed lifetime here.
      Parameters(1) := E.Weights'Unchecked_Access;
      Parameters(2) := E.Bias'Unchecked_Access;
      return Parameters;
   end;
   

   overriding function Forward (E : in out ReLU_T; X : in out Tensor) return ST_CPU.CPU_Tensor is
      Activated : ST_CPU.CPU_Tensor := X.Data.all;
   begin
      for I in 1 .. Activated.Shape (1) loop
         for J in 1 .. Activated.Shape (2) loop

            declare
               Value : constant Float_32 := Activated.Get (ST.Tensor_Index'(I, J));
            begin
               Activated.Set (ST.Tensor_Index'(I, J), Float_32'Max (0.0, Value));
            end;

         end loop;
      end loop;

      declare
         Saved : constant CPU_Tensor_Access := new ST_CPU.CPU_Tensor'(Activated);
      begin
         Free_CPU_Tensor (E.Activated.Data);
         E.Activated.Data := Saved;
      end;
      return Activated;

   end Forward;

   overriding function Backward (E : in out ReLU_T; dY : in out Tensor) return ST_CPU.CPU_Tensor is
      Gradient : ST_CPU.CPU_Tensor := dY.Data.all;
      use type ST.Tensor_Shape;
   begin

      if E.Activated.Data = null or else E.Activated.Data.Shape /= Gradient.Shape then
         raise Constraint_Error with "ReLU backward: incompatible gradient or missing forward";
      end if;
      
      for I in 1 .. Gradient.Shape (1) loop
         for J in 1 .. Gradient.Shape (2) loop
            if Float_32'(E.Activated.Data.all.Get (ST.Tensor_Index'(I, J))) <= 0.0 then
               Gradient.Set (ST.Tensor_Index'(I, J), Float_32'(0.0));
            end if;
         end loop;
      end loop;
      return Gradient;

   end Backward;

      overriding function Get_Params (E : in out ReLU_T) return ParamsArray is
         BlankArray : ParamsArray;
      begin
         BlankArray := (others => null);
         return BlankArray;
      end; 

      procedure InitializeLayer(E : in out ReLU_T) is
      begin
         null;
      end;


begin
   Reset (Initialization_Generator, 2026);
end Mlengine.Operators;
