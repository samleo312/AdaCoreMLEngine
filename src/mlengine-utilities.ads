with Mlengine.Operators; use Mlengine.Operators;
with Mlengine.Optimizers; use Mlengine.Optimizers;
with Mlengine.LossFunctions; use Mlengine.LossFunctions;
with Orka.Numerics.Singles.Tensors.GPU; use Orka.Numerics.Singles.Tensors.GPU;
with Ada.Containers;
with Ada.Containers.Vectors;
with Orka; use Orka;

package Mlengine.Utilities is

   package Layer_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Mlengine.Operators.Func_Access_T);

   use Layer_Vector;

   package Float32_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Orka.Float_32);

   use Float32_Vector;


   type Model is record
      Graph : Layer_Vector.Vector;
      Parameters : Tensor_Vector.Vector;
   end record;

  type Batch_Result (Batch_Size : Integer) is record
      Batch_Data  : Tensor;
      Batch_Target: Target_Array(1 .. Batch_Size);
  end record;

  procedure Add(M : in out Model; Layer: Mlengine.Operators.Func_Access_T);
  procedure InitializeNetwork(M : in out Model);
  procedure Fit(M : in out Model; Data : Tensor; Target : Target_Array; Batch_Size : Integer; Num_Epochs : Integer; Optimizer : in out Optimizers.SGD; Loss_Fn : in out LossFunctions.SoftLossMax_T);
  
  function Predict(M : in out Model; Data : Tensor) return GPU_Tensor;
  function Calculate_Accuracy(Predicted : GPU_Tensor; TestTargets : Target_Array) return Float;
   

end Mlengine.Utilities;
