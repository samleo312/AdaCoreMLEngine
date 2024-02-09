with Orka.Numerics.Singles.Tensors.CPU;
use Orka.Numerics.Singles.Tensors.CPU;
package Mlengine.LossFunctions is

    package OT renames Orka.Numerics.Singles.Tensors;
    package OTI renames Orka.Numerics.Singles.Tensors.CPU; -- (O)rka (T)ensor (I)mplementation
    
    subtype Tensor is OTI.CPU_Tensor;
    subtype F32 is Orka.Float_32;

    type Target_Indices is array (Positive range <>) of Positive;

    function Soft_Max (Z: Tensor) return Tensor;
    function Cross_Entropy_Loss (Z: Tensor; Target: Target_Indices) return F32;

    function Soft_Max_Loss (Z: Tensor; Target: Target_Indices) return F32;


end Mlengine.LossFunctions;