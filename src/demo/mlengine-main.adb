with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;
with Orka;
with Orka.Numerics;
--with alire.cache.dependencies.orka_b455160b.orka_types.src.orka.ads;


procedure Mlengine.Main is
   Input : Tensor;
   Element1 : Orka.Float_32;
   -- Declare a 2D tensor of size 3 by 4
begin
   Input.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));
   Input.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((1.0, 2.0, 3.0, 4.0), (2, 2)));

   --Element := Get(Input.Data, (1, 1));
   --Element1 := Input.Data((1,1));

   --Put_Line((Input.Data.Get((1,1))));
   Element1 := (Input.Data((1,1)));
   Put_Line(Element1'Image);

   --Put_Line((Input.Data.Get((1, 1))));

   --Input.Data.Get((1, 1));
   --Ada.Text_IO.Put_Line((Orka.Float_32'Value(Input.Data.Get((1, 1)))'Image));

   
end Mlengine.Main;
