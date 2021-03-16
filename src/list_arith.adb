package body List_Arith is

   function Sum_List (A : Data) return Integer is
      S : Natural := 0;
      P : access constant Cell := A;
   begin
      while P /= null loop
         S := S + P.Val;
         P := P.Next;
         pragma Loop_Invariant (Length (P) <= To_Bigint (Max_Length));
         pragma Loop_Invariant (To_Bigint (S) + Sum (P) = Sum (A));
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
         pragma Loop_Invariant (To_Bigint (C) + Length (P) = Length (P)'Loop_Entry);
         pragma Loop_Invariant (Length (At_End (A)) = Length (At_End (P)) + To_Bigint (C));
         pragma Loop_Invariant (Sum (At_End (A)) = Sum (At_End (P)));
      end loop;
   end Init_List;

end List_Arith;
