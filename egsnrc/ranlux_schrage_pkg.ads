--  Canada le Brave
--
package Ranlux_Schrage_Pkg with SPARK_Mode is

   type Seed_Type is range 1 .. 2_147_483_562;
   type Word_Type is range -2_147_483_648 .. 2_147_483_647;
   type Big_Type is range -100_000_000_000_000 .. 100_000_000_000_000;

   function High_Part (Seed : Seed_Type) return Word_Type is
     (Word_Type (Seed) / 53_668);

   function Low_Part (Seed : Seed_Type) return Word_Type is
     (Word_Type (Seed) - 53_668 * High_Part (Seed));

   function Raw_Result (Seed : Seed_Type) return Word_Type is
     (40_014 * Low_Part (Seed) - 12_211 * High_Part (Seed));

   function Next_Seed (Seed : Seed_Type) return Seed_Type is
     (Seed_Type
        ((if Raw_Result (Seed) < 0 then Raw_Result (Seed) + 2_147_483_563
          else Raw_Result (Seed))))
     with Post =>
       (Big_Type (Next_Seed'Result) = (40_014 * Big_Type (Seed)) mod 2_147_483_563
        and then Next_Seed'Result >= 1
        and then Next_Seed'Result <= 2_147_483_562);

end Ranlux_Schrage_Pkg;
