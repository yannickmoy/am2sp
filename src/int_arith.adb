package body Int_Arith is

   package body SPARK is
      function Sum_SPARK (A : Data) return Integer is
         S : Integer := 0;
      begin
         for I in A'Range loop
            S := S + A(I);
            pragma Loop_Invariant (S = Sum (A, I));
         end loop;
         return S;
      end Sum_SPARK;

      procedure Sum_SPARK (A : in out Data_Sum) is
      begin
         A.S := 0;
         for I in A.D'Range loop
            A.S := A.S + A.D(I);
            pragma Loop_Invariant (A.S = Sum (A.D, I));
            pragma Loop_Invariant (A.D = A.D'Loop_Entry);
         end loop;
      end Sum_SPARK;
   end SPARK;

   package body Bignum is

      procedure Lemma_Sum_Increasing (A : Data; I, J : Index)
      with
        Ghost,
        Pre  => I in A'Range and then J in A'Range and then I <= J,
        Post => Sum (A, Up_To => I) <= Sum (A, Up_To => J)
      is
         S : Bigint := Sum (A, Up_To => I);
      begin
         for K in I + 1 .. J loop
            S := S + To_Bigint (A (K));
            pragma Loop_Invariant (S = Sum (A, Up_To => K));
            pragma Loop_Invariant (S'Loop_Entry <= S);
         end loop;
      end Lemma_Sum_Increasing;

      function Sum_Bignum (A : Data) return Integer is
         S : Integer := 0;
      begin
         for I in A'Range loop
            Lemma_Sum_Increasing (A, I, A'Last);
            S := S + A(I);
            pragma Loop_Invariant (To_Bigint (S) = Sum (A, I));
         end loop;
         return S;
      end Sum_Bignum;
   end Bignum;

   package body Modular is
      function Sum_Modular (A : Data) return Unsigned is
         S : Unsigned := 0;
      begin
         for I in A'Range loop
            S := S + A(I);
            pragma Loop_Invariant (S = Sum (A, I));
         end loop;
         return S;
      end Sum_Modular;
   end Modular;

   package body Init is
      procedure Lemma_Sum_Ones (A : Data; I : Index)
      with
        Ghost,
        Pre  => A'First = 1
          and then I in A'Range
          and then (for all J in 1 .. I => A(J)'Initialized)
          and then (for all J in 1 .. I => A(J) = 1),
        Post => Sum (A, Up_To => I) = I
      is
      begin
         for J in 1 .. I loop
            pragma Loop_Invariant (Sum (A, J) = J);
         end loop;
      end Lemma_Sum_Ones;

      procedure Init_SPARK (A : in out Data; S : Positive) is
      begin
         for I in 1 .. S loop
            A(I) := 1;
            pragma Loop_Invariant (for all J in 1 .. I => A(J)'Initialized);
            pragma Loop_Invariant (for all J in 1 .. I => A(J) = 1);
         end loop;
         Lemma_Sum_Ones (A, S);
      end Init_SPARK;
   end Init;

end Int_Arith;
