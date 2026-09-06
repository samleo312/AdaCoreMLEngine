with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

package body Mlengine.Utilities is
   package Storage_Vector is new Ada.Containers.Vectors
     (Index_Type => Natural, Element_Type => CPU_Tensor_Access);

   procedure Release (Storage : in out Storage_Vector.Vector) is
   begin
      for P of Storage loop
         Free_CPU_Tensor (P);
      end loop;
      Storage.Clear;
   end Release;

   procedure Add (M : in out Model; Layer : Mlengine.Operators.Func_Access_T) is
      Params : constant ParamsArray := Layer.Get_Params;
   begin
      M.Graph.Append (Layer);
      for P of Params loop
         if P /= null then
            M.Parameters.Append (P);
         end if;
      end loop;
   end Add;

   procedure InitializeNetwork (M : in out Model) is
   begin
      for G of M.Graph loop
         G.all.InitializeLayer;
      end loop;
   end InitializeNetwork;

   procedure Fit
     (M : in out Model; Data : Tensor; Target : Target_Array;
      Batch_Size : Integer; Num_Epochs : Integer;
      Optimizer : in out Optimizers.SGD;
      Loss_Fn : in out LossFunctions.SoftLossMax_T)
   is
      N : constant Positive := Data.Data.Shape (1);
      Order : array (1 .. N) of Positive;
      package Random_Indices is new Ada.Numerics.Discrete_Random (Positive);
      Generator : Random_Indices.Generator;
   begin
      if Batch_Size < 1 or Target'Length /= N then
         raise Constraint_Error with "Invalid training batch size or targets";
      end if;
      Random_Indices.Reset (Generator, 12345);
      for I in Order'Range loop
         Order (I) := I;
      end loop;
      InitializeNetwork (M);
      -- A new fit starts both parameters and momentum afresh.
      InitializeSGD (Optimizer);
      for Epoch in 1 .. Num_Epochs loop
         for I in reverse 2 .. N loop
            declare
               J : constant Positive := Random_Indices.Random (Generator, 1, I);
               Saved : constant Positive := Order (I);
            begin
               Order (I) := Order (J);
               Order (J) := Saved;
            end;
         end loop;
         declare
            Start : Positive := 1;
            Epoch_Loss : Float_32 := 0.0;
         begin
            while Start <= N loop
               declare
                  Count : constant Positive := Integer'Min (Batch_Size, N - Start + 1);
                  Batch : Tensor :=
                    (Data => new CPU_Tensor'(Zeros ((Count, Data.Data.Shape (2)))),
                     Grad => null);
                  Labels : Target_Array (1 .. Count);
                  Local_Loss : SoftLossMax_T (Count);
                  Storage : Storage_Vector.Vector;
                  X : Tensor := Batch;
                  Grad : Tensor;
                  Loss : Float_32;
               begin
                  for I in 1 .. Count loop
                     Labels (I) := Target (Target'First + Order (Start + I - 1) - 1);
                     for J in 1 .. Data.Data.Shape (2) loop
                        declare
                           Value : constant Float_32 := Data.Data.all.Get
                             (ST.Tensor_Index'(Order (Start + I - 1), J));
                        begin
                           Batch.Data.Set (ST.Tensor_Index'(I, J), Value);
                        end;
                     end loop;
                  end loop;
                  Optimizer.Zero_Grad;
                  for G of M.Graph loop
                     declare
                        Y : constant CPU_Tensor := G.all.Forward (X);
                     begin
                        X.Data := new CPU_Tensor'(Y);
                        Storage.Append (X.Data);
                     end;
                  end loop;
                  -- The final partial batch has its own correctly sized loss.
                  if Count = Loss_Fn.Size then
                     Loss := Loss_Fn.Forward (X.Data.all, Labels);
                     Grad.Data := new CPU_Tensor'(Loss_Fn.Backward);
                  else
                     Loss := Local_Loss.Forward (X.Data.all, Labels);
                     Grad.Data := new CPU_Tensor'(Local_Loss.Backward);
                  end if;
                  Storage.Append (Grad.Data);
                  for G of reverse M.Graph loop
                     declare
                        D : constant CPU_Tensor := G.all.Backward (Grad);
                     begin
                        Grad.Data := new CPU_Tensor'(D);
                        Storage.Append (Grad.Data);
                     end;
                  end loop;
                  Optimizer.Step;
                  Epoch_Loss := Epoch_Loss + Float_32 (Count) * Loss;
                  Release (Storage);
                  Free_Tensor (Batch);
                  Free_Tensor (Local_Loss.Proba);
               exception
                  when others =>
                     Release (Storage);
                     Free_Tensor (Batch);
                     Free_Tensor (Local_Loss.Proba);
                     raise;
               end;
               Start := Start + Batch_Size;
            end loop;
            Put_Line ("Epoch" & Epoch'Image & " mean loss =" &
                      Float_32'Image (Epoch_Loss / Float_32 (N)));
         end;
      end loop;
   end Fit;

   function Predict (M : in out Model; Data : Tensor) return CPU_Tensor is
      X : Tensor := Data;
      Storage : Storage_Vector.Vector;
   begin
      for G of M.Graph loop
         declare
            Y : constant CPU_Tensor := G.all.Forward (X);
         begin
            X.Data := new CPU_Tensor'(Y);
            Storage.Append (X.Data);
         end;
      end loop;
      return Result : CPU_Tensor := X.Data.all do
         Release (Storage);
      end return;
   exception
      when others =>
         Release (Storage);
         raise;
   end Predict;

   function Calculate_Accuracy (Predicted : CPU_Tensor; TestTargets : Target_Array)
     return Float
   is
      Correct : Natural := 0;
   begin
      if Predicted.Shape (1) /= TestTargets'Length then
         raise Constraint_Error with "Prediction and target lengths differ";
      end if;
      for I in 1 .. Predicted.Shape (1) loop
         declare
            Best : Positive := 1;
         begin
            for J in 2 .. Predicted.Shape (2) loop
               if Float_32'(Predicted.Get (ST.Tensor_Index'(I, J))) >
                 Float_32'(Predicted.Get (ST.Tensor_Index'(I, Best)))
               then
                  Best := J;
               end if;
            end loop;
            if Best = TestTargets (TestTargets'First + I - 1) then
               Correct := Correct + 1;
            end if;
         end;
      end loop;
      return Float (Correct) / Float (TestTargets'Length);
   end Calculate_Accuracy;
end Mlengine.Utilities;
