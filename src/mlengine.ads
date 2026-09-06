with Orka;
with Orka.Numerics.Singles.Tensors;
with Orka.Numerics.Singles.Tensors.CPU;

package Mlengine is

    package ST renames Orka.Numerics.Singles.Tensors;
    package ST_CPU renames Orka.Numerics.Singles.Tensors.CPU;

    -- CPU_Tensor is an unconstrained private type, so Ada requires an
    -- access value to store tensors of arbitrary runtime shape in a record.
    type CPU_Tensor_Access is access all ST_CPU.CPU_Tensor;

    type Tensor is record
        Data : CPU_Tensor_Access;
        Grad : CPU_Tensor_Access;
    end record;

    type Tensor_Access is access all Tensor;

    procedure Free_CPU_Tensor (Object : in out CPU_Tensor_Access);
    procedure Free_Tensor (Object : in out Tensor);

    type Elements_Access is access all ST.Element_Array;

    subtype ET is ST.Element;

    subtype F32 is Orka.Float_32;
end Mlengine;
