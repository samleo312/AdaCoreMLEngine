with Mlengine;

package Mlengine.Operators is
   type Func_T is interface;
   type Func_Access_T is access all Func_T'Class;

   function Forward (E : in out Func_T; X : in Tensor) return ST_CPU.CPU_Tensor is abstract;
   function Backward (E : Func_T; dY : in Tensor) return ST_CPU.CPU_Tensor is abstract;
   --function Get_Params (E : Func_T) return ST_CPU.CPU_Tensor is abstract;

   type Linear_T is new Func_T with record
      Weights : Tensor;
      Bias : Tensor;
      Input : Tensor;
   end record;
   
   overriding function Forward (E : in out Linear_T; X : in Tensor) return ST_CPU.CPU_Tensor;
   overriding function Backward (E : Linear_T; dY : in Tensor) return ST_CPU.CPU_Tensor;
   --overriding function Get_Params (E : Linear_T) return ST_CPU.CPU_Tensor;

end Mlengine.Operators;
