with Ada.Numerics.Big_Numbers.Big_Integers;
use  Ada.Numerics.Big_Numbers.Big_Integers;

package Int_Arith is

   --  Ceci est la traduction imm�diate de l'algorithme de Floyd pour sommer
   --  les �l�ments d'un tableau utilis� dans l'article � Assigning Meaning
   --  to Programs �.

   --  L'absence de bornes sur les indexes et les valeurs du tableau rend
   --  improuvables les v�rifications de respect des bornes de valeurs dans
   --  le corps de la fonction.

   package Floyd is

      subtype Index is Integer;
      subtype Value is Integer;
      type Data is array (Index range <>) of Value with
        Predicate => Data'First = 1 and Data'Last >= 0;

      function Sum_Floyd (A : Data; N : Index) return Integer;

   end Floyd;

   --  Ceci est une version plus idiomatique en SPARK du m�me algorithme,
   --  o� nous avons ajout� des bornes pour les indexes et les valeurs du
   --  tableau.

   --  La fonction r�cursive Sum est utilis�e pour d�finir la sp�cification
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

   --  Ceci est une version du m�me algorithme o� les valeurs du tableau
   --  ne sont pas born�es. On ajoute � la place une pr�condition � la
   --  fonction Sum_Bignum qui sp�cifie que la somme des �l�ments du
   --  tableau ne doit pas pas d�passer la capacit� des entiers.

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

   --  Ceci est une version du m�me algorithme qui utilise une arithm�tique
   --  modulaire. Il n'est pas n�cessaire de borner les valeurs dans cette
   --  version, puisqu'il n'y a pas de d�bordement de capacit� possible.

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
