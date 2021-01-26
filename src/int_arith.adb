package body Int_Arith is

   package body Floyd is
      function Sum_Floyd (A : Data; N : Index) return Integer is
         I : Index := 1;
         S : Value := 0;
      begin
         while I <= N loop
            S := S + A(I);
            I := I + 1;
         end loop;
         return S;
      end Sum_Floyd;
   end Floyd;

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

end Int_Arith;
