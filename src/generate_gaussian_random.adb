with Ada.Numerics.Float_Random;         use Ada.Numerics.Float_Random;
with Ada.Text_IO;                       use Ada.Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

function Generate_Gaussian_Random return Float is
    package Rand_IO is new Ada.Text_IO.Float_IO (Num => Float);

    -- Random number generator
    Gen    : Generator;
    U1, U2 : Float;
    Z0     : Float; -- The Gaussian random numbers

    -- Initialize the random number generator
    procedure Reset_Generator is
    begin
        Reset (Gen);
    end Reset_Generator;

    -- Generate Gaussian random number using Box-Muller transform
    procedure Generate is
    begin
        U1 := Random (Gen);
        U2 := Random (Gen);

        Z0 := Sqrt (-2.0 * Log (U1)) * Cos (2.0 * ada.Numerics.Pi * U2);
    end Generate;

begin
    -- Initialize the generator
    Reset_Generator;

    -- Generate Gaussian random number
    Generate;
    return Z0;
end Generate_Gaussian_Random;