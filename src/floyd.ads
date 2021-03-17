--  Ceci est la traduction immédiate de l'algorithme de Floyd pour sommer les
--  éléments d'un tableau utilisé dans l'article « Assigning Meaning to
--  Programs ».

--  L'absence de bornes sur les indexes et les valeurs du tableau rend
--  improuvables les vérifications de respect des bornes de valeurs dans
--  le corps de la fonction.

package Floyd is

   subtype Index is Integer;
   subtype Value is Integer;
   type Data is array (Index range 1..<>) of Value;

   function Sum_Floyd (A : Data; N : Index) return Integer
   with
     Pre => N in 0..A'Last;

end Floyd;
