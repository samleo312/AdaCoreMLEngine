with Ada.Numerics;                      use Ada.Numerics;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with AUnit.Assertions;                  use AUnit.Assertions;
with Orka; --for Float32 type

use Orka; --for operator
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;

package body Mlengine.LossFunctions is
   procedure Forward is
      -- declaring variables
      type Test_Array is array (Positive range <>) of Float;
      X : Test_Array (1 .. 3)       := (2.5, 1.5, 0.7);     -- simulating tensors
      Targets       : array (1 .. 2) of Natural := (1, 2);  -- target indices
      MaxValue      : Float := X (1);                       -- max value in array
      Probabilities : array (1 .. 3) of Float;              -- storing the probabilities
      Exp_Sum       : Float                     := 0.0;
      Loss          : Float;
      Expected_Loss : Float                     := 0.927343;

   begin
      --find max value in X
      for I in X'Range loop
         if X (I) > MaxValue then
            MaxValue := X (I);
         end if;
      end loop;
      Put_Line ("Max Value: " & Float'Image (MaxValue));

      -- calculate unnormalized probabilities and exponential sum
      for J in X'Range loop
         Exp_Sum := Exp_Sum + Exp (X (J) - MaxValue);
      end loop;

      for K in X'Range loop
         Probabilities (K) := Exp (X (K) - MaxValue) / Exp_Sum;
      end loop;

      -- calculate the loss based on the predicted probabilities
      Loss := 0.0;
      for k in Targets'Range loop
         Loss := Loss - Log (Probabilities (Targets (K)));
      end loop;
      Loss := Loss / Float (Targets'Length);  -- Average loss over all targets

      Put_Line ("Loss: " & Float'Image (Loss));

      -- display probabilities
      for K in Probabilities'Range loop
         Put_Line ("Probability: " & Float'Image (Probabilities (K)));
      end loop;

      Assert (Loss = Expected_Loss, "Loss is incorrect");

   end Forward;

end Mlengine.LossFunctions;
