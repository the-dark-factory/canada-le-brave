--  Canada le Brave
--
package Raking_Adjustment_Pkg with SPARK_Mode is

   subtype Index is Integer range 1 .. 8;
   subtype Count is Integer range 0 .. 8;
   subtype Amount is Integer range 1 .. 100;
   subtype Target is Integer range 0 .. 1000;
   subtype Sum_Value is Integer range 0 .. 800;
   subtype Sum_Positive is Integer range 1 .. 800;
   subtype Adjusted_Value is Integer range 0 .. 100000;
   subtype Adjusted_Sum_Value is Integer range 0 .. 800000;

   type Amount_List is array (Index) of Amount;

   function Total_Of (A : Amount_List; N : Count) return Sum_Value
     with Post => Total_Of'Result >= N and then Total_Of'Result <= 100 * N,
          Subprogram_Variant => (Decreases => N);

   function Total_Of (A : Amount_List; N : Count) return Sum_Value is
     (if N = 0 then 0 else Total_Of (A, N - 1) + A (N));

   function Adjusted (V : Amount; T : Target; S : Sum_Positive) return Adjusted_Value
     with Post => 2 * S * Adjusted'Result <= 2 * V * T + S
                  and then 2 * S * Adjusted'Result > 2 * V * T - S;

   function Adjusted (V : Amount; T : Target; S : Sum_Positive) return Adjusted_Value is
     ((2 * V * T + S) / (2 * S));

   function Adjusted_Sum
     (A : Amount_List; N : Count; T : Target; S : Sum_Positive) return Adjusted_Sum_Value
     with Post => Adjusted_Sum'Result <= 100000 * N
                  and then 2 * S * Adjusted_Sum'Result <= 2 * T * Total_Of (A, N) + N * S
                  and then 2 * S * Adjusted_Sum'Result >= 2 * T * Total_Of (A, N) - N * S,
          Subprogram_Variant => (Decreases => N);

   function Adjusted_Sum
     (A : Amount_List; N : Count; T : Target; S : Sum_Positive) return Adjusted_Sum_Value is
     (if N = 0 then 0 else Adjusted_Sum (A, N - 1, T, S) + Adjusted (A (N), T, S));

   function Lands_Within_Half_Each (A : Amount_List; N : Count; T : Target) return Boolean
     with Pre  => N >= 1,
          Post => Lands_Within_Half_Each'Result;

   function Lands_Within_Half_Each (A : Amount_List; N : Count; T : Target) return Boolean is
     (2 * Adjusted_Sum (A, N, T, Total_Of (A, N)) <= 2 * T + N
      and then 2 * Adjusted_Sum (A, N, T, Total_Of (A, N)) >= 2 * T - N);

   function Order_Preserved (V1 : Amount; V2 : Amount; T : Target; S : Sum_Positive) return Boolean
     with Pre  => V1 <= V2,
          Post => Order_Preserved'Result;

   function Order_Preserved (V1 : Amount; V2 : Amount; T : Target; S : Sum_Positive) return Boolean is
     (Adjusted (V1, T, S) <= Adjusted (V2, T, S));

   function Exact_When_Divisible (V : Amount; T : Target; S : Sum_Positive) return Boolean
     with Pre  => (V * T) mod S = 0,
          Post => Exact_When_Divisible'Result;

   function Exact_When_Divisible (V : Amount; T : Target; S : Sum_Positive) return Boolean is
     (Adjusted (V, T, S) * S = V * T);

end Raking_Adjustment_Pkg;
