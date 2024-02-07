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
X_Target : Target_Array;
E : aliased Mlengine.LossFunctions.SoftLossMax_T := (Proba, Target);
 
begin
    X.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor (          (0.0, 0.0, 0.0,
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
    Proba.Data := new ST_CPU.CPU_Tensor'(ST_CPU.To_Tensor (      (0.0, 0.0, 0.0,
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