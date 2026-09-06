with Ada.Numerics.Generic_Elementary_Functions;
with Orka; use Orka;
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;

package body Mlengine.LossFunctions is
   package Math is new Ada.Numerics.Generic_Elementary_Functions (Float_32);

   function Forward (SLM : in out SoftLossMax_T;
                     X : in out ST_CPU.CPU_Tensor;
                     Target : in out Target_Array) return Float_32 is
      Probabilities : CPU_Tensor := Zeros (X.Shape);
      Loss : Float_32 := 0.0;
   begin

      if X.Shape (1) /= Target'Length or Target'Length /= SLM.Size then
         raise Constraint_Error with "Loss batch size does not match targets";
      end if;

      SLM.Target := Target;
      for I in 1 .. SLM.Size loop
         declare
            Maximum : Float_32 := X.Get (ST.Tensor_Index'(I, 1));
            Total : Float_32 := 0.0;
            Label : constant Integer := SLM.Target (I);
         begin

            if Label not in 1 .. X.Shape (2) then
               raise Constraint_Error with "Class label outside logits";
            end if;

            for J in 2 .. X.Shape (2) loop
               Maximum := Float_32'Max (Maximum, X.Get (ST.Tensor_Index'(I, J)));
            end loop;

            for J in 1 .. X.Shape (2) loop
               declare
                  P : constant Float_32 :=
                    Math.Exp (X.Get (ST.Tensor_Index'(I, J)) - Maximum);
               begin
                  Probabilities.Set (ST.Tensor_Index'(I, J), P);
                  Total := Total + P;
               end;
            end loop;

            -- Log-sum-exp remains finite even when the target probability
            -- underflows; a zero probability must never contribute zero loss.
            Loss := Loss + Math.Log (Total) +
              (Maximum - X.Get (ST.Tensor_Index'(I, Label)));
            for J in 1 .. X.Shape (2) loop
               declare
                  P : constant Float_32 :=
                    Probabilities.Get (ST.Tensor_Index'(I, J)) / Total;
               begin
                  Probabilities.Set (ST.Tensor_Index'(I, J), P);
               end;
            end loop;

         end;

      end loop;

      declare
         Saved : constant CPU_Tensor_Access := new CPU_Tensor'(Probabilities);
      begin
         Free_CPU_Tensor (SLM.Proba.Data);
         SLM.Proba.Data := Saved;
      end;

      return Loss / Float_32 (SLM.Size);
   end Forward;

   function Backward (SLM : in out SoftLossMax_T) return CPU_Tensor is
      Gradient : CPU_Tensor := SLM.Proba.Data.all;
   begin

      for I in 1 .. SLM.Size loop
         for J in 1 .. Gradient.Shape (2) loop
            declare
               G : constant Float_32 :=
                 (Gradient.Get (ST.Tensor_Index'(I, J)) -
                  (if J = SLM.Target (I) then 1.0 else 0.0)) / Float_32 (SLM.Size);
            begin
               Gradient.Set (ST.Tensor_Index'(I, J), G);
            end;
         end loop;
      end loop;
      return Gradient;
      
   end Backward;
end Mlengine.LossFunctions;
