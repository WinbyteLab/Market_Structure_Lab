#property script_show_inputs
#property strict

#include "../../include/SMC_ICT_Library.mqh"

input int InpBars = 1000;
input int InpSwingLeft = 2;
input int InpSwingRight = 2;

string SMC_ICT_StatusFor(const ENUM_SMC_ICT_ID id,
                         const ENUM_SMC_ICT_SUPPORT support,
                         const long fvg_bull,
                         const long fvg_bear,
                         const long swing_events,
                         const long close_breaks,
                         const long sweep_events,
                         long &event_count)
{
   event_count = -1; // -1 means not evaluated, never zero-filled for an absent detector
   switch(id)
   {
      case SMC_ICT_C001:
         event_count = swing_events;
         return "PIVOT_PRIMITIVES_ONLY_NOT_FULL_STRUCTURE";
      case SMC_ICT_C004:
         event_count = swing_events;
         return "STRICT_PIVOT_PRIMITIVE";
      case SMC_ICT_C007:
         event_count = close_breaks;
         return "CLOSE_BREAK_PROXY_NOT_FULL_BOS_CONTEXT";
      case SMC_ICT_C024:
         event_count = sweep_events;
         return "CLOSE_BACK_SWEEP_RULE";
      case SMC_ICT_C042:
         event_count = fvg_bull + fvg_bear;
         return "THREE_BAR_FVG_RULE";
      case SMC_ICT_C043:
         event_count = fvg_bull;
         return "BULLISH_FVG_ALIAS";
      case SMC_ICT_C044:
         event_count = fvg_bear;
         return "BEARISH_FVG_ALIAS";
   }

   if(support == SMC_ICT_SUPPORT_CONTEXT_ONLY) return "CONTEXT_ONLY";
   if(support == SMC_ICT_SUPPORT_EXTERNAL_DATA) return "EXTERNAL_DATA_REQUIRED";
   if(support == SMC_ICT_SUPPORT_MANUAL_REVIEW) return "MANUAL_REVIEW_REQUIRED";
   if(support == SMC_ICT_SUPPORT_COMBINATION) return "COMBINATION_NOT_IMPLEMENTED";
   if(support == SMC_ICT_SUPPORT_PRIMITIVE_AVAILABLE) return "PRIMITIVE_ONLY_NOT_FULL_CANDIDATE_DETECTOR";
   return "NOT_IMPLEMENTED";
}

