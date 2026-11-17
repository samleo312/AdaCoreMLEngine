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

    function Data (Object : Tensor) return CPU_Tensor_Access is (Object.Data);
    function Grad (Object : Tensor) return CPU_Tensor_Access is (Object.Grad);

    procedure Free_Tensor (Object : in out Tensor) is
    begin
        Free_CPU_Tensor (Object.Data);
        Free_CPU_Tensor (Object.Grad);
    end Free_Tensor;

    -- CPU_Tensor objects are constrained when allocated. Reuse them only
    -- when the shape and element kind agree; otherwise replace the object.
    procedure Replace (Target : in out CPU_Tensor_Access;
                       Value  : ST_CPU.CPU_Tensor) is
        use type ST.Tensor_Shape;
        use type ST.Data_Type;
    begin
        if Target /= null
          and then Target.Shape = Value.Shape
          and then Target.Kind = Value.Kind
        then
            Target.all := Value;
        else
            declare
                New_Value : constant CPU_Tensor_Access :=
                  new ST_CPU.CPU_Tensor'(Value);
            begin
                Free_CPU_Tensor (Target);
                Target := New_Value;
            end;
        end if;
    end Replace;

    procedure Set_Data (Object : in out Tensor; Value : ST_CPU.CPU_Tensor) is
    begin
        Replace (Object.Data, Value);
    end Set_Data;

    procedure Set_Grad (Object : in out Tensor; Value : ST_CPU.CPU_Tensor) is
    begin
        Replace (Object.Grad, Value);
    end Set_Grad;

    function Create_Tensor (Value : ST_CPU.CPU_Tensor; With_Grad : Boolean := True) return Tensor is
    begin
        return Result : Tensor do
            Set_Data (Result, Value);
            if With_Grad then
                Set_Grad (Result, ST_CPU.Zeros (Value.Shape));
            end if;
        end return;
    end Create_Tensor;

    function Create_Tensor (Shape : ST.Tensor_Shape; With_Grad : Boolean := True) return Tensor is
    begin
        return Create_Tensor (ST_CPU.Zeros (Shape), With_Grad);
    end Create_Tensor;
   

   -- For A and B both being Tensors, makes A := B work as a deep copy.
    overriding procedure Adjust (Object : in out Tensor) is
        Original_Data : constant CPU_Tensor_Access := Object.Data;
        Original_Grad : constant CPU_Tensor_Access := Object.Grad;
    begin
        -- The incoming pointers still belong to the source of the assignment.
        Object.Data := null;
        Object.Grad := null;
        if Original_Data /= null then Set_Data (Object, Original_Data.all); end if;
        if Original_Grad /= null then Set_Grad (Object, Original_Grad.all); end if;
    end Adjust;

    overriding procedure Finalize (Object : in out Tensor) is
    begin
        Free_Tensor (Object);
    end Finalize;

end Mlengine;
