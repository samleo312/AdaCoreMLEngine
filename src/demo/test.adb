with Ada.Text_IO; use Ada.Text_IO;
with Mlengine; use Mlengine;
with Mlengine.Optimizers; use Mlengine.Optimizers;
with Mlengine.Operators; use Mlengine.Operators;
with Mlengine.LossFunctions;
with Mlengine.Utilities; use Mlengine.Utilities;
with Mlengine.spiraldata; use Mlengine.spiraldata;
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;


procedure Main is
    use ST_CPU;
 
    Layer1_Tensor : constant CPU_Tensor := Ones ((10, 100));
    Layer2_Tensor : constant CPU_Tensor := Ones ((100, 3));
    Result : CPU_Tensor := Layer1_Tensor * Layer2_Tensor;
begin
    null;
end Main;