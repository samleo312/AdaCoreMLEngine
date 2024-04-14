with Ada.Text_IO; use Ada.Text_IO;

package Mlengine.LossFunctions is

   type Func_T is interface;

   type Target_Array is array (Positive range <>) of Standard.Integer;
   type Float_Array is array(Positive range <>) of Orka.Float_32;
   
   type SoftLossMax_T (Size : Positive) is new Func_T with record
      Proba : Tensor;
      Target : Target_Array(Positive'First .. Size);
   end record;

   type Func_Access_T is access all Func_T'Class;

   function Forward (SLM    : in out SoftLossMax_T; 
                     X      : in out ST_GPU.GPU_Tensor; 
                     Target : in out Target_Array) return Orka.Float_32;

   function Backward (SLM : in out SoftLossMax_T) return ST_GPU.GPU_Tensor;
end Mlengine.LossFunctions;
