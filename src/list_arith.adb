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
            pragma Loop_Variant (Decreases => Length (P));
         end loop;
         return S;
      end Sum_List;

      function At_End (A : access constant Cell) return access constant Cell is
        (A)
      with
        Ghost,
        Annotate => (GNATprove, At_End_Borrow);

      procedure Init_List (A : in out Data) is
         C : Natural := 0;
         P : access Cell := A;
      begin
         while P /= null loop
            P.Val := 0;
            P := P.Next;
            C := C + 1;
            pragma Loop_Invariant (C = Length (P)'Loop_Entry - Length (P));
            pragma Loop_Invariant (if Length (At_End (P)) <= Max_Length - C then
                                      Length (At_End (P)) + C = Length (At_End (A)));
            pragma Loop_Invariant (if Length (At_End (P)) <= Max_Length - C then
                                      Sum (At_End (P)) = Sum (At_End (A)));
            pragma Loop_Variant (Decreases => Length (P));
         end loop;
      end Init_List;
   end Lists;

end List_Arith;
