with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

package body Mlengine.Operators is
   

   procedure Forward(Layer: in out ReLU; X: Float_Array) is
      --Activated : Float_Array;
   begin
      --Activated := X;
      for I in X'Range loop
         if X(I) < 0.0 then
            Layer.Activated(I) := 0.0;
         end if;
      end loop;
      --Layer.Activated := Activated;
   end Forward;

   --  function Backward(Layer: in out ReLU; D_Y: in Float_Array) return Float_Array is
   --     gradient_input: Float_Array := (others => 0.0);
   --  begin
   --     for I in D_Y'Range loop
   --        if Layer.Activated(I) > 0.0 then
   --           gradient_input(I) := D_Y(I);
   --        end if;
   --     end loop;
   --     return gradient_input;
   --  end Backward;
begin
   Ada.Text_IO.Put ("Hello ");
end Mlengine.Operators;
