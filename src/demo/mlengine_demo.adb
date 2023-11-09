with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;

with Mlengine.Operators; use Mlengine.Operators;
with MlEngine;

procedure Mlengine_Demo is

    Hidden_Units : Integer := 100;

    package Operators_Vec is new Ada.Containers.Vectors (Index_Type   => Natural, 
                                                         Element_Type => Mlengine.Operators.Func_Access_T);
    Computation_Graph : Operators_Vec.Vector;

    L : aliased Mlengine.Operators.Linear_T := (2, Hidden_Units);
    R : aliased Mlengine.Operators.ReLU_T;

begin
    Computation_Graph.Append (L'Unchecked_Access);
    Computation_Graph.Append (R'Unchecked_Access);

    for E of Computation_Graph loop
        declare
            Tensor : Mlengine.ST_CPU.CPU_Tensor := E.Forward;
        begin
            null;
        end;
    end loop;

end Mlengine_Demo;
