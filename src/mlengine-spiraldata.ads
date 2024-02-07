with Mlengine;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics; use Ada.Numerics;

package Mlengine.spiraldata is
   procedure Generate_Spiral_Data (Points_Per_Class : Integer; Num_Classes : Integer);

--  private
--     type Float_Array is array (Positive range <>) of Float;
--     type Int_Array is array (Positive range <>) of Integer;

--     function Random_Gaussian (Mean : Float; Std_Dev : Float) return Float;
end Mlengine.spiraldata;