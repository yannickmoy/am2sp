with Ada.Numerics.Big_Numbers.Big_Integers;
use  Ada.Numerics.Big_Numbers.Big_Integers;

--  Ceci est une version du même algorithme que Int_Arith.SPARK, où nous
--  avons remplacé le tableau par une liste chaînée.

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

   subtype Bigint is Big_Integer;
   function To_Bigint (Arg : Integer) return Valid_Big_Integer
     renames To_Big_Integer;

   function Length (A : access constant Cell) return Bigint is
     (if A = null then To_Bigint (0) else To_Bigint (1) + Length (A.Next));

   function Sum (A : access constant Cell) return Bigint is
     (if A = null then To_Bigint (0) else To_Bigint (A.Val) + Sum (A.Next))
   with
     Ghost,
     Post => Sum'Result >= To_Bigint (0)
       and then Sum'Result <= Length (A) * To_Bigint (Max_Value);

   function Sum_List (A : Data) return Integer
   with
     Pre  => Length (A) <= To_Bigint (Max_Length),
     Post => To_Bigint (Sum_List'Result) = Sum (A);

   procedure Init_List (A : in out Data)
   with
     Pre  => Length (A) <= To_Bigint (Max_Length),
     Post => Sum (A) = To_Bigint (0);

end List_Arith;
