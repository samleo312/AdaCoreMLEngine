with Mlengine;
with Mlengine.LossFunctions; use Mlengine.LossFunctions;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics; use Ada.Numerics;
with Ada.Containers.Indefinite_Hashed_Maps;
with Orka.Numerics.Singles.Tensors.GPU; use Orka.Numerics.Singles.Tensors.GPU;
with Ada.Strings.Hash;

package Mlengine.spiraldata is

function Generate_Spiral_Data (Points_Per_Class : Integer; Num_Classes : Integer; Target_Return : out Target_Array) return GPU_Tensor;
end Mlengine.spiraldata;