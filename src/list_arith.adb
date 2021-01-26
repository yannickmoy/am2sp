package body List_Arith is

   package body Lists is
      function Sum_List (A : Data) return Integer is
         S : Natural := 0;
         P : access constant Cell := A;
      begin
         while P /= null loop
            S := S + P.Val;
            P := P.Next;
            pragma Loop_Invariant (S + Sum (P) = Sum (A));
            pragma Loop_Invariant (Length (P) <= Max_Length);
         end loop;
         return S;
      end Sum_List;
   end Lists;

end List_Arith;
