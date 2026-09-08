package Prorata_Telescope_Pkg with SPARK_Mode is

   subtype Part_Index is Integer range 1 .. 8;
   subtype Part_Count is Integer range 0 .. 8;
   subtype Amount is Integer range 0 .. 10000;
   subtype Product is Integer range 0 .. 100000000;

   type Cumulative_List is array (Part_Index) of Amount;

   function Running_Weight (C : Cumulative_List; I : Part_Count) return Amount
     with Post => Running_Weight'Result = (if I = 0 then 0 else C (I));

   function Running_Weight (C : Cumulative_List; I : Part_Count) return Amount is
     (if I = 0 then 0 else C (I));

   function Non_Decreasing (C : Cumulative_List; N : Part_Count) return Boolean
     with Post => Non_Decreasing'Result = (for all K in Part_Index range 1 .. N => Running_Weight (C, K - 1) <= Running_Weight (C, K));

   function Non_Decreasing (C : Cumulative_List; N : Part_Count) return Boolean is
     (for all K in Part_Index range 1 .. N => Running_Weight (C, K - 1) <= Running_Weight (C, K));

   function Share (T : Amount; C : Cumulative_List; S : Amount; I : Part_Index) return Product
     with Pre => S > 0 and then Non_Decreasing (C, I) and then Running_Weight (C, I) <= S,
          Post => Share'Result = (T * Running_Weight (C, I) / S - T * Running_Weight (C, I - 1) / S);

   function Share (T : Amount; C : Cumulative_List; S : Amount; I : Part_Index) return Product is
     (T * Running_Weight (C, I) / S - T * Running_Weight (C, I - 1) / S);

   function Sum_Of_Shares (T : Amount; C : Cumulative_List; S : Amount; N : Part_Count) return Product
     with Pre => S > 0 and then Non_Decreasing (C, N) and then Running_Weight (C, N) <= S,
          Post => Sum_Of_Shares'Result = T * Running_Weight (C, N) / S,
          Subprogram_Variant => (Decreases => N);

   function Sum_Of_Shares (T : Amount; C : Cumulative_List; S : Amount; N : Part_Count) return Product is
     (if N = 0 then 0 else Sum_Of_Shares (T, C, S, N - 1) + Share (T, C, S, N));

   function Conserved (T : Amount; C : Cumulative_List; S : Amount; N : Part_Count) return Boolean
     with Pre => S > 0 and then Non_Decreasing (C, N) and then Running_Weight (C, N) <= S and then Running_Weight (C, N) = S,
          Post => Conserved'Result;

   function Conserved (T : Amount; C : Cumulative_List; S : Amount; N : Part_Count) return Boolean is
     (Sum_Of_Shares (T, C, S, N) = T);

end Prorata_Telescope_Pkg;
