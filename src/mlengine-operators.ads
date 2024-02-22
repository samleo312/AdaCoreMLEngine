with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Strings.Hash;

package Mlengine.Operators is

    type Linear_Key is (X, W, B, dW, dB, A);
    function Linear_Key_Hash (K: Linear_Key) return Ada.Containers.Hash_Type;
    package Data_Maps is new
     Ada.Containers.Indefinite_Hashed_Maps
       (Key_Type        => Linear_Key,
        Element_Type    => ND_Array,
        Hash            => Linear_Key_Hash,
        Equivalent_Keys => "=");
    use Data_Maps;
    function Image (D : in Data_Maps.Map) return String;

    type Operator_T is interface;
    function Forward (O : in out Operator_T) return ND_Array is abstract;
    function Backward (O : in out Operator_T; dL : ND_Array) return ND_Array is abstract;

    type Linear_T is new Operator_T with record
        D : Data_Maps.Map;
    end record;
    overriding function Forward (L : in out Linear_T) return ND_Array
        with Pre => L.D(W).Shape (2) = L.D(X).Shape (1) and
                    L.D(B).Shape (1) = L.D(W).Shape (1);
    overriding function Backward (L : in out Linear_T; dL : in ND_Array) return ND_Array;

    type Rectified_T is new Operator_T with record
        D : Data_Maps.Map;
    end record;
    overriding function Forward (R : in out Rectified_T) return ND_Array;
    overriding function Backward (R : in out Rectified_T; dL : in ND_Array) return ND_Array;

    --  type Softmax_T is new Operator_T with record
    --      D : Data_Maps.Map;
    --  end record;
    --  overriding function Forward (S : in out Softmax_T) return ND_Array;
    --  overriding function Backward (S : in out Softmax_T; dL : in ND_Array) return ND_Array;

end Mlengine.Operators;