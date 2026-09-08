--  Canada le Brave
--
package Carry_Forward_Rounding_Pkg with SPARK_Mode is

   subtype Component_Index is Integer range 1 .. 8;
   subtype Component_Count is Integer range 0 .. 8;
   subtype Amount is Integer range 0 .. 10000;
   subtype Carry is Integer range -5 .. 5;
   subtype Shifted_Amount is Integer range -5 .. 10005;
   subtype Running_Sum is Integer range -80 .. 80080;

   type Amount_List is array (Component_Index) of Amount;

   function Rounded (X : Shifted_Amount) return Running_Sum
     with Post => Rounded'Result mod 10 = 0;

   function Rounded (X : Shifted_Amount) return Running_Sum is
     (if X >= 0 then 10 * ((X + 5) / 10) else -(10 * (((-X) + 5) / 10)));

   function Residual (X : Shifted_Amount) return Carry
     with Post => Residual'Result >= -5 and then Residual'Result <= 5;

   function Residual (X : Shifted_Amount) return Carry is
     (X - Rounded (X));

   function Plain_Total (A : Amount_List; N : Component_Count) return Running_Sum
     with Post => Plain_Total'Result >= 0 and then Plain_Total'Result <= 10000 * N,
          Subprogram_Variant => (Decreases => N);

   function Plain_Total (A : Amount_List; N : Component_Count) return Running_Sum is
     (if N = 0 then 0 else Plain_Total (A, N - 1) + A (N));

   function Carry_After (A : Amount_List; N : Component_Count) return Carry
     with Post => Carry_After'Result >= -5 and then Carry_After'Result <= 5,
          Subprogram_Variant => (Decreases => N);

   function Carry_After (A : Amount_List; N : Component_Count) return Carry is
     (if N = 0 then 0 else Residual (A (N) + Carry_After (A, N - 1)));

   function Reported_Total (A : Amount_List; N : Component_Count) return Running_Sum
     with Post => Reported_Total'Result = Plain_Total (A, N) - Carry_After (A, N)
                  and then Reported_Total'Result mod 10 = 0,
          Subprogram_Variant => (Decreases => N);

   function Reported_Total (A : Amount_List; N : Component_Count) return Running_Sum is
     (if N = 0 then 0 else Reported_Total (A, N - 1) + Rounded (A (N) + Carry_After (A, N - 1)));

   function Balance_Is_Preserved (A : Amount_List; N : Component_Count) return Boolean
     with Pre => Plain_Total (A, N) mod 10 = 0,
          Post => Balance_Is_Preserved'Result;

   function Balance_Is_Preserved (A : Amount_List; N : Component_Count) return Boolean is
     (Reported_Total (A, N) = Plain_Total (A, N));

end Carry_Forward_Rounding_Pkg;
