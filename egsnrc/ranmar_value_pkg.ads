--  Canada le Brave
--
package Ranmar_Value_Pkg with SPARK_Mode is

   type Word_Type is range 0 .. 16_777_215;
   type Carry_Type is range 0 .. 16_777_212;
   type Wide_Int is range -16_777_216 .. 33_554_432;

   function Next_Word (X, Y : Word_Type) return Word_Type is
     (Word_Type (Wide_Int (X) - Wide_Int (Y) + (if Wide_Int (X) < Wide_Int (Y) then 16_777_216 else 0)))
     with Post => Wide_Int (Next_Word'Result) = (Wide_Int (X) - Wide_Int (Y)) mod 16_777_216;

   function Advance_Carry (C : Carry_Type) return Carry_Type is
     (Carry_Type (Wide_Int (C) - 7_654_321 + (if Wide_Int (C) < 7_654_321 then 16_777_213 else 0)))
     with Post => Wide_Int (Advance_Carry'Result) = (Wide_Int (C) - 7_654_321) mod 16_777_213;

   function Output (W : Word_Type; C : Carry_Type) return Word_Type is
     (Word_Type (Wide_Int (W) - Wide_Int (C) + (if Wide_Int (W) < Wide_Int (C) then 16_777_216 else 0)))
     with Post => Wide_Int (Output'Result) = (Wide_Int (W) - Wide_Int (C)) mod 16_777_216;

end Ranmar_Value_Pkg;
