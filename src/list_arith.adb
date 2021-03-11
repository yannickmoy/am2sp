package body List_Arith is

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

   function Pledge (A : access constant Cell; Prop : Boolean) return Boolean is
     (Prop)
   with
     Ghost,
     Annotate => (GNATprove, Pledge);

   procedure Init_List (A : in out Data) is
      C : Natural := 0;
      P : access Cell := A;
   begin
      while P /= null loop
         P.Val := 0;
         P := P.Next;
         C := C + 1;
         pragma Loop_Invariant (C = Length (P)'Loop_Entry - Length (P));
         pragma Loop_Invariant (Pledge (P,
                                 (if Length (P) <= Max_Length - C then
                                   Length (P) + C = Length (A))));
         pragma Loop_Invariant (Pledge (P,
                                 (if Length (P) <= Max_Length - C then
                                   Sum (P) = Sum (A))));
         pragma Loop_Variant (Decreases => Length (P));
      end loop;
   end Init_List;

end List_Arith;
