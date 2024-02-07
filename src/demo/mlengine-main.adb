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
X_Target : Target_Array := (1, 3, 3, 2, 1, 2, 3, 3, 2, 2, 3, 2, 1, 1, 2, 3, 2, 3, 1, 2);
E : aliased Mlengine.LossFunctions.SoftLossMax_T := (Proba, Target);
 
begin
    X.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor (          (2.71177099, 3.11687473, -5.89971407, -0.87466922, -3.9512139, 4.77711541, -3.5347833, 0.16200897, 3.31276371, -7.64252927, 5.56109235, 1.98503507, 3.65512365, 1.10249348, -4.79523851, -6.13127804, 4.47953644, 1.57189616, -0.76463076, -4.18947765, 4.90467281, 1.74722258, -5.82359028, 4.02702799, -6.11230341, 4.8847165, 1.14003711, -7.59722608, 4.83939614, 2.63926706, 1.91036662, -5.67953439, 3.71832932, -0.30490472, 1.94281725, -1.67547115, -1.05855491, -0.42666605, 1.44974343, 4.55495162, 2.10680767, -6.70982412, -1.14406615, 0.15799687, 0.94951404, 1.12446581, -6.26501505, 5.0978815, -3.66827415, 3.34621609, 0.25903371, -3.27215393, -0.1624845, 3.37794116, 2.44174734, -1.15686176, -1.3226696, -8.16869057, 6.32266961, 1.73834261


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