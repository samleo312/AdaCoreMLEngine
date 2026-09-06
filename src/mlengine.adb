with Ada.Unchecked_Deallocation;

package body Mlengine is

    procedure Deallocate_CPU_Tensor is new Ada.Unchecked_Deallocation
      (ST_CPU.CPU_Tensor, CPU_Tensor_Access);

    procedure Free_CPU_Tensor (Object : in out CPU_Tensor_Access) is
    begin
        if Object /= null then
            Deallocate_CPU_Tensor (Object);
        end if;
    end Free_CPU_Tensor;

    procedure Free_Tensor (Object : in out Tensor) is
    begin
        Free_CPU_Tensor (Object.Data);
        Free_CPU_Tensor (Object.Grad);
    end Free_Tensor;

end Mlengine;
