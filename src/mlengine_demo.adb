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

   --display activated array to test behaviour
   Ada.Text_IO.Put_Line("Activated Array:");
   for I in MyReLU.Activated'Range loop
      Ada.Text_IO.Put(Float'Image (MyReLU.Activated(I)));
   end loop;
end Mlengine.Mlengine_Demo;
