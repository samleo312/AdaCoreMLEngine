with Ada.Text_IO; use Ada.Text_IO;

package body Mlengine.Operators is

   --   def forward(self,x):
   --       output = np.dot(x,self.weights.data)+self.bias.data
   --       self.input = x 
   --       return output
   overriding function Forward (E : Linear_T) return ST_CPU.CPU_Tensor is
      Tensor : ST_CPU.CPU_Tensor := ST_CPU.To_Tensor ([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], Shape => [3, 2]);
   begin
      Put_Line (E'Image);
      return Tensor;
   end;

   overriding function Backward (E : Linear_T) return ST_CPU.CPU_Tensor is
      Tensor : ST_CPU.CPU_Tensor := ST_CPU.To_Tensor ([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], Shape => [3, 2]);
   begin
      Put_Line (E'Image);
      return Tensor;
   end;

   overriding function Get_Params (E : Linear_T) return ST_CPU.CPU_Tensor is
      Tensor : ST_CPU.CPU_Tensor := ST_CPU.To_Tensor ([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], Shape => [3, 2]);
   begin
      Put_Line (E'Image);
      return Tensor;
   end;

   overriding function Forward (E : ReLU_T) return ST_CPU.CPU_Tensor is
      Tensor : ST_CPU.CPU_Tensor := ST_CPU.To_Tensor ([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], Shape => [3, 2]);
   begin
      Put_Line (E'Image);
      return Tensor;
   end;

   overriding function Backward (E : ReLU_T) return ST_CPU.CPU_Tensor is
      Tensor : ST_CPU.CPU_Tensor := ST_CPU.To_Tensor ([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], Shape => [3, 2]);
   begin
      Put_Line (E'Image);
      return Tensor;
   end;

   overriding function Get_Params (E : ReLU_T) return ST_CPU.CPU_Tensor is
      Tensor : ST_CPU.CPU_Tensor := ST_CPU.To_Tensor ([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], Shape => [3, 2]);
   begin
      Put_Line (E'Image);
      return Tensor;
   end;

end Mlengine.Operators;
