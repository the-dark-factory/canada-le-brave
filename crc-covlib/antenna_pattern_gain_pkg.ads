--  Canada le Brave
--
package Antenna_Pattern_Gain_Pkg with SPARK_Mode is

   subtype Extended_Azimuth is Integer range -3600 .. 7199;
   subtype Gain is Integer range -1000 .. 1000;

   function Interpolated_Gain
     (A : Extended_Azimuth; G1 : Gain; A1 : Extended_Azimuth;
      G2 : Gain; A2 : Extended_Azimuth) return Gain
     with Pre  => A1 < A2 and then A >= A1 and then A <= A2,
          Post => Interpolated_Gain'Result >= Integer'Min (G1, G2)
                  and then Interpolated_Gain'Result <= Integer'Max (G1, G2);

   function Interpolated_Gain
     (A : Extended_Azimuth; G1 : Gain; A1 : Extended_Azimuth;
      G2 : Gain; A2 : Extended_Azimuth) return Gain is
     (G1 + ((A - A1) * (G2 - G1)) / (A2 - A1));

   function Starts_At_First
     (G1 : Gain; A1 : Extended_Azimuth; G2 : Gain; A2 : Extended_Azimuth)
      return Boolean
     with Pre  => A1 < A2,
          Post => Starts_At_First'Result;

   function Starts_At_First
     (G1 : Gain; A1 : Extended_Azimuth; G2 : Gain; A2 : Extended_Azimuth)
      return Boolean is
     (Interpolated_Gain (A1, G1, A1, G2, A2) = G1);

   function Ends_At_Second
     (G1 : Gain; A1 : Extended_Azimuth; G2 : Gain; A2 : Extended_Azimuth)
      return Boolean
     with Pre  => A1 < A2,
          Post => Ends_At_Second'Result;

   function Ends_At_Second
     (G1 : Gain; A1 : Extended_Azimuth; G2 : Gain; A2 : Extended_Azimuth)
      return Boolean is
     (Interpolated_Gain (A2, G1, A1, G2, A2) = G2);

end Antenna_Pattern_Gain_Pkg;
