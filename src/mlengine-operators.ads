with Mlengine;
with Ada.Text_IO;

package Mlengine.Operators is
   type Func_T is interface;
   type Func_Access_T is access all Func_T'Class;

   type Index is range 1 .. 2;
   type ParamsArray is array(Index) of Tensor;

   function Forward (E : in out Func_T; X : in Tensor) return ST_CPU.CPU_Tensor is abstract;
   function Backward (E : in out Func_T; dY : in Tensor) return ST_CPU.CPU_Tensor is abstract;
   function Get_Params (E : Func_T) return ParamsArray is abstract;

   subtype Layer_Type is String (0 .. 6);

   type Linear_T is new Func_T with record
      Weights : Tensor;
      Bias : Tensor;
      Input : Tensor;
      LayerType : Layer_Type := "linear"; 
   end record;

   
   
   overriding function Forward (E : in out Linear_T; X : in Tensor) return ST_CPU.CPU_Tensor;
   overriding function Backward (E : in out Linear_T; dY : in Tensor) return ST_CPU.CPU_Tensor;
   overriding function Get_Params (E : Linear_T) return ParamsArray;

   type ReLU_T is new Func_T with record
      Activated : Tensor;
   end record;

   overriding function Forward (E : in out ReLU_T; X : in Tensor) return ST_CPU.CPU_Tensor;
   overriding function Backward (E : in out ReLU_T; dY : in Tensor) return ST_CPU.CPU_Tensor;
   overriding function Get_Params (E : ReLU_T) return ParamsArray;

end Mlengine.Operators;
