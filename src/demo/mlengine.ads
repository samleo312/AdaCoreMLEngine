with Orka.Numerics.Tensors;

package Mlengine is
    package Numeric_Tensors is new Orka.Numerics.Tensors (Float);
    subtype Float_Array is Numeric_Tensors.Element_Array;
end Mlengine;
