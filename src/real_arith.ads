with Ada.Numerics.Big_Numbers.Big_Reals;
use Ada.Numerics.Big_Numbers.Big_Reals;

package Real_Arith is

   --  Ceci est une version du même algorithme avec des valeurs réelles à
   --  virgule fixe, qui sont traitées par l'analyseur comme des entiers.

   package Fixed
     with Annotate => (GNATprove, Terminating)
   is
      Small : constant := 2.0**(-10);  --  close to 0.001
      type Fix is delta Small range 0.0 .. (2.0**31 - 1.0) * Small;

      subtype Index is Integer range 0 .. 1_000_000;
      Max_Value : constant := 1.0;
      subtype Value is Fix range 0.0 .. Max_Value;
      type Data is array (Index range <>) of Value
      with
        Predicate => Data'First = 1 and Data'Last >= 0;

      function Sum (A : Data; Up_To : Index) return Fix is
        (if Up_To = 0 then 0.0 else A(Up_To) + Sum (A, Up_To - 1))
      with
        Ghost,
        Pre  => Up_To <= A'Last,
        Post => Sum'Result <= Up_To * Max_Value,
        Subprogram_Variant => (Decreases => Up_To);

      function Sum (A : Data) return Fix is (Sum (A, Up_To => A'Last))
      with
        Ghost;

      function Sum_Fixed (A : Data) return Fix
      with
        Post => Sum_Fixed'Result = Sum (A);

   end Fixed;

   --  Ceci est une version du même algorithme avec des valeurs réelles
   --  à virgule flottante, qui sont traitées par l'analyseur très
   --  différemment des entiers.

   package Floating
     with Annotate => (GNATprove, Terminating)
   is
      subtype Index is Integer range 0 .. 1_000_000;
      Max_Value : constant := 1.0;
      subtype Value is Float range 0.0 .. Max_Value;
      type Data is array (Index range <>) of Value
      with
        Predicate => Data'First = 1 and Data'Last >= 0;

      function Sum (A : Data; Up_To : Index) return Float is
        (if Up_To = 0 then 0.0 else A(Up_To) + Sum (A, Up_To - 1))
      with
        Ghost,
        Pre  => Up_To <= A'Last,
        Post => Sum'Result <= Float (Up_To) * Max_Value,
        Subprogram_Variant => (Decreases => Up_To);

      function Sum (A : Data) return Float is (Sum (A, Up_To => A'Last))
      with
        Ghost;

      function Sum_Floating (A : Data) return Float
      with
        Post => Sum_Floating'Result = Sum (A);

   end Floating;

   --  Ceci est une version du même algorithme où la fonction Sum opère sur
   --  des rationnels mathématiques, et la postcondition de Sum borne l'erreur
   --  introduite par l'utilisation de calculs en virgule flottante.

   package Bignum
     with Annotate => (GNATprove, Terminating)
   is
      subtype Index is Integer range 0 .. 1_000;
      Max_Value : constant := 1.0;
      subtype Value is Float range 0.0 .. Max_Value;
      type Data is array (Index range <>) of Value
      with
        Predicate => Data'First = 1 and Data'Last >= 0;

      subtype Bigreal is Big_Real;
      package Bigconv is new Float_Conversions (Float);
      function To_Bigreal (Arg : Float) return Valid_Big_Real
        renames Bigconv.To_Big_Real;

      function Sum (A : Data; Up_To : Index) return Bigreal is
        (if Up_To = 0 then To_Bigreal (0.0)
         else To_Bigreal (A(Up_To)) + Sum (A, Up_To - 1))
      with
        Ghost,
        Pre  => Up_To <= A'Last,
        Post => Sum'Result <=
          To_Bigreal (Float (Up_To)) * To_Bigreal (Max_Value),
        Subprogram_Variant => (Decreases => Up_To);

      function Sum (A : Data) return Bigreal is (Sum (A, Up_To => A'Last))
      with
        Ghost;

      Epsilon : constant Bigreal := To_Bigreal (0.0001);

      function Sum_Bignum (A : Data) return Float
      with
        Post => abs (To_Bigreal (Sum_Bignum'Result) - Sum (A)) <=
          To_Bigreal (Float (A'Length)) * Epsilon;

   end Bignum;

end Real_Arith;
