with Ada.Text_IO; use Ada.Text_IO;

package Mlengine.LossFunctions is

   type Func_T is interface;

   type Target_Array is array (1 .. 20) of Orka.Float_32;
   type Float_Array_20 is array (1 .. 20) of Float;
   type SoftLossMax_T is new Func_T with record
      Proba : Tensor ;
      Target : Target_Array;
   end record;

   type Func_Access_T is access all Func_T'Class;


  
   function Forward (E: in out SoftLossMax_T; X : in out ST_CPU.CPU_Tensor; Target : in Target_Array) return Orka.Float_32;
   function Backward(E : in out SoftLossMax_T) return ST_CPU.CPU_Tensor;
end Mlengine.LossFunctions;
