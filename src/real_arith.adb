package body Real_Arith is

   package body Fixed is
      function Sum_Fixed (A : Data) return Fix is
         S : Fix := 0.0;
      begin
         for I in A'Range loop
            S := S + A(I);
            pragma Loop_Invariant (S = Sum (A, I));
         end loop;
         return S;
      end Sum_Fixed;
   end Fixed;

   package body Floating is
      function Sum_Floating (A : Data) return Float is
         S : Float := 0.0;
      begin
         for I in A'Range loop
            S := S + A(I);
            pragma Loop_Invariant (S = Sum (A, I));
         end loop;
         return S;
      end Sum_Floating;
   end Floating;

end Real_Arith;
