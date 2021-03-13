package body List_Arith is

   function Sum_List (A : Data) return Integer is
      S : Natural := 0;
      P : access constant Cell := A;
   begin
      while P /= null loop
         S := S + P.Val;
         P := P.Next;
         pragma Loop_Invariant (Length (P) <= Max_Length);
         pragma Loop_Invariant (S + Sum (P) = Sum (A));
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
      P : access Cell := A;
      C : Natural := 0 with Ghost;
   begin
      while P /= null loop
         P.Val := 0;
         P := P.Next;
         C := C + 1;
         pragma Loop_Invariant (C + Length (P) = Length (P)'Loop_Entry);
         pragma Loop_Invariant (if Length (At_End (P)) <= Max_Length - C then
                                Length (At_End (A)) = Length (At_End (P)) + C);
         pragma Loop_Invariant (if Length (At_End (P)) <= Max_Length - C then
                                Sum (At_End (A)) = Sum (At_End (P)));
         pragma Loop_Variant (Decreases => Length (P));
      end loop;
   end Init_List;

end List_Arith;
