--  Canada le Brave
--
package Ranmar_Init_Pkg with SPARK_Mode is

   type Total_Type is range 0 .. 16_777_215;
   type Place_Type is range 0 .. 8_388_608;
   type Wide_Type is range 0 .. 100_000_000;

   type Accum_Type is record
      Total : Total_Type;
      Place : Place_Type;
   end record;

   function Is_Well_Formed (S : Accum_Type) return Boolean is
     (Wide_Type (S.Total) + 2 * Wide_Type (S.Place) <= 16_777_216);

   function Init_State return Accum_Type is
     ((Total => 0, Place => 8_388_608))
     with Post => Is_Well_Formed (Init_State'Result);

   function Step (S : Accum_Type; Bit_Set : Boolean) return Accum_Type is
     (((if Bit_Set then Total_Type (Wide_Type (S.Total) + Wide_Type (S.Place)) else S.Total),
       S.Place / 2))
     with Pre => Is_Well_Formed (S),
          Post => Is_Well_Formed (Step'Result) and then Step'Result.Total <= 16_777_215;

   function Get_Total (S : Accum_Type) return Total_Type is
     (S.Total);

end Ranmar_Init_Pkg;
