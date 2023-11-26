with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

------------------------------------------------------------------------------------------------------------------------------------------
-- QUESTIONS:
-- In Python example, class 'Function' inherits 'object' not sure if that gives it behavior that will need to be replicated or not.

-- How exactly do private class variables work?
-- It appears as things are defined as being private at the package level, so how can you have more than one class
-- in a package and each of them have their own private variables?
-------------------------------------------------------------------------------------------------------------------------------------------

package body Mlengine.Operators is

   type Func is abstract tagged record
      Dummy_To_Compile : Boolean;
   end record;

   type ParameterList is
     array
       (Positive range <>) of Integer;                                  -- PLACEHOLDER: CHANGE TO ARRAY OF TENSORS WHEN PROPER LIBRARY IS IMPORTED

   function Forward
     (Self : in Func)
      return Integer is abstract;                               -- PLACEHOLDER: CHANGE TO RETURN ARRAY OF TENSORS WHEN PROPER LIBRARY IS IMPORTED
   function Backward
     (Self : in Func)
      return Integer is abstract;                              -- PLACEHOLDER: CHANGE TO RETURN ARRAY OF TENSORS WHEN PROPER LIBRARY IS IMPORTED
   function GetParams
     (Self : in Func)
      return ParameterList is abstract;                        -- PLACEHOLDER: CHANGE TO RETURN ARRAY OF TENSORS WHEN PROPER LIBRARY IS IMPORTED

   type Layer_T is (Linear, Undefined);
   type Linear_func is new Func with record
      weights : Integer;                                                                      -- PLACEHOLDER: CHANGE TO TENSOR WHEN PROPER LIBRARY IS IMPORTED
      bias : Integer;                                                                         -- PLACEHOLDER: CHANGE TO TENSOR WHEN PROPER LIBRARY IS IMPORTED
      layer   : Layer_T := Linear;
      input : Integer;                                                                        -- PLACEHOLDER: CHANGE TO TENSOR WHEN PROPER LIBRARY IS IMPORTED
   end record;

   procedure Forward (Self : in Linear_func; Output : out Integer) is                           -- PLACEHOLDER: CHANGE 'Output' TO TENSOR WHEN PROPER LIBRARY IS IMPORTED
   begin
      null;
   end Forward;

   procedure Backward (Self : in Linear_func; GradInput : out Integer)
   is                              -- PLACEHOLDER: CHANGE 'GradInput' TO TENSOR WHEN PROPER LIBRARY IS IMPORTED
   begin
      null;
   end Backward;

   procedure GetParams (Self : in Linear_func; ParameterList : out Integer)
   is                          -- PLACEHOLDER: CHANGE 'ParameterList' TO ARRAY OF TENSORS WHEN PROPER LIBRARY IS IMPORTED
   begin
      null;
   end GetParams;

end Mlengine.Operators;
