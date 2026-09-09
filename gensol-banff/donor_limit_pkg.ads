--  Canada le Brave
--
package Donor_Limit_Pkg with SPARK_Mode is

   subtype Count is Integer range 0 .. 30000;
   subtype Positive_Count is Integer range 1 .. 30000;
   subtype Multiplier_Hundredths is Integer range 0 .. 10000;
   subtype Percent is Integer range 0 .. 100;
   subtype Limit_Value is Integer range 0 .. 3000100;

   function Ceiling_Ratio (R : Count; D : Positive_Count) return Count
     with Post => Ceiling_Ratio'Result * D >= R
                  and then (Ceiling_Ratio'Result = 0
                            or else (Ceiling_Ratio'Result - 1) * D < R);

   function Ceiling_Ratio (R : Count; D : Positive_Count) return Count is
     ((R + D - 1) / D);

   function Scaled_Ceiling (M : Multiplier_Hundredths; C : Count) return Limit_Value
     with Post => Scaled_Ceiling'Result * 100 >= M * C
                  and then (Scaled_Ceiling'Result = 0
                            or else (Scaled_Ceiling'Result - 1) * 100 < M * C);

   function Scaled_Ceiling (M : Multiplier_Hundredths; C : Count) return Limit_Value is
     ((M * C + 99) / 100);

   function Donor_Limit
     (Has_N : Boolean; N : Positive_Count; Has_M : Boolean;
      M : Multiplier_Hundredths; R : Count; D : Positive_Count) return Limit_Value
     with Post => Donor_Limit'Result >= 1
                  and then (not Has_N or else Donor_Limit'Result >= N)
                  and then (not Has_M
                            or else Donor_Limit'Result >= Scaled_Ceiling (M, Ceiling_Ratio (R, D)));

   function Donor_Limit
     (Has_N : Boolean; N : Positive_Count; Has_M : Boolean;
      M : Multiplier_Hundredths; R : Count; D : Positive_Count) return Limit_Value is
     (if not Has_N and then not Has_M then Limit_Value'Last
      else Integer'Max ((if Has_N then N else 1),
                        (if Has_M then Scaled_Ceiling (M, Ceiling_Ratio (R, D)) else 0)));

   function Limit_Covers_Recipients
     (M : Multiplier_Hundredths; R : Count; D : Positive_Count) return Boolean
     with Pre  => M >= 100,
          Post => Limit_Covers_Recipients'Result;

   function Limit_Covers_Recipients
     (M : Multiplier_Hundredths; R : Count; D : Positive_Count) return Boolean is
     (Scaled_Ceiling (M, Ceiling_Ratio (R, D)) >= Ceiling_Ratio (R, D));

   function Enough_Donors
     (Resp : Positive_Count; Rec : Count; Min_D : Count; Min_P : Percent) return Boolean
     with Pre  => Rec <= Resp,
          Post => (not Enough_Donors'Result or else Resp - Rec >= Min_D);

   function Enough_Donors
     (Resp : Positive_Count; Rec : Count; Min_D : Count; Min_P : Percent) return Boolean is
     (Resp - Rec >= Min_D and then (Resp - Rec) * 100 >= Min_P * Resp);

   function More_Respondents_Never_Hurt
     (Resp : Positive_Count; Rec : Count; Min_D : Count; Min_P : Percent) return Boolean
     with Pre  => Rec <= Resp and then Resp < Positive_Count'Last,
          Post => More_Respondents_Never_Hurt'Result;

   function More_Respondents_Never_Hurt
     (Resp : Positive_Count; Rec : Count; Min_D : Count; Min_P : Percent) return Boolean is
     (not Enough_Donors (Resp, Rec, Min_D, Min_P)
      or else Enough_Donors (Resp + 1, Rec, Min_D, Min_P));

end Donor_Limit_Pkg;
