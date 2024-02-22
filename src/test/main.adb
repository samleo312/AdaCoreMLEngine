with Mlengine; use Mlengine;
with Mlengine.Operators; use Mlengine.Operators;
with Orka; use Orka;

with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
    W_Arr  : aliased ND_Array := OTI.To_Tensor ((2.0, 0.5, 1.0, 
                                             1.5, 1.0, 2.0)).Reshape ((2, 3));
    X_Arr  : aliased ND_Array := OTI.To_Tensor ((-10.0, 3.0, 5.0, 7.0, 
                                             2.0, 4.0, 6.0, 8.0,
                                             3.0, 5.0, 7.0, 9.0)).Reshape ((3, 4));
    B_Arr  : aliased ND_Array := OTI.To_Tensor ((0.5, 
                                            -0.5)).Reshape ((2, 1));

    dL_Arr : aliased ND_Array := OTI.To_Tensor ((1.0, 1.0, 1.0, 1.0, 
                                             1.0, 1.0, 1.0, 1.0)).Reshape ((2, 4));
    
    dB_Arr : aliased ND_Array := OTI.To_Tensor ((0.0, 1.0, 2.0, 3.0, 4.0, 5.0)).Reshape ((1, 5));

    L : Linear_T;
    R : Rectified_T;
begin
    L.D.Include (W, W_Arr);
    L.D.Include (X, X_Arr);
    L.D.Include (B, B_Arr);
    F1 : ND_Array := Forward (L);

    R.D.Include (X, F1);
    F2 : ND_Array := Forward (R);
    B : ND_Array := Backward (R, dL_Arr);

    Put_Line (F1.Image);
    Put_Line (F2.Image);
    Put_Line (B.Image);
    Put_Line (Image (R.D));
end Main;