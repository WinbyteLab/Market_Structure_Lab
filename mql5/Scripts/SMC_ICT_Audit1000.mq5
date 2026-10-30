#property strict
#property script_show_inputs

#include "../../include/SMC_ICT_Library.mqh"

input ENUM_TIMEFRAMES InpTimeframe = PERIOD_CURRENT;
input int             InpBars      = 1000;
input int             InpSwingLeft = 2;
input int             InpSwingRight = 2;

string SMC_ICT_SupportLabel(const ENUM_SMC_ICT_SUPPORT support)
{
   if(support == SMC_ICT_SUPPORT_PRIMITIVE_AVAILABLE) return "PRIMITIVE_ONLY_OR_PROXY";
   if(support == SMC_ICT_SUPPORT_COMBINATION) return "COMBINATION_PENDING";
   if(support == SMC_ICT_SUPPORT_CONTEXT_ONLY) return "CONTEXT_ONLY";
   if(support == SMC_ICT_SUPPORT_EXTERNAL_DATA) return "EXTERNAL_DATA_REQUIRED";
   if(support == SMC_ICT_SUPPORT_MANUAL_REVIEW) return "MANUAL_REVIEW";
   return "RULE_NOT_FORMALIZED";
}

void OnStart()
{
   if(InpBars < 3 || InpSwingLeft < 1 || InpSwingRight < 1)
   {
      Print("SMC_ICT_AUDIT_FAIL invalid input: bars>=3 and left/right>=1 are required");
      return;
   }

   MqlRates bars[];
   ArraySetAsSeries(bars, false);
   ResetLastError();
   const int copied = CopyRates(_Symbol, InpTimeframe, 1, InpBars, bars); // start_pos=1: closed bars only
   if(copied != InpBars)
   {
      PrintFormat("SMC_ICT_AUDIT_FAIL requested=%d copied=%d error=%d; no partial run reported as complete",
                  InpBars, copied, GetLastError());
      return;
   }
   ArraySetAsSeries(bars, false); // library contract: chronological oldest -> newest

   int event_count[SMC_ICT_CATALOG_COUNT];
   int bars_evaluated[SMC_ICT_CATALOG_COUNT];
   for(int i = 0; i < SMC_ICT_CATALOG_COUNT; i++)
   {
      event_count[i] = -1; // NA until a candidate-specific rule is actually evaluated
      bars_evaluated[i] = 0;
   }
   // Zero is meaningful only for the candidate rules executed by this audit.
   event_count[SMC_ICT_C001 - 1] = 0;
   event_count[SMC_ICT_C002 - 1] = 0;
   event_count[SMC_ICT_C004 - 1] = 0;
   event_count[SMC_ICT_C007 - 1] = 0;
   event_count[SMC_ICT_C024 - 1] = 0;
   event_count[SMC_ICT_C042 - 1] = 0;
   event_count[SMC_ICT_C043 - 1] = 0;
   event_count[SMC_ICT_C044 - 1] = 0;

   bool has_swing_high = false;
   bool has_swing_low = false;
   double last_swing_high = 0.0;
   double last_swing_low = 0.0;
   double prior_swing_high = 0.0;
   double prior_swing_low = 0.0;
   bool has_prior_swing_high = false;
   bool has_prior_swing_low = false;
   int high_state = 0;
   int low_state = 0;
   int trend_state = 0;

   for(int i = 0; i < copied; i++)
   {
      const int pivot_index = i - InpSwingRight - 1; // only pivots confirmed before the current bar
      if(pivot_index >= InpSwingLeft)
      {
         double pivot = 0.0;
         if(SMC_ICT_IsConfirmedSwingHigh(bars, pivot_index, InpSwingLeft, InpSwingRight, pivot))
         {
            if(has_prior_swing_high)
               high_state = (pivot > prior_swing_high ? 1 : (pivot < prior_swing_high ? -1 : 0));
            prior_swing_high = pivot;
            has_prior_swing_high = true;
            last_swing_high = pivot;
            has_swing_high = true;
            event_count[SMC_ICT_C001 - 1]++;
            event_count[SMC_ICT_C004 - 1]++;
         }
         if(SMC_ICT_IsConfirmedSwingLow(bars, pivot_index, InpSwingLeft, InpSwingRight, pivot))
         {
            if(has_prior_swing_low)
               low_state = (pivot > prior_swing_low ? 1 : (pivot < prior_swing_low ? -1 : 0));
            prior_swing_low = pivot;
            has_prior_swing_low = true;
            last_swing_low = pivot;
            has_swing_low = true;
            event_count[SMC_ICT_C001 - 1]++;
            event_count[SMC_ICT_C004 - 1]++;
         }

         int next_trend_state = 0;
         if(high_state == 1 && low_state == 1)
            next_trend_state = 1;
         else if(high_state == -1 && low_state == -1)
            next_trend_state = -1;
         if(next_trend_state != 0 && next_trend_state != trend_state)
            event_count[SMC_ICT_C002 - 1]++;
         if(next_trend_state != 0)
            trend_state = next_trend_state;
      }

      if(i >= 2)
      {
         double gap_low = 0.0;
         double gap_high = 0.0;
         if(SMC_ICT_IsBullishFVG(bars[i - 2], bars[i - 1], bars[i], gap_low, gap_high))
         {
            event_count[SMC_ICT_C042 - 1]++;
            event_count[SMC_ICT_C043 - 1]++;
         }
         if(SMC_ICT_IsBearishFVG(bars[i - 2], bars[i - 1], bars[i], gap_low, gap_high))
         {
            event_count[SMC_ICT_C042 - 1]++;
            event_count[SMC_ICT_C044 - 1]++;
         }
      }

      if(i > 0)
      {
         if(has_swing_high && bars[i - 1].close <= last_swing_high &&
            SMC_ICT_IsCloseBreak(bars[i].close, last_swing_high, SMC_ICT_DIRECTION_BULLISH))
            event_count[SMC_ICT_C007 - 1]++;
         if(has_swing_low && bars[i - 1].close >= last_swing_low &&
            SMC_ICT_IsCloseBreak(bars[i].close, last_swing_low, SMC_ICT_DIRECTION_BEARISH))
            event_count[SMC_ICT_C007 - 1]++;

         if(has_swing_high && SMC_ICT_IsLiquiditySweep(bars[i], last_swing_high, SMC_ICT_SWEEP_BUY_SIDE))
            event_count[SMC_ICT_C024 - 1]++;
         if(has_swing_low && SMC_ICT_IsLiquiditySweep(bars[i], last_swing_low, SMC_ICT_SWEEP_SELL_SIDE))
            event_count[SMC_ICT_C024 - 1]++;
      }
   }

   for(int value = 1; value <= SMC_ICT_CATALOG_COUNT; value++)
   {
      const ENUM_SMC_ICT_ID candidate_id = (ENUM_SMC_ICT_ID)value;
      SMC_ICT_Definition definition;
      if(!SMC_ICT_GetDefinition(candidate_id, definition))
      {
         PrintFormat("SMC_ICT_AUDIT_ROW_FAIL id=%d registry_lookup_failed", value);
         continue;
      }
      const int slot = value - 1;
      if(definition.support == SMC_ICT_SUPPORT_PRIMITIVE_AVAILABLE && event_count[slot] >= 0)
         bars_evaluated[slot] = copied;
      const string event_text = (event_count[slot] < 0 ? "NA" : IntegerToString(event_count[slot]));
      PrintFormat("SMC_ICT_AUDIT_ROW,%s,%s,%s,bars_evaluated=%d,events=%s",
                  definition.code, definition.term_en, SMC_ICT_SupportLabel(definition.support),
                  bars_evaluated[slot], event_text);
   }

   int primitive_candidates = 0;
   int evaluated_candidates = 0;
   int skipped_candidates = 0;
   for(int value = 1; value <= SMC_ICT_CATALOG_COUNT; value++)
   {
      SMC_ICT_Definition definition;
      if(!SMC_ICT_GetDefinition((ENUM_SMC_ICT_ID)value, definition))
         continue;
      if(definition.support == SMC_ICT_SUPPORT_PRIMITIVE_AVAILABLE)
      {
         primitive_candidates++;
         if(bars_evaluated[value - 1] == copied)
            evaluated_candidates++;
      }
      else
         skipped_candidates++;
   }

   PrintFormat("SMC_ICT_AUDIT_SUMMARY symbol=%s timeframe=%s requested=%d closed_bars=%d candidates=%d primitive=%d evaluated=%d skipped=%d orders=none",
               _Symbol, EnumToString(InpTimeframe), InpBars, copied, SMC_ICT_CATALOG_COUNT,
               primitive_candidates, evaluated_candidates, skipped_candidates);
   Comment("SMC/ICT audit finished. See Experts log. Tested primitives: ", evaluated_candidates,
           "/", SMC_ICT_CATALOG_COUNT, "; skipped/context/manual/external: ", skipped_candidates,
           ". No orders sent.");
}
