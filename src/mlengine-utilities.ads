with Mlengine.Operators; use Mlengine.Operators;
with Ada.Containers;
with Ada.Containers.Vectors;

package Mlengine.Utilities is

   package Integer_Vectors is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Func_Access_T);

   use Integer_Vectors;

   type Model is record
      Graph : Vector;
   end record;

   procedure Add(M : Model);
   function Fit(M: Model; Data : Integer; Target : Integer; Batch_Size : Integer; Num_Epochs : Integer; Optimizer : Integer; Loss_Fn : Integer);
   function Predict(M : Model; Data : Integer);

end Mlengine.Utilities;
