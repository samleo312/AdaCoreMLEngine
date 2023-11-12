with Mlengine;

package Mlengine.Operators is
   type Func_T is interface;
   type Func_Access_T is access all Func_T'Class;

   function Forward (E : Func_T) return ST_CPU.CPU_Tensor is abstract;
   function Backward (E : Func_T) return ST_CPU.CPU_Tensor is abstract;
   function Get_Params (E : Func_T) return ST_CPU.CPU_Tensor is abstract;

   type Linear_T is new Func_T with record
      Weights : Grad_Tensor;
      Bias : Grad_Tensor;
      Input : Grad_Tensor;
   end record;
   
   overriding function Forward (E : Linear_T) return ST_CPU.CPU_Tensor;
   overriding function Backward (E : Linear_T) return ST_CPU.CPU_Tensor;
   overriding function Get_Params (E : Linear_T) return ST_CPU.CPU_Tensor;

end Mlengine.Operators;
