--  Ceci est une version du m�me algorithme que Int_Arith.SPARK, o� nous
--  avons remplac� le tableau par une liste cha�n�e.

package List_Arith
  with Annotate => (GNATprove, Terminating)
is
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
     (if A = null then 0 else 1 + Natural'Min (2**31 - 2, Length (A.Next)));

   function Sum (A : access constant Cell) return Natural is
     (if A = null then 0 else A.Val + Sum (A.Next))
   with
     Ghost,
     Pre  => Length (A) <= Max_Length,
     Post => Sum'Result <= Length (A) * Max_Value,
     Subprogram_Variant => (Decreases => Length (A));

   function Sum_List (A : Data) return Integer
   with
     Pre  => Length (A) <= Max_Length,
     Post => Sum_List'Result = Sum (A);

   procedure Init_List (A : in out Data)
   with
     Pre  => Length (A) <= Max_Length,
     Post => Sum (A) = 0;

end List_Arith;