void OnStart()
{
   if(InpBars != 1000 || InpSwingLeft < 1 || InpSwingRight < 1)
   {
      Print("SMC_ICT_1000BAR_TEST|FAIL|InpBars must be 1000 and swing widths must be positive");
      return;
   }

   if(SMC_ICT_CandidateCount() != SMC_ICT_CATALOG_COUNT || SMC_ICT_CandidateCount() != 126)
   {
      PrintFormat("SMC_ICT_1000BAR_TEST|FAIL|registry_count=%d|constant=%d", SMC_ICT_CandidateCount(), SMC_ICT_CATALOG_COUNT);
      return;
   }

   MqlRates bars[];
   ArraySetAsSeries(bars, false);
   ResetLastError();
   const int copied = CopyRates(_Symbol, _Period, 1, InpBars, bars); // start_pos=1: closed bars only
   if(copied != InpBars)
   {
      PrintFormat("SMC_ICT_1000BAR_TEST|FAIL|requested=%d|copied=%d|error=%d", InpBars, copied, GetLastError());
      return;
   }
   ArraySetAsSeries(bars, false); // library contract: index 0 is oldest

   long fvg_bull = 0;
   long fvg_bear = 0;
   long swing_highs = 0;
   long swing_lows = 0;
   long close_breaks = 0;
   long sweep_events = 0;
   bool has_swing_high = false;
   bool has_swing_low = false;
   double last_swing_high = 0.0;
   double last_swing_low = 0.0;

   for(int i = 2; i < copied; i++)
   {
      double gap_low = 0.0;
      double gap_high = 0.0;
      if(SMC_ICT_IsBullishFVG(bars[i - 2], bars[i - 1], bars[i], gap_low, gap_high)) fvg_bull++;
      if(SMC_ICT_IsBearishFVG(bars[i - 2], bars[i - 1], bars[i], gap_low, gap_high)) fvg_bear++;
   }

   for(int i = InpSwingLeft; i + InpSwingRight < copied; i++)
   {
      double pivot = 0.0;
      if(SMC_ICT_IsConfirmedSwingHigh(bars, i, InpSwingLeft, InpSwingRight, pivot)) swing_highs++;
      if(SMC_ICT_IsConfirmedSwingLow(bars, i, InpSwingLeft, InpSwingRight, pivot)) swing_lows++;
   }

   for(int i = 0; i < copied; i++)
   {
      const int newly_confirmed_pivot = i - InpSwingRight - 1;
      if(newly_confirmed_pivot >= InpSwingLeft)
      {
         double pivot = 0.0;
         if(SMC_ICT_IsConfirmedSwingHigh(bars, newly_confirmed_pivot, InpSwingLeft, InpSwingRight, pivot))
         {
            last_swing_high = pivot;
            has_swing_high = true;
         }
         if(SMC_ICT_IsConfirmedSwingLow(bars, newly_confirmed_pivot, InpSwingLeft, InpSwingRight, pivot))
         {
            last_swing_low = pivot;
            has_swing_low = true;
         }
      }
      if(i == 0) continue;

      if(has_swing_high)
      {
         if(SMC_ICT_IsCloseBreak(bars[i].close, last_swing_high, SMC_ICT_DIRECTION_BULLISH) &&
            bars[i - 1].close <= last_swing_high)
            close_breaks++;
         if(SMC_ICT_IsLiquiditySweep(bars[i], last_swing_high, SMC_ICT_SWEEP_BUY_SIDE))
            sweep_events++;
      }
      if(has_swing_low)
      {
         if(SMC_ICT_IsCloseBreak(bars[i].close, last_swing_low, SMC_ICT_DIRECTION_BEARISH) &&
            bars[i - 1].close >= last_swing_low)
            close_breaks++;
         if(SMC_ICT_IsLiquiditySweep(bars[i], last_swing_low, SMC_ICT_SWEEP_SELL_SIDE))
            sweep_events++;
      }
   }

   const long swing_events = swing_highs + swing_lows;
   const datetime first_time = bars[0].time;
   const datetime last_time = bars[copied - 1].time;
   PrintFormat("SMC_ICT_1000BAR_TEST|START|symbol=%s|period=%s|bars=%d|first=%s|last=%s|closed_only=true",
               _Symbol, EnumToString(_Period), copied,
               TimeToString(first_time, TIME_DATE|TIME_MINUTES), TimeToString(last_time, TIME_DATE|TIME_MINUTES));
   PrintFormat("SMC_ICT_PRIMITIVES|FVG_BULL=%I64d|FVG_BEAR=%I64d|SWING_H=%I64d|SWING_L=%I64d|CLOSE_BREAK=%I64d|SWEEP=%I64d",
               fvg_bull, fvg_bear, swing_highs, swing_lows, close_breaks, sweep_events);

   int resolved = 0;
   int evaluated = 0;
   int not_automated = 0;
   for(int value = 1; value <= SMC_ICT_CATALOG_COUNT; value++)
   {
      const ENUM_SMC_ICT_ID candidate_id = (ENUM_SMC_ICT_ID)value;
      SMC_ICT_Definition definition;
      if(!SMC_ICT_GetDefinition(candidate_id, definition))
      {
         PrintFormat("SMC_ICT_CANDIDATE|id=%03d|status=REGISTRY_ERROR", value);
         continue;
      }
      resolved++;
      long event_count = -1;
      const string status = SMC_ICT_StatusFor(candidate_id, definition.support, fvg_bull, fvg_bear,
                                               swing_events, close_breaks, sweep_events, event_count);
      if(event_count >= 0) evaluated++;
      else not_automated++;
      PrintFormat("SMC_ICT_CANDIDATE|%s|%s|%s|count=%I64d|type=%s|origin=%s",
                  definition.code, definition.term_en, status, event_count, definition.kind, definition.origin);
   }

   const bool passed = (copied == InpBars && resolved == SMC_ICT_CATALOG_COUNT);
   PrintFormat("SMC_ICT_1000BAR_TEST|SUMMARY|resolved=%d|catalog=%d|evaluated_primitives=%d|not_automated_or_contextual=%d|result=%s",
               resolved, SMC_ICT_CATALOG_COUNT, evaluated, not_automated, passed ? "PASS_COVERAGE_ONLY" : "FAIL");
   Print("SMC_ICT_1000BAR_TEST|NOTE|PASS_COVERAGE_ONLY does not mean all candidates have detectors; count=-1 means not evaluated.");
}
