with Mlengine; use Mlengine;
with Mlengine.Operators; use Mlengine.Operators;
with Orka.Numerics.Singles.Tensors.GPU; use Orka.Numerics.Singles.Tensors.GPU;
with Ada.Containers.Vectors;

package Mlengine.Optimizers is

    -- Creation of interfaces for code reuse
    type Opt is interface;
    type Opt_Access is access all Opt'Class;

    package Tensor_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Tensor);

   use Tensor_Vector;


    -- procedure to adjust values of params and velocities for an adjustment towards optimal solution
    ----------------procedure step (paramsGrad: in out Float_Array, paramsData in out Float_Array, velocity: in out Float_Array);
    procedure step (params: in out Opt) is abstract;

    -- procedure to reset parameter Gradients to 0.0
    ---------------procedure zero_grad(paramsGrad: in out Float_Array, Float_ArparamsDataray: in out Float_Array);
    procedure zero_grad(params: in out Opt) is abstract;

    -- define Stochastic Gradient Descent
    -- lr: learning rate of the engine (default = 0.01)
    -- weight_decay:
    -- momentum: float in range [0, 1], fraction of the previous update to add to the current update (default = 0). 
    -- t: tensor of data and associated gradients
    -- velocities: array storing the changes in params, all values begin as 0 (Float_Array)
    type SGD is new Opt with record
        lr, weight_decay, momentum : Float;
        velocities : Tensor_Vector.Vector;
        parameters : Tensor_Vector.Vector;
    end record; 

    procedure InitializeSGD(Optim : in out SGD);
    overriding procedure step (Optim : in out SGD);
    overriding procedure zero_grad (Optim: in out SGD); 

end Mlengine.Optimizers;
