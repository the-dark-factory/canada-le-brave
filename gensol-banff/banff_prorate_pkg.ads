--  Canada le Brave
--
package Banff_Prorate_Pkg with SPARK_Mode is

   subtype Component_Index is Natural range 1 .. 8;
   subtype Component_Count is Natural range 0 .. 8;
   subtype Amount is Natural range 0 .. 10_000;
   subtype Running_Sum is Natural range 0 .. 80_000;
   subtype Product is Natural range 0 .. 100_000_000;

   type Amount_List is array (Component_Index) of Amount;

   function Sum_Of_First_N (A : Amount_List; N : Component_Count) return Running_Sum
     with Pre => N <= A'Length,
          Post => Sum_Of_First_N'Result <= 10_000 * N,
          Subprogram_Variant => (Decreases => N);

   function Total (A : Amount_List; Count : Component_Count) return Running_Sum
     with Pre => Count <= A'Length;

   function Largest_Remainder_Share
     (Weight : Amount; Target : Amount; Weight_Sum : Amount) return Amount
     with Pre => Weight_Sum > 0 and Weight <= Weight_Sum;

   function Shortfall
     (A : Amount_List; Count : Component_Count; Target : Amount; Weight_Sum : Amount) return Amount
     with Pre => Weight_Sum > 0
       and then (for all I in Component_Index range 1 .. Count => A (I) <= Weight_Sum)
       and then Total (A, Count) <= Target;

   function Conserved
     (Adjusted : Amount_List; Count : Component_Count; Target : Amount) return Boolean;

   function No_Component_Exceeds_Total
     (Adjusted : Amount_List; Count : Component_Count; Target : Amount) return Boolean;

   function Shortfall_Is_Bounded
     (A : Amount_List; Count : Component_Count; Target : Amount; Weight_Sum : Amount) return Boolean
     with Pre => Weight_Sum > 0
       and then (for all I in Component_Index range 1 .. Count => A (I) <= Weight_Sum)
       and then Total (A, Count) <= Target;

   function Sum_Of_First_N (A : Amount_List; N : Component_Count) return Running_Sum is
     (if N = 0 then 0 else Sum_Of_First_N (A, N - 1) + A (N));

   function Total (A : Amount_List; Count : Component_Count) return Running_Sum is
     (Sum_Of_First_N (A, Count));

   function Largest_Remainder_Share
     (Weight : Amount; Target : Amount; Weight_Sum : Amount) return Amount is
     (Product (Weight) * Product (Target) / Product (Weight_Sum));

   function Shortfall
     (A : Amount_List; Count : Component_Count; Target : Amount; Weight_Sum : Amount) return Amount is
     (Target - Total (A, Count));

   function Conserved
     (Adjusted : Amount_List; Count : Component_Count; Target : Amount) return Boolean is
     (Total (Adjusted, Count) = Target);

   function No_Component_Exceeds_Total
     (Adjusted : Amount_List; Count : Component_Count; Target : Amount) return Boolean is
     ((for all I in Component_Index range 1 .. Count => Adjusted (I) <= Target));

   function Shortfall_Is_Bounded
     (A : Amount_List; Count : Component_Count; Target : Amount; Weight_Sum : Amount) return Boolean is
     (Shortfall (A, Count, Target, Weight_Sum) < Count);

end Banff_Prorate_Pkg;
