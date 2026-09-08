--  Canada le Brave
--
package Bit_Field_Packing_Pkg with SPARK_Mode is

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

   function Field_Fits (Lengths : Length_Array; Count : Field_Index; Pos : Field_Index) return Boolean
     with Pre => Count >= 1 and then Pos in 1 .. Count;

   function Field_Fits (Lengths : Length_Array; Count : Field_Index; Pos : Field_Index) return Boolean is
     (Shift_Of (Lengths, Count, Pos) + Running_Total (Lengths (Pos)) <= 64);

   function Suffix_Monotone (L : Length_Array; Count : Field_Index; P : Walk_Position; Q : Walk_Position) return Boolean
     with Pre => Count >= 1 and then P in 1 .. Count + 1 and then Q in P .. Count + 1,
          Post => Suffix_Monotone'Result
                 and then Suffix_Total (L, Count, P) >= Suffix_Total (L, Count, Q),
          Subprogram_Variant => (Decreases => Q - P);

   function Suffix_Monotone (L : Length_Array; Count : Field_Index; P : Walk_Position; Q : Walk_Position) return Boolean is
     (if P = Q then True else Suffix_Monotone (L, Count, P + 1, Q));

   function Packed_Flush (L : Length_Array; Count : Field_Index) return Boolean
     with Pre => Count >= 1,
          Post => Packed_Flush'Result;

   function Packed_Flush (L : Length_Array; Count : Field_Index) return Boolean is
     (for all Pos in Field_Index range 1 .. Count - 1 =>
       Shift_Of (L, Count, Pos) = Shift_Of (L, Count, Pos + 1) + Running_Total (L (Pos + 1)));

   function No_Overlap (L : Length_Array; Count : Field_Index) return Boolean
     with Pre => Count >= 1,
          Post => No_Overlap'Result;

   function No_Overlap (L : Length_Array; Count : Field_Index) return Boolean is
     (for all P1 in Field_Index range 1 .. Count - 1 =>
       (for all P2 in Field_Index range P1 + 1 .. Count =>
          Suffix_Monotone (L, Count, P1 + 1, P2)
          and then Shift_Of (L, Count, P1) >= Shift_Of (L, Count, P2) + Running_Total (L (P2))));

   function Every_Field_Fits_When_Total_Fits (L : Length_Array; Count : Field_Index) return Boolean
     with Pre => Count >= 1 and then Suffix_Total (L, Count, 1) <= 64,
          Post => Every_Field_Fits_When_Total_Fits'Result;

   function Every_Field_Fits_When_Total_Fits (L : Length_Array; Count : Field_Index) return Boolean is
     (for all Pos in Field_Index range 1 .. Count =>
       Suffix_Monotone (L, Count, 1, Pos) and then Field_Fits (L, Count, Pos));

end Bit_Field_Packing_Pkg;
