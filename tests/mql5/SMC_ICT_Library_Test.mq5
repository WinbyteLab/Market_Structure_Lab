#property script_show_inputs
#property strict

#include "../../include/SMC_ICT_Library.mqh"

void Check(const bool condition, const string name, int &passed, int &failed)
{
   if(condition)
   {
      passed++;
      Print("PASS: ", name);
   }
   else
   {
      failed++;
      Print("FAIL: ", name);
   }
}

void OnStart()
{
   int passed = 0;
   int failed = 0;
   Check(SMC_ICT_CandidateCount() == 126, "catalog count", passed, failed);

   SMC_ICT_Definition definition;
   int mapped = 0;
   for(int value = 1; value <= SMC_ICT_CATALOG_COUNT; value++)
   {
      const ENUM_SMC_ICT_ID candidate_id = (ENUM_SMC_ICT_ID)value;
      if(SMC_ICT_GetDefinition(candidate_id, definition))
         mapped++;
   }
   Check(mapped == SMC_ICT_CATALOG_COUNT, "all catalog IDs resolve", passed, failed);

   Check(SMC_ICT_GetDefinition(SMC_ICT_C017, definition) && definition.support == SMC_ICT_SUPPORT_CONTEXT_ONLY,
         "institutional order flow is contextual", passed, failed);
   Check(SMC_ICT_GetDefinition(SMC_ICT_C040, definition) && definition.support == SMC_ICT_SUPPORT_MANUAL_REVIEW,
         "discovery-only item is manual review", passed, failed);
   Check(SMC_ICT_GetDefinition(SMC_ICT_C102, definition) && definition.support == SMC_ICT_SUPPORT_EXTERNAL_DATA,
         "COT filter requires external data", passed, failed);
   Check(SMC_ICT_GetDefinition(SMC_ICT_C118, definition) && definition.support == SMC_ICT_SUPPORT_COMBINATION,
         "composite setup is not a primitive detector", passed, failed);

   MqlRates up[3];
   up[0].open = 100.0; up[0].high = 102.0; up[0].low = 99.0; up[0].close = 101.0;
   up[1].open = 102.0; up[1].high = 105.0; up[1].low = 101.0; up[1].close = 104.0;
   up[2].open = 104.0; up[2].high = 107.0; up[2].low = 103.0; up[2].close = 106.0;
   double gap_low = 0.0;
   double gap_high = 0.0;
   const bool bullish_gap = SMC_ICT_IsBullishFVG(up[0], up[1], up[2], gap_low, gap_high);
   Check(bullish_gap && gap_low == 102.0 && gap_high == 103.0, "bullish three-bar FVG", passed, failed);

   MqlRates down[3];
   down[0].open = 102.0; down[0].high = 104.0; down[0].low = 100.0; down[0].close = 101.0;
   down[1].open = 101.0; down[1].high = 102.0; down[1].low = 98.0; down[1].close = 99.0;
   down[2].open = 97.0; down[2].high = 99.0; down[2].low = 96.0; down[2].close = 98.0;
   const bool bearish_gap = SMC_ICT_IsBearishFVG(down[0], down[1], down[2], gap_low, gap_high);
   Check(bearish_gap && gap_low == 99.0 && gap_high == 100.0, "bearish three-bar FVG", passed, failed);

   MqlRates sweep;
   sweep.open = 102.0; sweep.high = 105.0; sweep.low = 100.0; sweep.close = 103.0;
   Check(SMC_ICT_IsLiquiditySweep(sweep, 104.0, SMC_ICT_SWEEP_BUY_SIDE),
         "buy-side sweep closes back below level", passed, failed);
   sweep.open = 98.0; sweep.high = 100.0; sweep.low = 95.0; sweep.close = 97.0;
   Check(SMC_ICT_IsLiquiditySweep(sweep, 96.0, SMC_ICT_SWEEP_SELL_SIDE),
         "sell-side sweep closes back above level", passed, failed);

   Check(SMC_ICT_IsCloseBreak(101.0, 100.0, SMC_ICT_DIRECTION_BULLISH),
         "bullish close break", passed, failed);
   Check(SMC_ICT_IsCloseBreak(99.0, 100.0, SMC_ICT_DIRECTION_BEARISH),
         "bearish close break", passed, failed);

   MqlRates pivots[5];
   pivots[0].high = 101.0; pivots[1].high = 103.0; pivots[2].high = 110.0; pivots[3].high = 105.0; pivots[4].high = 102.0;
   pivots[0].low = 100.0; pivots[1].low = 98.0; pivots[2].low = 90.0; pivots[3].low = 95.0; pivots[4].low = 99.0;
   double pivot_price = 0.0;
   Check(SMC_ICT_IsConfirmedSwingHigh(pivots, 2, 1, 1, pivot_price) && pivot_price == 110.0,
         "confirmed swing high waits for right bar", passed, failed);
   Check(SMC_ICT_IsConfirmedSwingLow(pivots, 2, 1, 1, pivot_price) && pivot_price == 90.0,
         "confirmed swing low waits for right bar", passed, failed);
   Check(!SMC_ICT_IsConfirmedSwingHigh(pivots, 4, 1, 1, pivot_price),
         "unconfirmed last-bar swing is unavailable", passed, failed);

   Print("SMC_ICT_LIBRARY_TEST_RESULT passed=", passed, " failed=", failed);
   if(failed > 0)
      Print("SMC_ICT_LIBRARY_TEST_STATUS=FAIL");
   else
      Print("SMC_ICT_LIBRARY_TEST_STATUS=PASS");
}
