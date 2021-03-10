package body Floyd is

   function Sum_Floyd (A : Data; N : Index) return Integer is
      I : Index := 1;
      S : Value := 0;
   begin
      while I <= N loop
         pragma Loop_Invariant (I in 1..N);
         S := S + A(I);
         I := I + 1;
      end loop;

      return S;
   end Sum_Floyd;

end Floyd;
