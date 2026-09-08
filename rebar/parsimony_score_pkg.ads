--  Canada le Brave
--
package Parsimony_Score_Pkg with SPARK_Mode is

   subtype Key is Integer range 1 .. 1000000;
   subtype List_Index is Integer range 1 .. 8;
   subtype Count is Integer range 0 .. 8;
   subtype Score_Value is Integer range -16 .. 8;

   type Key_List is array (List_Index) of Key;

   function Is_Member (K : Key; L : Key_List; N : Count) return Boolean
     with Post => Is_Member'Result = (for some I in 1 .. N => L (I) = K),
          Subprogram_Variant => (Decreases => N);

   function Is_Member (K : Key; L : Key_List; N : Count) return Boolean is
     (N > 0 and then (L (N) = K or else Is_Member (K, L, N - 1)));

   function Support (S : Key_List; NS : Count; Q : Key_List; NQ : Count) return Count
     with Post => Support'Result <= NS,
          Subprogram_Variant => (Decreases => NS);

   function Support (S : Key_List; NS : Count; Q : Key_List; NQ : Count) return Count is
     (if NS = 0 then 0
      else Support (S, NS - 1, Q, NQ) + (if Is_Member (S (NS), Q, NQ) then 1 else 0));

   function Conflict_Alt (S : Key_List; NS : Count; Q : Key_List; NQ : Count) return Count
     with Post => Conflict_Alt'Result = NS - Support (S, NS, Q, NQ),
          Subprogram_Variant => (Decreases => NS);

   function Conflict_Alt (S : Key_List; NS : Count; Q : Key_List; NQ : Count) return Count is
     (if NS = 0 then 0
      else Conflict_Alt (S, NS - 1, Q, NQ) + (if Is_Member (S (NS), Q, NQ) then 0 else 1));

   function Conflict_Ref (S : Key_List; NS : Count; Q : Key_List; NQ : Count) return Count
     with Post => Conflict_Ref'Result = NQ - Support (Q, NQ, S, NS),
          Subprogram_Variant => (Decreases => NQ);

   function Conflict_Ref (S : Key_List; NS : Count; Q : Key_List; NQ : Count) return Count is
     (if NQ = 0 then 0
      else Conflict_Ref (S, NS, Q, NQ - 1) + (if Is_Member (Q (NQ), S, NS) then 0 else 1));

   function Score (S : Key_List; NS : Count; Q : Key_List; NQ : Count) return Score_Value
     with Post => Score'Result <= Support (S, NS, Q, NQ)
                  and then Score'Result <= NS
                  and then Score'Result >= -(NS + NQ);

   function Score (S : Key_List; NS : Count; Q : Key_List; NQ : Count) return Score_Value is
     (Support (S, NS, Q, NQ) - Conflict_Ref (S, NS, Q, NQ) - Conflict_Alt (S, NS, Q, NQ));

   function Mutual_Containment_Scores_Full
     (S : Key_List; NS : Count; Q : Key_List; NQ : Count) return Boolean
     with Pre  => Support (S, NS, Q, NQ) = NS and then Support (Q, NQ, S, NS) = NQ,
          Post => Mutual_Containment_Scores_Full'Result;

   function Mutual_Containment_Scores_Full
     (S : Key_List; NS : Count; Q : Key_List; NQ : Count) return Boolean is
     (Score (S, NS, Q, NQ) = NS);

end Parsimony_Score_Pkg;
