with Ada.Text_IO; use Ada.Text_IO;
with Orka; use Orka;
with Mlengine; use Mlengine;
with Mlengine.Optimizers; use Mlengine.Optimizers;
with Mlengine.Operators; use Mlengine.Operators;
with Mlengine.LossFunctions;
with Mlengine.Utilities; use Mlengine.Utilities;
with Mlengine.spiraldata; use Mlengine.spiraldata;
with Orka.Numerics.Singles.Tensors.CPU; use Orka.Numerics.Singles.Tensors.CPU;

procedure Mlengine.Main is
    Batch_Size        : constant Integer := 10;
    Num_Epochs        : constant Integer := 100;
    Samples_Per_Class : constant Integer := 100;
    Num_Classes       : constant Integer := 3;
    Hidden_Units      : constant Integer := 1000;
    Grid_Size         : constant Positive := 121;

    Data       : Tensor;
    M          : aliased Model;
    Optim      : SGD;
    Target     : Mlengine.LossFunctions.Target_Array
                   (1 .. Num_Classes * Samples_Per_Class);
    Loss_Fn : aliased Mlengine.LossFunctions.SoftLossMax_T (Batch_Size);
    Predicted_Labels : Tensor;
    Accuracy : Float;

    Layer1 : aliased Linear_T := Create_Linear (2, Hidden_Units);
    ReLU_Object : aliased ReLU_T;
    Layer2 : aliased Linear_T := Create_Linear (Hidden_Units, Num_Classes);

    function Best_Class (Scores : CPU_Tensor; Row : Positive) return Positive is
       Best : Positive := 1;
    begin
       for J in 2 .. Num_Classes loop
          if Float_32'(Scores.Get (ST.Tensor_Index'(Row, J))) >
            Float_32'(Scores.Get (ST.Tensor_Index'(Row, Best)))
          then
             Best := J;
          end if;
       end loop;
       return Best;
    end Best_Class;

    procedure Export_Plot_Data is
       Samples_File, Grid_File : File_Type;
       Grid : Tensor := Create_Tensor
         (ST.Tensor_Shape'(Grid_Size, 2), With_Grad => False);
    begin
       Create (Samples_File, Out_File, "spiral_samples.csv");
       Put_Line (Samples_File, "x,y,label,prediction");
       for I in Target'Range loop
          Put_Line (Samples_File,
            Float_32'Image (Data.Data.all.Get (ST.Tensor_Index'(I, 1))) & "," &
            Float_32'Image (Data.Data.all.Get (ST.Tensor_Index'(I, 2))) & "," &
            Integer'Image (Target (I)) & "," &
            Integer'Image (Best_Class (Predicted_Labels.Data.all, I)));
       end loop;
       Close (Samples_File);

       Create (Grid_File, Out_File, "spiral_grid.csv");
       Put_Line (Grid_File, "x,y,prediction");
       for Row in 1 .. Grid_Size loop
          declare
             Y : constant Float_32 :=
               -1.2 + 2.4 * Float_32 (Row - 1) / Float_32 (Grid_Size - 1);
          begin
             for Col in 1 .. Grid_Size loop
                Grid.Data.Set (ST.Tensor_Index'(Col, 1),
                  -1.2 + 2.4 * Float_32 (Col - 1) / Float_32 (Grid_Size - 1));
                Grid.Data.Set (ST.Tensor_Index'(Col, 2), Y);
             end loop;
             declare
                Scores : constant CPU_Tensor := Predict (M, Grid);
             begin
                for Col in 1 .. Grid_Size loop
                   Put_Line (Grid_File,
                     Float_32'Image (Grid.Data.all.Get (ST.Tensor_Index'(Col, 1))) & "," &
                     Float_32'Image (Y) & "," &
                     Integer'Image (Best_Class (Scores, Col)));
                end loop;
             end;
          end;
       end loop;
       Close (Grid_File);
    exception
       when others =>
          if Is_Open (Samples_File) then Close (Samples_File); end if;
          if Is_Open (Grid_File) then Close (Grid_File); end if;
          raise;
    end Export_Plot_Data;

begin
    Data := Create_Tensor (Generate_Spiral_Data
      (Samples_Per_Class, Num_Classes, Target));

    Add (M, Layer1'Unchecked_Access);
    Add (M, ReLU_Object'Unchecked_Access);
    Add (M, Layer2'Unchecked_Access);

    Optim.Parameters := M.Parameters'Unchecked_Access;
    Optim.Lr := 0.1;
    Optim.Weight_Decay := 0.001;
    Optim.Momentum := 0.9;

    Fit (M, Data, Target, Batch_Size, Num_Epochs, Optim, Loss_Fn);

    Predicted_Labels := Create_Tensor (Predict (M, Data), With_Grad => False);
    Accuracy := Calculate_Accuracy (Predicted_Labels.Data.all, Target);

    Put_Line ("Model Accuracy = " & Float'Image (Accuracy));
    Export_Plot_Data;
    Put_Line ("Plot data written to spiral_samples.csv and spiral_grid.csv");

end Mlengine.Main;
