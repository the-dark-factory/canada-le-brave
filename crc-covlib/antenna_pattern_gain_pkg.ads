--  Canada le Brave
--
package Antenna_Pattern_Gain_Pkg with SPARK_Mode is

   subtype Pattern_Azimuth is Integer range 0 .. 3599;
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

   function Wrap_Below_Catches
     (A : Pattern_Azimuth; First : Pattern_Azimuth; Last : Pattern_Azimuth)
     return Boolean
     with Pre  => First <= Last and then A < First,
          Post => Wrap_Below_Catches'Result;

   function Wrap_Below_Catches
     (A : Pattern_Azimuth; First : Pattern_Azimuth; Last : Pattern_Azimuth)
     return Boolean is
     (A >= Last - 3600 and then A <= First);

   function Wrap_Above_Catches
     (A : Pattern_Azimuth; First : Pattern_Azimuth; Last : Pattern_Azimuth)
     return Boolean
     with Pre  => First <= Last and then A >= Last,
          Post => Wrap_Above_Catches'Result;

   function Wrap_Above_Catches
     (A : Pattern_Azimuth; First : Pattern_Azimuth; Last : Pattern_Azimuth)
     return Boolean is
     (A >= Last and then A <= First + 3600);

end Antenna_Pattern_Gain_Pkg;
