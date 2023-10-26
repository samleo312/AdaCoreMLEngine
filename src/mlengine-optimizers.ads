package Mlengine.Optimizers is
    
    -- is constructor required? if so, only parameter required is "parameters"

    -- procedure with no parameters, unique to each specific optimizer
    procedure step ( )

    -- procedure to reset parameters, has no parameters
    procedure zeroGrad( )

end Mlengine.Optimizers;