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
     Type_ : Unbounded_String := "activation";
     Inplace : Boolean;
     Activated : Float_Array;
    end record;


    --constructor of ReLU
   function init_ReLU return ReLU
    is
    begin
        return (Type_ => "activation", Inplace => True, Activated => null);
    end init_ReLU;


    --forward function, takes in "self" params, call as Layer.Inplace? or can pass in Layer.Inplace?
    --x is the input array
    --do we even need activated??
    --which are in/in out/out
    function Forward (Layer: in out ReLU; X : Float_Array; Inplace : Boolean; Activated : Float_Array)
    is
    begin
    --if inplace: change input array directly, set all vals less than 0 to 0
    --if inplace is true
        for I of X loop
            if I < 0.0 then
                I := 0.0; --http://www.ada-auth.org/standards/12rat/html/Rat12-6-3.html
            end if;
        end loop;
        --updated array to become Layers's activation array
        Layer.Activated := X;

    
    --if not in place: create new array where negative values are again set to 0
    --else
   --end if;

    --########################################################################################################
   --i decided that we dont need in place right now, maybe later for optimization, not necessary to engine behaviour
   --##########################################################################################################

    --in out so no return
   --return Layer.Activated;
   end Forward;


   function Backward (Layer:ReLU; D_Y : in Float_Array)
   is
   begin
    --array multiplication
   end Backward;

end Mlengine.Operators;
