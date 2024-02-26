with Mlengine;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics; use Ada.Numerics;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Strings.Hash;

package Mlengine.spiraldata is

      type Target_Array is array (Positive range <>) of Standard.Integer;

   procedure Generate_Spiral_Data (Points_Per_Class : Integer; Num_Classes : Integer);

end Mlengine.spiraldata;