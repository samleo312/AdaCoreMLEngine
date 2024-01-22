with Mlengine;

package Mlengine.Optimizers is
    
    -- Index used to establish tensor dimensions
    type Index is range 1 .. 2;
    type parameters is array(Index) of Tensor;

    -- procedure to adjust values of parameters and velocities for an adjustment towards optimal solution
    ----------------procedure step (parametersGrad: in out Float_Array, parametersData in out Float_Array, velocity: in out Float_Array);
    procedure step (parameters: in out Tensor; velocity: in out Float_Array);

    -- procedure to reset parameter Gradients to 0.0
    ---------------procedure zero_grad(parametersGrad: in out Float_Array, Float_ArparametersDataray: in out Float_Array);
    procedure zero_grad(parameters: in out Tensor);

    -- define Stochastic Gradient Descent
    -- lr: learning rate of the engine (default = 0.01)
    -- weight_decay:
    -- momentum: float in range [0, 1], fraction of the previous update to add to the current update (default = 0). 
    -- parameters: tensor of data and associated gradients
    -- velocity: array storing the changes in parameters, all values begin as 0 (Float_Array)
    type SGD is tagged record
        lr, weight_decay, momentum : Float;
        parameters: Tensor;
        velocity : Float_Array;
    end record;  

end Mlengine.Optimizers;
