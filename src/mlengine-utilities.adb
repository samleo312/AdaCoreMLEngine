with Ada.Text_IO; use Ada.Text_IO;
with Mlengine.Operators;
with AUnit.Reporter.Text;
with AUnit.Run;
with Linear_Suite; 
with Orka; use Orka;

package body Mlengine.Utilities is
    procedure Add(M : in out Model; Layer: Func_Access_T) is
    begin
        M.Graph.Append(Layer);
    end;

    function Fit(M: in out Model; Data : Tensor; Target : Tensor; Batch_Size : Integer; Num_Epochs : Integer; Optimizer : SGD ; Loss_Fn : SoftmaxWithLoss) is
    begin
    end;

    function Predict(M : in out Model; Data : Tensor) is
        X : Tensor := Data;
    begin
        
    end;
end Mlengine.Utilities;
