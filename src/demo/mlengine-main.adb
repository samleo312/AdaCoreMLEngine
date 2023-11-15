with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;

procedure Mlengine.Main is
   Input : Tensor;
   -- Declare a 2D tensor of size 3 by 4
begin
   Input.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
   Input.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

   Put_Line(Input.Data.Shape(1)'Image);

   for I in 1..(Input.Data.Shape(1)) loop
      for J in 1..(Input.Data.Shape(2)) loop
         Ada.Text_IO.Put("horsey ");
      end loop;
      Ada.Text_IO.New_Line;
   end loop;

   Put_Line(Input.Data.Image);
   
end Mlengine.Main;
