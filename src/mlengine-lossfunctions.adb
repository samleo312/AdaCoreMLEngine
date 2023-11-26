with Ada.Numerics; use Ada.Numerics;
with Ada.Numerics.Elementary_Functions;
use  Ada.Numerics.Elementary_Functions;

package body Mlengine.LossFunctions is

   -- forward function calculates the Softmax Loss
   function Forward(X: Float_Array; Target: Float_Array) return Float is
      -- declaring variables
      Max_Value : Float := X(1);
      Prob_Sum : Float := 0.0;
      Exp_Sum : Float := 0.0;
      Loss : Float;

   begin
      --find max value in X
      for I in X'Range loop
         --if num is negative, set to 0
         if X(I) > Max_Value then
            Max_Value := X(I);
         end if;
      end loop;
      -- calculate the exponential of each element in X while summing up the exponentials 
      for J in X'Range loop
         Exp_Sum := Exp_Sum + Exp(X(J) - Max_Value);
      end loop;

      -- calculate the probability and the loss
      for K in X'Range loop
         Prob_Sum := Prob_Sum + Exp(X(K) - Max_Value);   -- unnormalized_proba = np.exp(x-np.max(x,axis=1,keepdims=True)), 
         if X(K) = Target(K) then
            Loss := -Log(Exp(X(K) - Max_Value) / Exp_Sum);  -- loss = -np.log(self.proba[range(len(target)),target])
         end if;
      end loop; 
      return Loss;
   end Forward;
end Mlengine.LossFunctions;
