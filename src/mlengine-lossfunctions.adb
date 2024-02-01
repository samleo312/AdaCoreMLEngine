with Ada.Numerics;                      use Ada.Numerics;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
--with AUnit.Assertions;                  use AUnit.Assertions;
with Orka; --for Float32 type
use Orka; --for operator
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;

package body Mlengine.LossFunctions is

   --!!!!!!!!!!!!!!!!!!!!theres going to be conflicts we need to resolve between Orka Float_32, and Numerics Float!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   function Forward (X : in out ST_CPU.CPU_Tensor; Target : in array (1 .. 20) of Orka.Float_32) return Orka.Float_32 is
      maximum : Orka.Float_32 := 0.0;
      array_counter : Integer := 1;
      sums : array (1 .. 20) of Orka.Float_32 := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

   begin
      --find max value of each row and set it to pos in respective target array
      --for i in tensors rows
         for I in 1..(X.Shape(1)) loop
            --for j in tensors columns
            for J in 1..(X.Shape(2)) loop
               
               if (X((I,J))) > maximum then
                  maximum := (X((I,J)));
               end if;

            end loop;

            --target is maximums of each tensor row
            Target(array_counter) := (X((I,J)));
            array_counter := array_counter + 1;
            maximum := 0.0;
            
         end loop;

      --reset array counter
      array_counter := 1;

      --calc exponentials
      for I in 1..(X.Shape(1)) loop
            --for j in tensors columns
            for J in 1..(X.Shape(2)) loop
               --needs to be part of type
               Proba.Set (((I,J)), (e ** (X(I,J) - Target(array_counter))));

            end loop;
            --increment to next max for row
            array_counter := array_counter + 1;

            
         end loop;




          --reset array counter
      array_counter := 1;

      --sum unormalized probs
      for I in 1..(Proba.Shape(1)) loop
            --for j in tensors columns
            for J in 1..(Proba.Shape(2)) loop
               
              sums(I) := (sums(I)+X(I,J));

            end loop;
            
            
         end loop;

      --divide unormal proba by sum
      for I in 1..(Proba.Shape(1)) loop
            --for j in tensors columns
            for J in 1..(Proba.Shape(2)) loop
               
              Proba.Set (((I,J)), (Proba(I,J) / Sums(I)));

            end loop;
            
            
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

      --Assert (Loss = Expected_Loss, "Loss is incorrect");

   end Forward;

end Mlengine.LossFunctions;
