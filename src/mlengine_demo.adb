with Ada.Text_IO;
with Mlengine.Operators;
with Mlengine;
with Mlengine.LossFunctions;

procedure Mlengine.Mlengine_Demo is
   --relu struct from operators
   -- MyReLU: Mlengine.Operators.ReLU;
   --test input array
   -- InputArray : Float_Array := (1.0, -2.0, 3.0, -4.0, 5.0);

   --SoftMaxLoss variables
   Input: Float_Array := (1.2, 0.8, -0.5);
   Target: Float_Array := (1.0, 1.0, 2.0);
   Loss: Float;

begin
   -- Ada.Text_IO.Put_Line("Test Demo");

   --call forward func
   -- Mlengine.Operators.Forward(MyReLU,InputArray);

   --display activated array to test behaviour
   -- Ada.Text_IO.Put_Line("Activated Array:");
   --  for I in MyReLU.Activated'Range loop
   --     Ada.Text_IO.Put(Float'Image (MyReLU.Activated(I)));
   --  end loop;

   -- SoftMaxLoss testing
   Ada.Text_IO.Put_Line(" Testing SoftMaxLoss Function: ");

   -- call forward function
   Loss := Mlengine.LossFunctions.Forward(Input, Target);
   Ada.Text_IO.Put_Line("Loss: " & Float'Image(Loss));

end Mlengine.Mlengine_Demo;
