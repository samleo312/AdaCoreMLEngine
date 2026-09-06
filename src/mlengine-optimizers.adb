with Orka.Numerics.Singles.Tensors;
with Orka; use Orka;

package body Mlengine.Optimizers is

    procedure InitializeSGD(Optim : in out SGD) is
        Velocity : Tensor;
    begin
        FreeSGD (Optim);

        if not Optim.Parameters.all.Is_Empty then
            for I in Optim.Parameters.all.First_Index .. Optim.Parameters.all.Last_Index loop
               Velocity.Data := new ST_CPU.CPU_Tensor'
                  (Zeros ((Optim.Parameters.all (I).all.Grad.Shape (1), Optim.Parameters.all (I).all.Grad.Shape (2))));
               Velocity.Grad := null;
               Optim.Velocities.Append (Velocity);
            end loop;
        end if;

    end InitializeSGD;

    procedure FreeSGD (Optim : in out SGD) is
    begin
        for I of Optim.Velocities loop
            Free_Tensor (I);
        end loop;
        Optim.Velocities.Clear;
    end FreeSGD;

    overriding procedure Step (Optim : in out SGD) is
    begin
        if not Optim.Parameters.all.Is_Empty then
            for I in Optim.Parameters.all.First_Index ..
                     Optim.Parameters.all.Last_Index loop
                Optim.Velocities (I).Data.all :=
                   ST_CPU.Add
                     (ST_CPU.Add
                        (ST_CPU."*"
                           (Orka.Numerics.Singles.Tensors.Element (Optim.Momentum),
                            Optim.Velocities (I).Data.all),
                         Optim.Parameters.all (I).all.Grad.all),
                      ST_CPU."*"
                        (Orka.Numerics.Singles.Tensors.Element (Optim.Weight_Decay),
                         Optim.Parameters.all (I).all.Data.all));

                Optim.Parameters.all (I).all.Data.all :=
                   ST_CPU.Subtract
                     (Optim.Parameters.all (I).all.Data.all,
                      ST_CPU."*"
                        (Orka.Numerics.Singles.Tensors.Element (Optim.Lr),
                         Optim.Velocities (I).Data.all));
            end loop;
        end if;
    end Step;

    overriding procedure Zero_Grad (Optim : in out SGD) is
    begin
        if not Optim.Parameters.all.Is_Empty then
            for I of Optim.Parameters.all loop
                if I /= null then
                    I.all.Grad.all := Zeros (I.all.Grad.Shape);
                end if;
            end loop;
        end if;
    end Zero_Grad;

end Mlengine.Optimizers;
