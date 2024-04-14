with Orka.Numerics.Singles.Tensors;
with Orka.Numerics.Singles.Tensors.GPU;

package Mlengine is

    package ST renames Orka.Numerics.Singles.Tensors;
    package ST_GPU renames Orka.Numerics.Singles.Tensors.GPU;

    type Tensor_Access is access ST_GPU.GPU_Tensor; 

    type Tensor is record
        Data : Tensor_Access;
        Grad : Tensor_Access;
    end record;

    type Elements_Access is access all ST.Element_Array;

    subtype ET is ST.Element;

    subtype F32 is Orka.Float_32;
end Mlengine;
