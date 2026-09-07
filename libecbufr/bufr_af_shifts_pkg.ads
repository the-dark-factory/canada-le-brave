--  Canada le Brave
--
package Bufr_Af_Shifts_Pkg with SPARK_Mode is

   subtype Bit_Count is Natural range 0 .. 64;
   subtype Field_Length is Natural range 1 .. 63;
   subtype Field_Index is Natural range 1 .. 8;
   subtype Walk_Position is Natural range 1 .. 9;
   subtype Running_Total is Natural range 0 .. 504;

   type Length_Array is array (Field_Index) of Field_Length;

   function Suffix_Total (Lengths : Length_Array; Count : Field_Index; Pos : Walk_Position) return Running_Total
     with Pre => Count >= 1 and then Pos in 1 .. Count + 1,
          Post => Suffix_Total'Result <= 63 * (Count + 1 - Pos),
          Subprogram_Variant => (Decreases => Count + 1 - Pos);

   function Suffix_Total (Lengths : Length_Array; Count : Field_Index; Pos : Walk_Position) return Running_Total is
     (if Pos > Count then 0 else Running_Total (Lengths (Pos)) + Suffix_Total (Lengths, Count, Pos + 1));

   function Shift_Of (Lengths : Length_Array; Count : Field_Index; Pos : Field_Index) return Running_Total
     with Pre => Count >= 1 and then Pos in 1 .. Count;

   function Shift_Of (Lengths : Length_Array; Count : Field_Index; Pos : Field_Index) return Running_Total is
     (Suffix_Total (Lengths, Count, Walk_Position (Pos + 1)));

   function Total_Len (Lengths : Length_Array; Count : Field_Index) return Running_Total
     with Pre => Count >= 1;

   function Total_Len (Lengths : Length_Array; Count : Field_Index) return Running_Total is
     (Suffix_Total (Lengths, Count, 1));

   function Field_Fits (Lengths : Length_Array; Count : Field_Index; Pos : Field_Index) return Boolean
     with Pre => Count >= 1 and then Pos in 1 .. Count;

   function Field_Fits (Lengths : Length_Array; Count : Field_Index; Pos : Field_Index) return Boolean is
     (Shift_Of (Lengths, Count, Pos) + Running_Total (Lengths (Pos)) <= 64);

   function Every_Field_Fits (Lengths : Length_Array; Count : Field_Index) return Boolean
     with Pre => Count >= 1;

   function Every_Field_Fits (Lengths : Length_Array; Count : Field_Index) return Boolean is
     ((for all Pos in Field_Index range 1 .. Count => Field_Fits (Lengths, Count, Pos)));

   function No_Overlap (Lengths : Length_Array; Count : Field_Index) return Boolean
     with Pre => Count >= 1;

   function No_Overlap (Lengths : Length_Array; Count : Field_Index) return Boolean is
     ((for all P1 in Field_Index range 1 .. Count - 1 =>
        (for all P2 in Field_Index range P1 + 1 .. Count =>
           Shift_Of (Lengths, Count, P1) >= Shift_Of (Lengths, Count, P2) + Running_Total (Lengths (P2)))));

   function Exactly_Packed (Lengths : Length_Array; Count : Field_Index) return Boolean
     with Pre => Count >= 1;

   function Exactly_Packed (Lengths : Length_Array; Count : Field_Index) return Boolean is
     ((for all Pos in Field_Index range 1 .. Count - 1 =>
        Shift_Of (Lengths, Count, Pos) = Shift_Of (Lengths, Count, Pos + 1) + Running_Total (Lengths (Pos + 1))));

end Bufr_Af_Shifts_Pkg;
