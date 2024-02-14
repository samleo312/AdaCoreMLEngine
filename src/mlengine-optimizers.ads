with Mlengine; use Mlengine;
with Mlengine.Operators; use Mlengine.Operators;
with Ada.Containers.Vectors;

package Mlengine.Optimizers is

    package ST_CPU renames Orka.Numerics.Singles.Tensors.CPU;
    use ST_CPU;

    type Opt is interface;
    type Opt_Access is access all Opt'Class;

    package Parameter_Groups is new Ada.Containers.Vectors
      (Index_Type   => Positive,
       Element_Type => ParamsArray);

    use Parameter_Groups;

    type Parameter_Groups_Access is access Parameter_Groups.Vector;

    procedure Step(Params: in out Opt) is abstract;
    procedure Zero_Grad(Params: in out Opt) is abstract;

    --function Get_Data(Params: in out Opt) return ST_CPU.CPU_Tensor is abstract;
    --function Get_Grad(Params: in out Opt) return ST_CPU.CPU_Tensor is abstract;

    type SGD is new Opt with record
        Lr, Weight_Decay, Momentum: Float;
        Parameters: Parameter_Groups_Access;
        Velocities: Parameter_Groups_Access;
    end record;

    overriding procedure Step(Params: in out SGD);
    overriding procedure Zero_Grad(Params: in out SGD);
    --overriding function Get_Data(Params: in out SGD) return ST_CPU.CPU_Tensor;
    --overriding function Get_Grad(Params: in out SGD) return ST_CPU.CPU_Tensor;

    --  -- Creation of interfaces for code reuse
    --  type Opt is interface;
    --  type Opt_Access is access all Opt'Class;

    --  -- procedure to adjust values of params and velocities for an adjustment towards optimal solution
    --  ----------------procedure step (paramsGrad: in out Float_Array, paramsData in out Float_Array, velocity: in out Float_Array);
    --  procedure step (params: in out Opt) is abstract;

    --  -- procedure to reset parameter Gradients to 0.0
    --  ---------------procedure zero_grad(paramsGrad: in out Float_Array, Float_ArparamsDataray: in out Float_Array);
    --  procedure zero_grad(params: in out Opt) is abstract;

    --  -- getters for tensor values
    --  function get_data(params: in out Opt) return ST_CPU.CPU_Tensor is abstract;
    --  function get_grad(params: in out Opt) return ST_CPU.CPU_Tensor is abstract;

    --  -- define Stochastic Gradient Descent
    --  -- lr: learning rate of the engine (default = 0.01)
    --  -- weight_decay:
    --  -- momentum: float in range [0, 1], fraction of the previous update to add to the current update (default = 0). 
    --  -- t: tensor of data and associated gradients
    --  -- velocities: array storing the changes in params, all values begin as 0 (Float_Array)
    --  type SGD is new Opt with record
    --      lr, weight_decay, momentum : Float;
    --      t : Tensor;
    --      velocities : Elements_Access;
    --  end record; 

    --  overriding procedure step (params : in out SGD);
    --  overriding procedure zero_grad (params: in out SGD); 
    --  overriding function get_data(params: in out SGD) return ST_CPU.CPU_Tensor;
    --  overriding function get_grad(params: in out SGD) return ST_CPU.CPU_Tensor;

end Mlengine.Optimizers;
