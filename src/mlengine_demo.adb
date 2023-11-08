with Ada.Text_IO;
with Mlengine.Operators;
with Mlengine;

procedure Mlengine.Mlengine_Demo is
   --relu struct from operators
   MyReLU: Mlengine.Operators.ReLU;
   --test input array
   InputArray : Float_Array := (1.0, -2.0, 3.0, -4.0, 5.0);

begin
   Ada.Text_IO.Put_Line("Test Demo");

   --call forward func
   Mlengine.Operators.Forward(MyReLU,InputArray);

   -- Display the Activated array from the ReLU struct to verify the function's behavior
   Ada.Text_IO.Put_Line("Activated Array:");
   for I in MyReLU.Activated'Range loop
      Ada.Text_IO.Put(Float'Image (MyReLU.Activated(I)));
   end loop;
end Mlengine.Mlengine_Demo;
