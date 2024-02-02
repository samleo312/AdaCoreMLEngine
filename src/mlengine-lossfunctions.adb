with Ada.Numerics;                      use Ada.Numerics;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
--with AUnit.Assertions;                  use AUnit.Assertions;
with Orka; --for Float32 type
use Orka; --for operator
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;

package body Mlengine.LossFunctions is

   --!!!!!!!!!!!!!!!!!!!!theres going to be conflicts we need to resolve between Orka Float_32, and Numerics Float!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   function Forward (E: in out SoftLossMax_T; X : in out ST_CPU.CPU_Tensor; Target : in array (1 .. 20) of Orka.Float_32) return Orka.Float_32 is
      maximum : Orka.Float_32 := 0.0;
      Maximums : array (1 .. 20) of Orka.Float_32;
      Losses : array (1 .. 20) of Orka.Float_32;
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
                                                                  0.0, 0.0, 0.0
                                                                   ), (20,3));
      --array_counter : Integer := 1;
      sums : array (1 .. 20) of Orka.Float_32 := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
      Losses_Sum : Orka.Float_32 := 0.0;

   begin
      --1a. find max value of each row and set it to pos in respective maximum array

      --for i in tensors rows
         for I in 1..(X.Shape(1)) loop
            --for j in tensors columns
            for J in 1..(X.Shape(2)) loop
               
               if (X((I,J))) > maximum then
                  maximum := (X((I,J)));
               end if;

            end loop;

            --maximums is maximums of each tensor row
            Maximums(I) := (X((I,J)));
            --move thru maximums array
            --array_counter := array_counter + 1;
            --reset max for next row
            maximum := 0.0;
            
         end loop;

      --reset array counter
      --array_counter := 1;

      --1b. calc exponentials of (X - Max of its row) adn assign to Un_Prob

      --for i in tensors rows
      for I in 1..(X.Shape(1)) loop
            --for j in tensors columns
            for J in 1..(X.Shape(2)) loop
               
               Unnormalized_Proba.Set (((I,J)), (e ** (X(I,J) - Maximums(I))));

            end loop;
            --increment to next max for row
            --array_counter := array_counter + 1;

            
      end loop;

      --reset array counter
      --array_counter := 1;

      --2a. sum unormalized probs and store in sums array
      --for i in tensors rows
      for I in 1..(Unnormalized_Proba.Shape(1)) loop
            --for j in tensors columns
            for J in 1..(Unnormalized_Proba.Shape(2)) loop
               
              sums(I) := (sums(I)+X(I,J));

            end loop;
            
            
      end loop;

      --2b. divide Un_Proba by sum for each row and assign to Proba
      --for i in tensors rows
      for I in 1..(Unnormalized_Proba.Shape(1)) loop
            --for j in tensors columns
            for J in 1..(Unnormalized_Proba.Shape(2)) loop
               
              E.Proba.Set (((I,J)), (Unnormalized_Proba(I,J) / Sums(I)));

            end loop;
            
            
      end loop;

      --3a. assign target to E.Target
      E.Target := Target;

      --4a. iterate thru target, taking target of each row inside E.Proba
      --and takin ghe negative loss of each, appending it to losses array
      for I in Target'Range loop
         Losses(I) := (-log(E.Proba(I,Target(I))));
      end loop;

      --5a. calculate sum of losses
      for I in Target'Range loop
         Losses_Sum := Losses_Sum + Losses(I);
      end loop;

      --5b. return loss mean (sums / total num)
      return (Losses_Sum / 20);

   

   end Forward;

end Mlengine.LossFunctions;
