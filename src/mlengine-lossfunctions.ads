with Ada.Text_IO; use Ada.Text_IO;

package Mlengine.LossFunctions is

   -- function Forward(X : Float_Array; Target : Float_Array) return Float;

   type Test_Array is array(Positive range <>) of Float; -- Simulating a Tensor 
   procedure Forward;

end Mlengine.LossFunctions;
