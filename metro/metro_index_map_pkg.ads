--  Canada le Brave
--
package Metro_Index_Map_Pkg with SPARK_Mode is

   subtype Num_Columns_Type is Natural range 1 .. 1000;
   subtype Row_Number_Type is Natural range 0 .. 1000;
   subtype Column_Number_Type is Natural range 0 .. 999;
   subtype Flat_Position_Type is Natural range 0 .. 1000000;

   function Flat_Position (Row : Row_Number_Type; Column : Column_Number_Type; Num_Columns : Num_Columns_Type) return Flat_Position_Type
     with Pre  => (Column < Num_Columns and then Row * Num_Columns + Column <= 1000000),
          Post => (Flat_Position'Result / Num_Columns = Row and then Flat_Position'Result mod Num_Columns = Column);

   function Flat_Position (Row : Row_Number_Type; Column : Column_Number_Type; Num_Columns : Num_Columns_Type) return Flat_Position_Type is
     (Row * Num_Columns + Column);

   function Column_Of (Position : Flat_Position_Type; Num_Columns : Num_Columns_Type) return Column_Number_Type
     with Post => (Column_Of'Result < Num_Columns);

   function Column_Of (Position : Flat_Position_Type; Num_Columns : Num_Columns_Type) return Column_Number_Type is
     (Position mod Num_Columns);

   function Row_Of (Position : Flat_Position_Type; Num_Columns : Num_Columns_Type) return Row_Number_Type
     with Pre  => (Position / Num_Columns <= 1000),
          Post => (Flat_Position (Row_Of'Result, Column_Of (Position, Num_Columns), Num_Columns) = Position);

   function Row_Of (Position : Flat_Position_Type; Num_Columns : Num_Columns_Type) return Row_Number_Type is
     (Position / Num_Columns);

end Metro_Index_Map_Pkg;
