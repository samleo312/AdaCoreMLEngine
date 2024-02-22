with Ada.Text_IO; use Ada.Text_IO;
with Orka; use Orka;

package body Mlengine.Operators is

    function Image (D : in Data_Maps.Map) return String is
        NL : String := ASCII.CR & ASCII.LF;
        function Image (K : Linear_Key) return String is
            S : String := (if D.Contains (K) then K'Image & " :" & NL & D (K).Image else "");
        begin
            return (if K = Linear_Key'Last then S else S & NL & Image (Linear_Key'Succ (K)));
        end;    
    begin
        return Image (Linear_Key'First);
    end;

    function Linear_Key_Hash (K : Linear_Key) return Ada.Containers.Hash_Type is
        (Ada.Containers.Hash_Type(Linear_Key'Enum_Rep(K)));

    function Row_Element_Wise_Add (A : ND_Array; B : ND_Array) return ND_Array 
        with Pre => A.Shape (1) = B.Shape (1) and
                    A.Shape (2) = 1 and
                    B.Shape (2) = 1 is
        A_T : ND_Array := A.Transpose;
        B_T : ND_Array := B.Transpose;
        R   : ND_Array := A_T + B_T;
    begin
        return R.Transpose;
    end;

    function Sum_Row (A : ND_Array) return F32 is
        S : F32 := 0.0;
    begin
        for I in 1 .. A.Shape (2) loop
            S := S + A.Get ((1, I));
        end loop;
        return S;
    end;

    overriding function Forward (L : in out Linear_T) return ND_Array is
        WX  : ND_Array := L.D(W) * L.D(X);
        WXT : ND_Array := WX.Transpose;
        YT  : ND_Array := Zeros (WX.Shape).Transpose;
    begin
        for R in 1 .. WXT.Shape (1) loop
            declare
                Row : ND_Array := WXT.Get (R).Reshape ((1, WXT.Shape (2)));
            begin 
                YT.Set (R, Row_Element_Wise_Add (Row, L.D(B)));
            end;
        end loop;
        return YT.Transpose;
    end;

    overriding function Backward (L : in out Linear_T; dL : ND_Array) return ND_Array is
        d_W : ND_Array := dL * L.D (X).Transpose;
        d_B : ND_Array := Zeros (L.D (B).Shape);
        S : F32;
    begin
        for R in 1 .. dL.Shape (1) loop
            S := Sum_Row (dL.Get (R).Reshape ((1, dL.Shape (2))));
            d_B.Set (R, S);
        end loop;
        L.D.Include (dW, d_W);
        L.D.Include (dB, d_B);
        return dL * L.D (W).Transpose;
    end;

    overriding function Forward (R : in out Rectified_T) return ND_Array is
        A_Arr : ND_Array := Max (0.0, R.D (X));
    begin
        R.D.Include (A, A_Arr);
        return A_Arr;
    end;

    overriding function Backward (R : in out Rectified_T; dL : ND_Array) return ND_Array is
        Res : ND_Array := Zeros (dL.Shape);
    begin
        for I in 1 .. dL.Shape (1) loop
            for J in 1 .. dL.Shape (2) loop
                Res.Set ((I, J), (if R.D (A).Get ((I, J)) > 0.0 
                                    then dL.Get ((I, J)) 
                                    else 0.0));
            end loop;
        end loop;
        return Res;
    end;

    --  overriding function Forward (S : in out Softmax_T) return ND_Array is
    --      E : ND_Array := Exp (S.Input.all - Max (S.Input.all, Axis => 1));
    --      P : ND_Array := E / Sum (E, Axis => 1);
    --  begin
    --      S.Proba.all := P;
    --      return P;
    --  end;

    --  overriding function Backward (S : in out Softmax_T; dL : in ND_Array) return ND_Array is
    --      Dx : ND_Array := Zeros (S.Proba.all.Shape);
    --  begin
    --      for I in 1 .. S.Proba.all.Shape (1) loop
    --          declare
    --              P  : ND_Array := S.Proba.all.Get (I);
    --              Dy : ND_Array := dL.Get (I);
    --              Y  : ND_Array := Diagonal (P);
    --              O  : ND_Array := P * P.Transpose;
    --              dS : ND_Array := Y - O;
    --              R  : ND_Array := dS * Dy;
    --          begin
    --              Dx.Set (I, R);
    --          end;
    --      end loop;
    --      return Dx;
    --  end;

end Mlengine.Operators;