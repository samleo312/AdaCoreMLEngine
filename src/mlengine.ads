with Orka.Numerics.Singles.Tensors;
with Orka.Numerics.Singles.Tensors.CPU;

package Mlengine is

    package ST renames Orka.Numerics.Singles.Tensors;
    package ST_CPU renames Orka.Numerics.Singles.Tensors.CPU;

    Values : constant ST.Element_Array := (1.0, 2.0, 3.0, 4.0, 5.0);
    Tensor : constant ST_CPU.CPU_Tensor := ST_CPU.To_Tensor (Values);

end Mlengine;
