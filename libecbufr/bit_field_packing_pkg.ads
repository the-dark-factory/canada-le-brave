package Bit_Field_Packing_Pkg with SPARK_Mode is

   subtype Field_Length is Natural range 1 .. 63;
   subtype Field_Index is Natural range 1 .. 8;
   subtype Walk_Position is Natural range 1 .. 9;
   subtype Running_Total is Natural range 0 .. 504;

   type Length_Array is array (Field_Index) of Field_Length;

   function Suffix_Total (Lengths : Length_Array; Count : Field_Index; Pos : Walk_Position) return Running_Total with
     Pre => Count >= 1 and then Pos in 1 .. Count + 1,
     Post => Suffix_Total'Result <= 63 * (Count + 1 - Pos),
     Subprogram_Variant => (Decreases => Count + 1 - Pos);

   function Suffix_Total (Lengths : Length_Array; Count : Field_Index; Pos : Walk_Position) return Running_Total is
     (if Pos > Count then 0 else Running_Total (Lengths (Pos)) + Suffix_Total (Lengths, Count, Pos + 1));

   function Shift_Of (Lengths : Length_Array; Count : Field_Index; Pos : Field_Index) return Running_Total with
     Pre => Count >= 1 and then Pos in 1 .. Count;

   function Shift_Of (Lengths : Length_Array; Count : Field_Index; Pos : Field_Index) return Running_Total is
     (Suffix_Total (Lengths, Count, Walk_Position (Pos + 1)));

   function Field_Fits (Lengths : Length_Array; Count : Field_Index; Pos : Field_Index) return Boolean with
     Pre => Count >= 1 and then Pos in 1 .. Count;

   function Field_Fits (Lengths : Length_Array; Count : Field_Index; Pos : Field_Index) return Boolean is
     (Shift_Of (Lengths, Count, Pos) + Running_Total (Lengths (Pos)) <= 64);

   function Packed_Flush (Lengths : Length_Array; Count : Field_Index) return Boolean with
     Pre => Count >= 1,
     Post => Packed_Flush'Result;

   function Packed_Flush (Lengths : Length_Array; Count : Field_Index) return Boolean is
     (for all Pos in Field_Index range 1 .. Count - 1 =>
        Shift_Of (Lengths, Count, Pos) = Shift_Of (Lengths, Count, Pos + 1) + Running_Total (Lengths (Pos + 1)));

   function Fits_When_Suffix_Fits (Lengths : Length_Array; Count : Field_Index; Pos : Field_Index) return Boolean with
     Pre => Count >= 1 and then Pos in 1 .. Count,
     Post => Fits_When_Suffix_Fits'Result;

   function Fits_When_Suffix_Fits (Lengths : Length_Array; Count : Field_Index; Pos : Field_Index) return Boolean is
     (Field_Fits (Lengths, Count, Pos) = (Suffix_Total (Lengths, Count, Pos) <= 64));

end Bit_Field_Packing_Pkg;
