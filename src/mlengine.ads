with Ada.Finalization;
with Orka;
with Orka.Numerics.Singles.Tensors;
with Orka.Numerics.Singles.Tensors.CPU;

package Mlengine is

    package ST renames Orka.Numerics.Singles.Tensors;
    package ST_CPU renames Orka.Numerics.Singles.Tensors.CPU;

    -- CPU_Tensor is an unconstrained private type, so Ada requires an
    -- access value to store tensors of arbitrary runtime shape in a record.
    type CPU_Tensor_Access is access all ST_CPU.CPU_Tensor;

    -- Tensor owns its two pointers. Copies receive independent allocations.
    type Tensor is new Ada.Finalization.Controlled with private;

    function Data (Object : Tensor) return CPU_Tensor_Access;
    function Grad (Object : Tensor) return CPU_Tensor_Access;

    function Create_Tensor (Shape : ST.Tensor_Shape; With_Grad : Boolean := True) return Tensor;
    function Create_Tensor (Value : ST_CPU.CPU_Tensor; With_Grad : Boolean := True) return Tensor;

    procedure Set_Data (Object : in out Tensor; Value : ST_CPU.CPU_Tensor);
    procedure Set_Grad (Object : in out Tensor; Value : ST_CPU.CPU_Tensor);

    type Tensor_Access is access all Tensor;

    type Elements_Access is access all ST.Element_Array;

    subtype ET is ST.Element;

    subtype F32 is Orka.Float_32;
    
private
    type Tensor is new Ada.Finalization.Controlled with record
        Data : CPU_Tensor_Access := null;
        Grad : CPU_Tensor_Access := null;
    end record;
    overriding procedure Adjust (Object : in out Tensor);
    overriding procedure Finalize (Object : in out Tensor);
end Mlengine;
