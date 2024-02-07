with Ada.Text_IO; use Ada.Text_IO;
--with Mlengine.Operators;
--with Mlengine.Utilities; use Mlengine.Utilities;
with Mlengine.LossFunctions; use Mlengine.LossFunctions;
with AUnit.Reporter.Text;
with AUnit.Run;
with Linear_Suite; 
with Orka; use Orka;

procedure Mlengine.Main is
Proba : Tensor;
Target : Target_Array;
X: Tensor; --input
X_Target : Target_Array := (2, 1, 1, 2, 1, 2, 1, 2, 1, 1, 3, 2, 3, 3, 2, 3, 2, 3, 2, 1);
E : aliased Mlengine.LossFunctions.SoftLossMax_T := (Proba, Target);
 
begin
    X.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor (          (-1.3429215, 2.60741598, -1.25422714,
6.92128091, 0.8689323, -7.77600848,
4.19614071, -0.16305666, -4.00155421,
-10.78560954, 8.02857906, 2.77058546,
10.17337825, 0.25248649, -10.39851216,
-11.2094008, 9.09423599, 2.12916829,
0.15738992, -0.71810274, 0.56935424,
-6.73330629, 4.67358472, 2.07214986,
0.03850776, -0.560843, 0.53102337,
9.71094752, 1.09953912, -10.78860958,
-1.72452926, -2.00757624, 3.74140138,
-0.32300156, 1.87554877, -1.54340701,
-0.81935835, -0.42584407, 1.2541009,
-0.38326601, -0.50943449, 0.90149015,
0.03850776, -0.560843, 0.53102337,
-1.98465966, -1.81937799, 3.81307706,
-9.52709779, 7.48178716, 2.05959972,
1.75415417, -8.77756193, 7.0307134,
-9.87122107, 8.43176931, 1.45570032,
6.75397331, 0.81682416, -7.55694321


                                                                   ), (20,3)));
    E.Proba.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor (      (0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0,
                                                                  0.0, 0.0, 0.0
                                                                   ), (20,3)));
    Proba.Grad := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor ((0.0, 0.0), (1,2)));
    Put_Line ("Running Mlengine.Main");
    
    declare
    Fwd : Orka.Float_32;
    begin
        Fwd := Forward(E, X.Data.All, X_Target);
    end;

    
end Mlengine.Main;