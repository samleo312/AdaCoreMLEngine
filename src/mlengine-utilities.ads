with Mlengine.Operators;
with Mlengine.Optimizers; use Mlengine.Optimizers;
with Mlengine.LossFunctions; use Mlengine.LossFunctions;
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;
with Ada.Containers;
with Ada.Containers.Vectors;

package Mlengine.Utilities is

   package Layer_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Mlengine.Operators.Func_Access_T);

   use Layer_Vector;

   package Float_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Float);

   use Float_Vector;

   package Param_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => ParamsArray);

   use Param_Vector;


   type Target_Array is array (Positive range <>) of Standard.Integer;  


   type Model is record
      Graph : Layer_Vector.Vector;
      Parameters : Parameter_Groups_Access;
   end record;

   type DataGenerator (Batch_Size : Integer) is record
      Data : Tensor;
      Num_Batches : Integer;
      Target : Target_Array(1 .. Batch_Size);
      Counter : Integer;
   end record;

   type Batch_Result (Batch_Size : Integer) is record
     Batch_Data  : Tensor;
     Batch_Target: Target_Array(1 .. Batch_Size);
   end record;

   procedure Add(M : in out Model; Layer: Mlengine.Operators.Func_Access_T);
   procedure InitializeNetwork(M : in out Model);
   procedure GenSpiralData(Data : out CPU_Tensor; Target : out Target_Array; Points_Per_Class, Num_Classes : Integer);
   procedure Fit(M: in out Model; Data : CPU_Tensor; Target : Target_Array; Batch_Size : Integer; Num_Epochs : Integer; Optimizer : SGD ; Loss_Fn : SoftLossMax_T) return Float_Vector.Vector;
   function Predict(M : in out Model; Data : CPU_Tensor) return CPU_Tensor;
   function Calculate_Accuracy(Predicted : CPU_Tensor; TestTargets : Target_Array) return Float;
   

end Mlengine.Utilities;
