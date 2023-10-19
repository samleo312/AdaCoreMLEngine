with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

------------------------------------------------------------------------------------------------------------------------------------------
    -- QUESTIONS:
    -- In Python example, class 'Function' inherits 'object' not sure if that gives it behavior that will need to be replicated or not.

    -- How exactly do private class variables work? 
    -- It appears as things are defined as being private at the package level, so how can you have more than one class
    -- in a package and each of them have their own private variables?
-------------------------------------------------------------------------------------------------------------------------------------------

package body Mlengine.Operators is

    type Func is abstract tagged record
    end record;

    function Forward (Self : in Func) return Integer is abstract;                               -- PLACEHOLDER: CHANGE TO RETURN ARRAY OF TENSORS WHEN PROPER LIBRARY IS IMPORTED
    function Backward (Self : in Func) return Integer is abstract;                              -- PLACEHOLDER: CHANGE TO RETURN ARRAY OF TENSORS WHEN PROPER LIBRARY IS IMPORTED
    function GetParams (Self: in Func) return parameterList is abstract;                        -- PLACEHOLDER: CHANGE TO RETURN ARRAY OF TENSORS WHEN PROPER LIBRARY IS IMPORTED
    
    
    
    type Linear is new Func with record
        weights : Integer;                                                                      -- PLACEHOLDER: CHANGE TO TENSOR WHEN PROPER LIBRARY IS IMPORTED
        bias : Integer;                                                                         -- PLACEHOLDER: CHANGE TO TENSOR WHEN PROPER LIBRARY IS IMPORTED
        layerType : Unbounded_String := "linear";
        input : Integer;                                                                        -- PLACEHOLDER: CHANGE TO TENSOR WHEN PROPER LIBRARY IS IMPORTED
    end record;

   
    overriding
    function Forward (Self: in Linear; Output: out Integer) is                                  -- PLACEHOLDER: CHANGE 'Output' TO TENSOR WHEN PROPER LIBRARY IS IMPORTED
    begin
        NULL; 
    end;

    overriding
    function Backward (Self: in Linear; GradInput: out Integer) is                              -- PLACEHOLDER: CHANGE 'GradInput' TO TENSOR WHEN PROPER LIBRARY IS IMPORTED
    begin
        NULL; 
    end;
    
    overriding
    function GetParams(Self: in Linear; ParameterList: out Integer) is                          -- PLACEHOLDER: CHANGE 'ParameterList' TO ARRAY OF TENSORS WHEN PROPER LIBRARY IS IMPORTED
    begin
        NULL;
    end;


end Mlengine.Operators;