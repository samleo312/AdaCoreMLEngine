with Orka;
with Orka.Numerics.Singles.Tensors.CPU;
use Orka.Numerics.Singles.Tensors.CPU;

package Mlengine is
    package OT renames Orka.Numerics.Singles.Tensors;
    package OTI renames Orka.Numerics.Singles.Tensors.CPU; -- (O)rka (T)ensor (I)mplementation

    subtype F32 is Orka.Float_32;
    subtype ND_Array is OTI.CPU_Tensor;
end Mlengine;
