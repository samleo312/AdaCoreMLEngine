with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

package body Mlengine.Operators is
   
   --forward procedure
   procedure Forward(Layer: in out ReLU; X: in out Float_Array) is
      begin
         --iterate thru input array
         for I in X'Range loop
            --if num is negative, set to 0
            if X(I) < 0.0 then
               X(I) := 0.0;
            end if;
         end loop;
      Layer.Activated := X;
   end Forward;

   --TODO: Backward

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
