with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;
package Mlengine.Operators is
   
   --relu declared
   type ReLU is record
      FuncType : Unbounded_String := To_Unbounded_String("activation");
      Inplace : Boolean := True;
      --Activated : Float_Array := (others => 0.0);
      Activated : Float_Array(1..5) := (0.0, 0.0, 0.0, 0.0, 0.0);
   end record;

   --forward procedure
   procedure Forward(Layer : in out ReLU; X : in out Float_Array);
   
   
end Mlengine.Operators;
