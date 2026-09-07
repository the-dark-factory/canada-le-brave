--  Canada le Brave
--
package Ranlux_Borrow_Pkg with SPARK_Mode is

   type Seed_Type is range 0 .. 16_777_215;
   type Carry_Type is range 0 .. 1;
   type Wide_Type is range -16_777_216 .. 16_777_215;

   type Step_Result_Type is record
      Seed : Seed_Type;
      Carry : Carry_Type;
   end record;

   function Raw_Diff (S1, S2 : Seed_Type; C : Carry_Type) return Wide_Type is
     ((Wide_Type (S1) - Wide_Type (S2)) - Wide_Type (C));

   function Step (S1, S2 : Seed_Type; C : Carry_Type) return Step_Result_Type is
     (if Raw_Diff (S1, S2, C) < 0 then
        (Seed => Seed_Type (Raw_Diff (S1, S2, C) + 16_777_216), Carry => 1)
      else
        (Seed => Seed_Type (Raw_Diff (S1, S2, C)), Carry => 0))
     with Post =>
       (Wide_Type (Step'Result.Seed) = ((Wide_Type (S1) - Wide_Type (S2) - Wide_Type (C)) mod 16_777_216)
        and then Step'Result.Carry = (if Raw_Diff (S1, S2, C) < 0 then 1 else 0)
        and then (Step'Result.Carry = 1) = (Wide_Type (Step'Result.Seed) /= Raw_Diff (S1, S2, C)));

end Ranlux_Borrow_Pkg;
