with Ada.Text_IO; use Ada.Text_IO;

package Mlengine.LossFunctions is

   --  type SoftmaxWithLoss is record
   --     Proba : Float_Array;
   --     Target : Integer_Array;
   --  end record;

   function Forward(X : Float_Array; Target : Float_Array) return Float;

end Mlengine.LossFunctions;
