--  Canada le Brave
--
package Road_Grid_Levels_Pkg with SPARK_Mode is

   subtype Half_Step is Integer range 1 .. 1000;
   subtype Level is Integer range 1 .. 200;
   subtype Level_Count is Integer range 0 .. 200;
   subtype Depth is Integer range 0 .. 400000;

   function Flux_Depth (J : Level_Count; H : Half_Step) return Depth
     with Post => Flux_Depth'Result >= 2 * J
                  and then Flux_Depth'Result <= 2000 * J;

   function Flux_Depth (J : Level_Count; H : Half_Step) return Depth is
     (2 * J * H);

   function Temperature_Depth (J : Level; H : Half_Step) return Depth
     with Post => Temperature_Depth'Result >= J
                  and then Temperature_Depth'Result <= 2000 * J;

   function Temperature_Depth (J : Level; H : Half_Step) return Depth is
     ((2 * J - 1) * H);

   function Interleaved (J : Level; H : Half_Step) return Boolean
     with Post => Interleaved'Result;

   function Interleaved (J : Level; H : Half_Step) return Boolean is
     (Temperature_Depth (J, H) > Flux_Depth (J - 1, H)
      and then Temperature_Depth (J, H) < Flux_Depth (J, H));

   function Is_Midpoint (J : Level; H : Half_Step) return Boolean
     with Post => Is_Midpoint'Result;

   function Is_Midpoint (J : Level; H : Half_Step) return Boolean is
     (2 * Temperature_Depth (J, H) = Flux_Depth (J - 1, H) + Flux_Depth (J, H));

   function Levels_Within (D : Depth; H : Half_Step) return Level_Count
     with Pre  => D <= 400 * H,
          Post => Flux_Depth (Levels_Within'Result, H) <= D
                  and then (Levels_Within'Result = 200
                            or else Flux_Depth (Levels_Within'Result + 1, H) > D);

   function Levels_Within (D : Depth; H : Half_Step) return Level_Count is
     (D / (2 * H));

   function Levels_Above_Sensor (D : Depth; H : Half_Step) return Level_Count
     with Pre  => D <= 400 * H,
          Post => (Levels_Above_Sensor'Result = 0
                   or else Temperature_Depth (Levels_Above_Sensor'Result, H) <= D)
                  and then (Levels_Above_Sensor'Result = 200
                            or else Temperature_Depth (Levels_Above_Sensor'Result + 1, H) > D);

   function Levels_Above_Sensor (D : Depth; H : Half_Step) return Level_Count is
     ((D / H + 1) / 2);

end Road_Grid_Levels_Pkg;
