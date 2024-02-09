with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.LossFunctions; use Mlengine.LossFunctions;
with Orka; use Orka;

procedure Mlengine.Soft_Max_Loss_Main is

Z : Mlengine.LossFunctions.Tensor := OTI.To_Tensor((-2.31201568e-04, 9.00777751e-05, -3.28564784e-06,
                                                     0.00000000e+00, 0.00000000e+00,  0.00000000e+00,
                                                     6.51428084e-05, 2.69729548e-04, -1.42815140e-05,
                                                     9.18576061e-05, 1.06123480e-04,  1.41928869e-05), (4,3));
Target : Mlengine.LossFunctions.Target_Indices := (2, 3, 3, 1);
Mean : Mlengine.LossFunctions.F32 := Soft_Max_Loss (Z, Target);
begin
    Put_Line (Mean'Image);
end Mlengine.Soft_Max_Loss_Main;