with Mlengine.Operators; use Mlengine.Operators;
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

  --   package Float_Vector is new
  --     Ada.Containers.Vectors
  --       (Index_Type   => Natural,
  --        Element_Type => Float);

  --   use Float_Vector;

  --   type Target_Array is array (Positive range <>) of Standard.Integer;  


   type Model is record
      Graph : Layer_Vector.Vector;
      Parameters : Tensor_Vector.Vector;
   end record;

  --  type DataGenerator (Batch_Size : Integer) is record
  --    Data : Tensor;
  --    Num_Batches : Integer;
  --    Target : Target_Array(1 .. Batch_Size);
  --    Counter : Integer;
  --  end record;

  --  type Batch_Result (Batch_Size : Integer) is record
  --      Batch_Data  : Tensor;
  --      Batch_Target: Target_Array(1 .. Batch_Size);
  --  end record;

  procedure Add(M : in out Model; Layer: Mlengine.Operators.Func_Access_T);
  --  procedure InitializeNetwork(M : in out Model);
  --  function GenSpiralData(Points_Per_Class : Positive; Num_Classes : Positive) return Batch_Result;
  --  procedure Fit(M : in out Model; Points_Per_Class, Num_Classes : Integer; Batch_Size : Integer; Num_Epochs : Integer; Optimizer : Optimizers.SGD; Loss_Fn : LossFunctions.SoftLossMax_T);
  --  function Predict(M : in out Model; Data : CPU_Tensor) return CPU_Tensor;
  --  function Calculate_Accuracy(Predicted : CPU_Tensor; TestTargets : Target_Array) return Float;
   

end Mlengine.Utilities;
