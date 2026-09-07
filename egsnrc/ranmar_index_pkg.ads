--  Canada le Brave
--
package Ranmar_Index_Pkg with SPARK_Mode is

   type Position_Type is range 0 .. 97;

   type State is record
      I : Position_Type;
      J : Position_Type;
   end record;

   function Well_Formed (S : State) return Boolean is
     ((S.J - S.I) mod 97 = 33 and S.I in 1 .. 97 and S.J in 1 .. 97);

   function Init return State is
     ((97, 33))
     with Post => Well_Formed (Init'Result);

   function Step (S : State) return State is
     (if S.I = 0 then (97, S.J) else (if S.J = 0 then (S.I, 97) else (S.I, S.J)))
     with Pre => Well_Formed (S), Post => Well_Formed (Step'Result) and Step'Result.I /= 0 and Step'Result.J /= 0;

end Ranmar_Index_Pkg;
