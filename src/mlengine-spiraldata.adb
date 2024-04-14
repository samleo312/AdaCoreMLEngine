with Mlengine;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics; use Ada.Numerics;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Generate_Gaussian_Random;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Mlengine.LossFunctions; use Mlengine.LossFunctions;
with Orka.Numerics.Singles.Tensors.GPU; use Orka.Numerics.Singles.Tensors.GPU;


package body Mlengine.spiraldata is
   -- Constants for pi and a small constant value
   Pi : constant := Ada.Numerics.Pi;
   Small_Constant : constant Float := 0.1;

   type Float_Array is array (Positive range <>) of Float;
   type Int_Array is array (Positive range <>) of Integer;

   function Linspace
        (Start, Stop : Float; Num : Positive) return Float_Array
      is
         Step   : Float := (Stop - Start) / Float (Num - 1);
         Result : Float_Array (1 .. Num);
      begin
         for I in Result'Range loop
            Result (I) := Start + Float (I - 1) * Step;
         end loop;
         return Result;
      end Linspace;

   function Generate_Spiral_Data (Points_Per_Class : Integer; Num_Classes : Integer; Target_Return : out Target_Array) return GPU_Tensor is
      -- Generate points along the radius of the spiral
      Data : ST_GPU.GPU_Tensor := ST_GPU.Zeros((Num_Classes*Points_Per_Class,2));

      --Target : Target_Array (1..(Num_Classes * Points_Per_Class)) := (others => 0);

      R : Float_Array := Linspace (0.0, 1.0, Points_Per_Class);

      -- Calculate the angle between each class in radians
      Radians_Per_Class : constant Float := 2.0 * Pi / Float (Num_Classes);

   begin
      -- Loop through each class to generate spiral data
      for I in 1 .. Num_Classes loop
         -- Generate angles for each point in the spiral with some randomness
         declare
            T : Float_Array := Linspace((Float(I)*Radians_Per_Class), ((Float(I) + 1.5)*Radians_Per_Class), Points_Per_Class);
         begin
            for J in 1 .. Points_Per_Class loop
               T(J) :=  T(J) + (Generate_Gaussian_Random * Small_Constant);
            end loop;

            -- Generate the coordinates for each point in the spiral using polar coordinates
            for J in 1 .. Points_Per_Class loop
               declare
                  x_res : F32 := F32(R(J) * Sin(T(J)));
                  y_res : F32 := F32(R(J) * Cos(T(J)));
               begin
                  Data.set(((J+ (Points_Per_Class * (I-1)), 1)), (x_res));
                  Data.set(((J+ (Points_Per_Class * (I-1)), 2)), (y_res));
               end;
            end loop;

            -- Set target values for each class
            for J in 1 .. Points_Per_Class loop
               Target_Return(J + (I-1)* Points_Per_Class) := (I); -- needs to be an array of integers as defined in loss
            end loop;
         end;
      end loop;
      return Data;
      --Put_Line(ST_GPU.Image(Data));
      --Put_Line(Target'Image);
      -- Perform any further processing or return the data and target arrays
   end Generate_Spiral_Data;
end Mlengine.spiraldata;
