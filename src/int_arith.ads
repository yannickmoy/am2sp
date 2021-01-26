with Ada.Numerics.Big_Numbers.Big_Integers;
use  Ada.Numerics.Big_Numbers.Big_Integers;

package Int_Arith is

   --  Ceci est la traduction immédiate de l'algorithme de Floyd pour sommer
   --  les éléments d'un tableau utilisé dans l'article « Assigning Meaning
   --  to Programs ».

   --  L'absence de bornes sur les indexes et les valeurs du tableau rend
   --  improuvables les vérifications de respect des bornes de valeurs dans
   --  le corps de la fonction.

   package Floyd is

      subtype Index is Integer;
      subtype Value is Integer;
      type Data is array (Index range <>) of Value with
        Predicate => Data'First = 1 and Data'Last >= 0;

      function Sum_Floyd (A : Data; N : Index) return Integer;

   end Floyd;

   --  Ceci est une version plus idiomatique en SPARK du même algorithme,
   --  où nous avons ajouté des bornes pour les indexes et les valeurs du
   --  tableau.

   --  La fonction récursive Sum est utilisée pour définir la spécification
   --  de la fonction Sum_SPARK.

   package SPARK is

      subtype Index is Integer range 0 .. 1_000_000;
      Max_Value : constant := 1_000;
      subtype Value is Integer range 0 .. Max_Value;
      type Data is array (Index range <>) of Value with
        Predicate => Data'First = 1 and Data'Last >= 0;

      function Sum (A : Data; Up_To : Index) return Integer is
         (if Up_To = 0 then 0 else A(Up_To) + Sum (A, Up_To - 1))
      with
        Pre  => Up_To <= A'Last,
        Post => Sum'Result <= Up_To * Max_Value,
        Subprogram_Variant => (Decreases => Up_To);

      function Sum (A : Data) return Integer is (Sum (A, Up_To => A'Last));

      function Sum_SPARK (A : Data) return Integer
      with
        Post => Sum_SPARK'Result = Sum (A);

   end SPARK;

   --  Ceci est une version du même algorithme où les valeurs du tableau
   --  ne sont pas bornées. On ajoute à la place une précondition à la
   --  fonction Sum_Bignum qui spécifie que la somme des éléments du
   --  tableau ne doit pas pas dépasser la capacité des entiers.

   package Bignum is

      subtype Index is Integer range 0 .. 1_000_000;
      Max_Value : constant := Integer'Last;
      subtype Value is Integer range 0 .. Max_Value;
      type Data is array (Index range <>) of Value with
        Predicate => Data'First = 1 and Data'Last >= 0;

      subtype Bigint is Big_Integer;
      function To_Bigint (Arg : Integer) return Valid_Big_Integer
        renames To_Big_Integer;

      function Sum (A : Data; Up_To : Index) return Bigint is
        (if Up_To = 0 then To_Bigint (0)
         else To_Bigint (A(Up_To)) + Sum (A, Up_To - 1))
      with
        Pre  => Up_To <= A'Last,
        Subprogram_Variant => (Decreases => Up_To);

      function Sum (A : Data) return Bigint is (Sum (A, Up_To => A'Last));

      function Sum_Bignum (A : Data) return Integer
      with
        Pre  => Sum (A) >= To_Bigint (0)
          and then Sum (A) <= To_Bigint (Integer'Last),
        Post => To_Bigint (Sum_Bignum'Result) = Sum (A);

   end Bignum;

   --  Ceci est une version du même algorithme qui utilise une arithmétique
   --  modulaire. Il n'est pas nécessaire de borner les valeurs dans cette
   --  version, puisqu'il n'y a pas de débordement de capacité possible.

   package Modular is

      type Unsigned is mod 2**32;

      subtype Index is Integer range 0 .. 1_000_000;
      subtype Value is Unsigned;
      type Data is array (Index range <>) of Value with
        Predicate => Data'First = 1 and Data'Last >= 0;

      function Sum (A : Data; Up_To : Index) return Unsigned is
         (if Up_To = 0 then 0 else A(Up_To) + Sum (A, Up_To - 1))
      with
        Pre => Up_To <= A'Last,
        Subprogram_Variant => (Decreases => Up_To);

      function Sum (A : Data) return Unsigned is (Sum (A, Up_To => A'Last));

      function Sum_Modular (A : Data) return Unsigned
      with
        Post => Sum_Modular'Result = Sum (A);

   end Modular;

end Int_Arith;
