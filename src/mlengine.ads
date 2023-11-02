with Orka.Numerics.Tensors.SIMD_CPU;
use Orka.Numerics.Tensors.SIMD_CPU;
package Mlengine is

    type Grad_Tensor is record
        Tensor : CPU_Tensor;
        Gradient : CPU_Tensor;
    end record;

end Mlengine;
