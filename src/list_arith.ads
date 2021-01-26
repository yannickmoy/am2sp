package List_Arith is

   --  Ceci est une version du même algorithme que Int_Arith.SPARK, où nous
   --  avons remplacé le tableau par une liste chaînée.

   package Lists is

      Max_Length : constant := 1_000_000;
      Max_Value  : constant := 1_000;
      subtype Value is Integer range 0 .. Max_Value;

      type Cell;
      type Data is access Cell;
      type Cell is record
         Val  : Value;
         Next : Data;
      end record;

      function Length (A : access constant Cell) return Natural is
         (if A = null then 0 else 1 + Natural'Min (2**31 - 2, Length (A.Next)))
      with
         Annotate => (GNATprove, Terminating);

      function Sum (A : access constant Cell) return Natural is
         (if A = null then 0 else A.Val + Sum (A.Next))
      with
        Pre  => Length (A) <= Max_Length,
        Post => Sum'Result <= Length (A) * Max_Value,
        Subprogram_Variant => (Decreases => Length (A));

      function Sum_List (A : Data) return Integer
      with
        Pre  => Length (A) <= Max_Length,
        Post => Sum_List'Result = Sum (A);

   end Lists;

end List_Arith;
