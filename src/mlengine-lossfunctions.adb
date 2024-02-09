with Orka; use Orka;

package body Mlengine.LossFunctions is

    function Soft_Max (Z : Tensor) return Tensor is

        function Find_Maximums return Tensor is
            Max     : F32                                 := 0.0;
            Element : F32                                 := 0.0;
            Maxs    : OT.Element_Array (1 .. Z.Shape (1)) := [others => 0.0];
        begin
            for I in 1 .. (Z.Shape (1)) loop
                for J in 1 .. (Z.Shape (2)) loop
                    Element := Z.Get ([I, J]);
                    Max     := (if Element > Max then Element else Max);
                end loop;
                Maxs (I) := Max;
                Max      := 0.0;
            end loop;
            return OTI.To_Tensor (Maxs);
        end Find_Maximums;

        Maximums : constant Tensor := Find_Maximums;
        Res_Z    : Tensor          := Zeros (Z.Shape);
    begin
        for R in 1 .. Z.Rows loop
            declare
                Max_Scalar : constant F32    := Maximums.Get (R);
                Diff       : constant Tensor := Z (R) - Max_Scalar;
                Exp        : constant Tensor := Diff.Exp;
                Sum_Scalar : constant F32    := Exp.Sum;
                Prob       : constant Tensor := Exp / Sum_Scalar;
            begin
                Res_Z.Set (R, Prob);
            end;
        end loop;
        return Res_Z;
    end Soft_Max;

    function Cross_Entropy_Loss (Z : Tensor; Target : Target_Indices) return F32 is

        function Sample_From_Target return Tensor is
            Samples : OT.Element_Array (Target'Range) := [others => 0.0];
        begin
            for I in Target'Range loop
                declare
                    Col   : constant Integer         := Target (I);
                    T_Idx : constant OT.Tensor_Index := [I, Col];
                    Value : constant F32             := Z.Get (T_Idx);
                begin
                    Samples (I) := Value;
                end;
            end loop;
            return OTI.To_Tensor (Samples);
        end Sample_From_Target;

        Neg_Log : constant Tensor := -(Sample_From_Target.Log);
    begin
        return Neg_Log.Mean;
    end Cross_Entropy_Loss;

    function Soft_Max_Loss (Z : Tensor; Target : Target_Indices) return F32 is
       (Cross_Entropy_Loss (Soft_Max (Z), Target));

end Mlengine.LossFunctions;