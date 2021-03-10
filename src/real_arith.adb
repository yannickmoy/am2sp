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

      --  Si seuls les prouveurs CVC4 et Z3 sont utilisés, ils ne suffisent
      --  pas à démontrer la postcondition de Sum. On peut alors chercher à
      --  démontrer cette borne supérieure de manière extrinsèque à l'aide
      --  du lemme Lemma_Sum_Upper_Bound, qui amène à définir le lemme
      --  d'arithmétique pure Lemma_Bump_Small_Integral_Float qui peut être
      --  soit testé exhaustivement, soit prouvé avec un assistant de preuve
      --  comme Coq.

      --  Notez que le prouveur Alt-Ergo prouve ici la postcondition de Sum et
      --  ces lemmes, mais cet exemple est une illustration d'utilisation de la
      --  programmation auto-active.

      procedure Lemma_Bump_Small_Integral_Float (I : Natural)
      with
        Ghost,
        Pre  => I < 2**24,
        Post => Float (I) + 1.0 = Float (I + 1)
      is
      begin
         null;
      end Lemma_Bump_Small_Integral_Float;

      procedure Lemma_Sum_Upper_Bound (A : Data; Up_To : Index)
      with
        Ghost,
        Pre  => Up_To <= A'Last,
        Post => Sum (A, Up_To) <= Float (Up_To) * Max_Value,
        Subprogram_Variant => (Decreases => Up_To)
      is
      begin
         if Up_To /= 0 then
            Lemma_Sum_Upper_Bound (A, Up_To - 1);
            Lemma_Bump_Small_Integral_Float (Up_To - 1);
            pragma Assert (Float (Up_To) = Float (Up_To - 1) + Float (1));
         end if;
      end Lemma_Sum_Upper_Bound;
   end Floating;

   package body Bignum is

      procedure Lemma_Bump_Small_Integral_Float (I : Natural)
      with
        Ghost,
        Pre  => I < 2**24,
        Post => Float (I) + 1.0 = Float (I + 1)
      is
      begin
         null;
      end Lemma_Bump_Small_Integral_Float;

      procedure Lemma_Bump_Small_Integral_Bigreal (I : Natural)
      with
        Ghost,
        Pre  => I < 2**24,
        Post => To_Bigreal (Float (I)) + To_Bigreal (1.0) =
                To_Bigreal (Float (I + 1))
      is
      begin
         null;
      end Lemma_Bump_Small_Integral_Bigreal;

      procedure Lemma_Add_Increment (S : Float; Incr : Value)
      with
        Ghost,
        Pre  => S in 0.0..Float(Index'Last),
        Post => abs (To_Bigreal (S + Incr)
                     - To_Bigreal (S) - To_Bigreal (Incr))
                <= Epsilon
      is
      begin
         null;
      end Lemma_Add_Increment;

      function Sum_Bignum (A : Data) return Float is
         S : Float range 0.0 .. Float'Last := 0.0;
      begin
         for I in A'Range loop
            Lemma_Add_Increment (S, A(I));
            S := S + A(I);
            Lemma_Bump_Small_Integral_Float (I-1);
            Lemma_Bump_Small_Integral_Bigreal (I-1);
            pragma Assert (To_Bigreal (Float (I)) * Epsilon =
              (To_Bigreal (Float (I-1)) + To_Bigreal (1.0)) * Epsilon);
            pragma Assert (To_Bigreal (Float (I)) * Epsilon =
              To_Bigreal (Float (I-1)) * Epsilon + Epsilon);
            pragma Loop_Invariant (S <= Float (I));
            pragma Loop_Invariant (abs (To_Bigreal (S) - Sum (A, I)) <=
                                     To_Bigreal (Float (I)) * Epsilon);
         end loop;
         return S;
      end Sum_Bignum;

   end Bignum;

end Real_Arith;
