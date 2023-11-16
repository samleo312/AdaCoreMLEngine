with Orka.Numerics.Tensors;
with Orka.Numerics.Tensors.SIMD_CPU;
use Orka.Numerics.Tensors.SIMD_CPU;
package Mlengine is

    type Grad_Tensor is record
        Tensor : CPU_Tensor;
        Gradient : CPU_Tensor;
    end record;

    package Numeric_Tensors is new Orka.Numerics.Tensors (Float);
    subtype Float_Array is Numeric_Tensors.Element_Array;

end Mlengine;
