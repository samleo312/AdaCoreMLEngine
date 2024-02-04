with Ada.Text_IO; use Ada.Text_IO;

package Mlengine.LossFunctions is

   type Func_T is interface;

   type SoftLossMax_T is new Func_T with record
      Proba : ST_CPU.CPU_Tensor ;
      Target : array (1 .. 20) of Orka.Float_32;
   end record;

   type Func_Access_T is access all Func_T'Class;


   -- function Forward(X : Float_Array; Target : Float_Array) return Float;

   type Test_Array is array(Positive range <>) of Float; -- Simulating a Tensor 
   function Forward (X : in out ST_CPU.CPU_Tensor; Target : in array (1 .. 20) of Orka.Float_32) return Orka.Float_32;
   function Backward(E : SoftLossMax_T) return ST_CPU.CPU_Tensor;
end Mlengine.LossFunctions;
