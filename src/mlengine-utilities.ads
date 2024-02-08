with Mlengine.Operators; use Mlengine.Operators;
with Mlengine.Optimizers; use Mlengine.Optimizers;
--with Mlengine.LossFunctions; use Mlengine.LossFunctions;
with Ada.Containers;
with Ada.Containers.Vectors;


package Mlengine.Utilities is

   package Layer_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Func_Access_T);

   use Layer_Vector;

   package Float_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Orka.Float_32);

   use Float_Vector;

   package Param_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => ParamsArray);

   use Param_Vector;


   -- Array size needs to be equal to Batch Size, how to dynamically change type definition.
   -- If variable is in type definition, does editing the variable change the size capability of the array.
   type Target_Array is array (1 .. 20) of Standard.Integer;
   


   type Model is record
      Graph : Layer_Vector.Vector;
      Parameters : Param_Vector.Vector;
   end record;

   type DataGenerator is record
      Data : Tensor;
      Target : Target_Array;
      Batch_Size : Integer;
      Num_Batches : Integer;
      Counter : Integer;
   end record;

   procedure Add(M : in out Model; Layer: Func_Access_T);
   procedure InitializeNetwork(M : in out Model);
   function Fit(M: in out Model; Data : Tensor; Target : Target_Array; Batch_Size : Integer; Num_Epochs : Integer; Optimizer : SGD ; Loss_Fn : SoftLossMax_T);
   function Predict(M : in out Model; Data : Tensor);
   

end Mlengine.Utilities;
