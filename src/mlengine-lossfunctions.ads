with Ada.Text_IO; use Ada.Text_IO;

package Mlengine.LossFunctions is

   type Func_T is interface;
   type Func_Access_T is access all Func_T'Class;

   --  type SoftLossMax_T is new Func_T with record
   --     Type_T: String;
   --  end record;

   -- function Forward(X : Float_Array; Target : Float_Array) return Float;

   type Test_Array is array(Positive range <>) of Float; -- Simulating a Tensor 
   procedure Forward;

end Mlengine.LossFunctions;
