with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

package body Mlengine.Operators is

    type Func is abstract tagged record
    end record;

    type Index is range 1 .. 10;
    type ParameterList is array(Index) of Unbounded_String;
    
    function Forward (Self : in Func) return Grad_Tensor is abstract;                               
    function Backward (Self : in Func) return Grad_Tensor is abstract;                             
    function GetParams (Self: in Func) return ParameterList is abstract;                        

    type Linear is new Func with record
        weights : Grad_Tensor;                                                                      
        bias : Grad_Tensor;                                                                         
        layerType : Unbounded_String := "linear";   
        input : Grad_Tensor;                                                               
    end record;

    function Forward (Self: in Linear; X : in Grad_Tensor; Output: out Grad_Tensor) is                                 
    begin
        Output.Tensor := (Self.weights.Tensor * X.Tensor) + Self.bias.Tensor;
        Self.input := X; 
        return Output;
    end;

    function Backward (Self: in out Linear; dY: out Grad_Tensor) is    
    GradInput : Grad_Tensor;                           
    begin
        Self.weights.Gradient := Self.weights.Gradient + (Self.input.Tensor.Transpose * dY.Tensor);
        Self.bias.Gradient := Self.bias.Gradient + 0; -- NOT FINISHED, 0 IS PLACEHOLDER
        GradInput.Tensor := Self.weights.Tensor.Transpose * dY.Tensor;

        return GradInput;
    end;
    
    function GetParams(Self: in Linear; ParameterList: out ParameterList) is                          
    begin
        NULL;
    end;







    type ReLU is record
       Type_ : Unbounded_String := To_Unbounded_String("activation");
       Inplace : Boolean := True;
       Activated : Float_Array := (others => 0.0);
    end record;



    function Forward(Layer: in out ReLU; X: in out Float_Array) return Float_Array is
   Activated : Float_Array;
begin
   Activated := X;
   for I in X'Range loop
      if X(I) < 0.0 then
         Activated(I) := 0.0;
      end if;
   end loop;
   Layer.Activated := Activated;
   return Activated;
end Forward;


   function Backward(Layer: in out ReLU; D_Y: in Float_Array) return Float_Array is
   gradient_input: Float_Array := (others => 0.0);
begin
   for I in D_Y'Range loop
      if Layer.Activated(I) > 0.0 then
         gradient_input(I) := D_Y(I);
      end if;
   end loop;
   return gradient_input;
end Backward;
