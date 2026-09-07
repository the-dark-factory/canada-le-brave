--  Canada le Brave
--
package Crc_P2108_Guard_Pkg with SPARK_Mode is

   subtype Location_Percentage_Millionths is Natural range 0 .. 100_000_000;

   subtype Distance_Metres is Natural range 0 .. 1_000_000;

   subtype Frequency_Megahertz is Natural range 0 .. 100_000;

   function Storable (Value : Location_Percentage_Millionths) return Boolean with
     Pre => Value >= 0,
     Post => (if Storable'Result then Value in 1 .. 99_999_999);

   function Next_Stored_Value (Current, Proposed : Location_Percentage_Millionths) return Location_Percentage_Millionths with
     Pre => Current >= 0 and Proposed >= 0,
     Post => (if Proposed in 1 .. 99_999_999 then Next_Stored_Value'Result = Proposed else Next_Stored_Value'Result = Current);

   function In_Domain (Dist : Distance_Metres; Freq : Frequency_Megahertz) return Boolean with
     Pre => Dist >= 0 and Freq >= 0,
     Post => In_Domain'Result = ((Dist >= 250) and (Freq >= 500) and (Freq <= 67_000));

   function Storable (Value : Location_Percentage_Millionths) return Boolean is
     (Value >= 1 and Value <= 99_999_999);

   function Next_Stored_Value (Current, Proposed : Location_Percentage_Millionths) return Location_Percentage_Millionths is
     (if Storable (Proposed) then Proposed else Current);

   function In_Domain (Dist : Distance_Metres; Freq : Frequency_Megahertz) return Boolean is
     ((Dist >= 250) and (Freq >= 500) and (Freq <= 67_000));

end Crc_P2108_Guard_Pkg;
