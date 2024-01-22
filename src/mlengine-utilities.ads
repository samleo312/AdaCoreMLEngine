with Mlengine.Operators; use Mlengine.Operators;
with Mlengine.Optimizers; use Mlengine.Optimizers;
with Mlengine.LossFunctions; use Mlengine.LossFunctions;
with Ada.Containers;
with Ada.Containers.Vectors;

package Mlengine.Utilities is

   package Layer_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Func_Access_T);

   use Layer_Vector;

   type Model is record
      Graph : Vector;
   end record;

   procedure Add(M : in out Model; Layer: Func_Access_T);
   function Fit(M: in out Model; Data : Tensor; Target : Tensor; Batch_Size : Integer; Num_Epochs : Integer; Optimizer : SGD ; Loss_Fn : SoftmaxWithLoss);
   function Predict(M : in out Model; Data : Tensor);

end Mlengine.Utilities;
