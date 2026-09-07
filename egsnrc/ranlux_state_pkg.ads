--  Canada le Brave
--
package Ranlux_State_Pkg with SPARK_Mode is

   type Index_Type is range 1 .. 24;
   type Skip_Type is range 0 .. 365;
   type Carry_Type is range 0 .. 1;
   type Word_Type is range -3_652_424 .. 3_652_424;

   type State_Type is record
      I     : Index_Type;
      J     : Index_Type;
      Skip  : Skip_Type;
      Carry : Carry_Type;
   end record;

   function Recover_Skip (W : Word_Type) return Word_Type is
     (W / 10_000)
   with Pre => W >= 0;

   function Recover_Remainder (W : Word_Type) return Word_Type is
     (W - 10_000 * Recover_Skip (W))
   with Pre => W >= 0 and then W <= 3_652_424;

   function Recover_J (W : Word_Type) return Word_Type is
     (Recover_Remainder (W) / 100)
   with Pre => W >= 0 and then W <= 3_652_424;

   function Recover_I (W : Word_Type) return Word_Type is
     (Recover_Remainder (W) - 100 * Recover_J (W))
   with Pre => W >= 0 and then W <= 3_652_424;

   function Recover_Carry (W : Word_Type) return Carry_Type is
     (if W <= 0 then 1 else 0);

   function Unpacks_Cleanly (W : Word_Type) return Boolean is
     (Recover_I (abs W) >= 1
      and then Recover_I (abs W) <= 24
      and then Recover_J (abs W) >= 1
      and then Recover_J (abs W) <= 24)
   with Pre => abs W <= 3_652_424;

   function Pack (S : State_Type) return Word_Type is
     ((Word_Type (S.I) + 100 * Word_Type (S.J) + 10_000 * Word_Type (S.Skip)) * (if S.Carry = 1 then -1 else 1))
   with Post => Unpacks_Cleanly (Pack'Result) and then Unpack (Pack'Result) = S;

   function Unpack (W : Word_Type) return State_Type is
     ((Index_Type (Recover_I (abs W)),
       Index_Type (Recover_J (abs W)),
       Skip_Type (Recover_Skip (abs W)),
       Recover_Carry (W)))
   with Pre => Unpacks_Cleanly (W);

end Ranlux_State_Pkg;
