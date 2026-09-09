--  Canada le Brave
--
package Road_Grid_Levels_Pkg with SPARK_Mode is

   subtype Half_Step is Integer range 1 .. 1000;
   subtype Level_Index is Integer range 0 .. 201;
   subtype Level is Integer range 1 .. 201;
   subtype Level_Count is Integer range 0 .. 200;
   subtype Depth is Integer range 0 .. 402000;

   function Flux_Depth (J : Level_Index; H : Half_Step) return Depth is
     (2 * J * H);

   function Temperature_Depth (J : Level; H : Half_Step) return Depth is
     ((2 * J - 1) * H);

   function Levels_Within (D : Depth; H : Half_Step) return Level_Count
     with Pre  => D <= 400 * H,
          Post => Flux_Depth (Levels_Within'Result, H) <= D
                  and then Flux_Depth (Levels_Within'Result + 1, H) > D;

   function Levels_Within (D : Depth; H : Half_Step) return Level_Count is
     (D / (2 * H));

   function Levels_Above_Sensor (D : Depth; H : Half_Step) return Level_Count
     with Pre  => D <= 400 * H,
          Post => (Levels_Above_Sensor'Result = 0
                   or else Temperature_Depth (Levels_Above_Sensor'Result, H) <= D)
                  and then Temperature_Depth (Levels_Above_Sensor'Result + 1, H) > D;

   function Levels_Above_Sensor (D : Depth; H : Half_Step) return Level_Count is
     ((D / H + 1) / 2);

end Road_Grid_Levels_Pkg;
