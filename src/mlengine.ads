with Orka.Numerics.Singles.Tensors;
with Orka.Numerics.Singles.Tensors.CPU;

package Mlengine is

    package ST renames Orka.Numerics.Singles.Tensors;
    package ST_CPU renames Orka.Numerics.Singles.Tensors.CPU;

    type Tensor_Access is access ST_CPU.CPU_Tensor; 

    type Tensor is record
        Data : Tensor_Access;
        Grad : Tensor_Access;
    end record;

    Values : constant ST.Element_Array := (1.0, 2.0, 3.0, 4.0, 5.0);

end Mlengine;
