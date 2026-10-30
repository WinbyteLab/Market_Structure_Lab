#property strict
#property version   "1.000"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_type1   DRAW_NONE
#property indicator_label1  "SMC_ICT_Objects"

#include "../../include/SMC_ICT_Library.mqh"

input int   InpLookbackBars       = 1000;
input int   InpSwingLeft          = 2;
input int   InpSwingRight         = 2;
input int   InpExtendFvgBars      = 8;
input bool  InpShowFvg            = true;
input bool  InpShowConfirmedSwings = true;
input bool  InpShowLiquiditySweeps = true;
input bool  InpShowCloseBreaks     = true;
input color InpBullishColor       = clrDodgerBlue;
input color InpBearishColor       = clrTomato;
input color InpSwingColor         = clrGold;

const string SMC_ICT_OBJECT_PREFIX = "SMC_ICT_VIZ_";
double SMC_ICT_DummyBuffer[];

void SMC_ICT_DeleteVisualObjects()
{
   ObjectsDeleteAll(0, SMC_ICT_OBJECT_PREFIX);
}

bool SMC_ICT_DrawZone(const string name,
                      const datetime time_left,
                      const datetime time_right,
                      const double price_top,
                      const double price_bottom,
                      const color zone_color)
{
   if(!ObjectCreate(0, name, OBJ_RECTANGLE, 0, time_left, price_top, time_right, price_bottom))
      return false;
   ObjectSetInteger(0, name, OBJPROP_COLOR, zone_color);
   ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DOT);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, name, OBJPROP_FILL, false);
   ObjectSetInteger(0, name, OBJPROP_BACK, true);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   return true;
}

bool SMC_ICT_DrawArrow(const string name,
                       const datetime when,
                       const double price,
                       const bool upward,
                       const color arrow_color)
{
   if(!ObjectCreate(0, name, OBJ_ARROW, 0, when, price))
      return false;
   ObjectSetInteger(0, name, OBJPROP_ARROWCODE, upward ? 233 : 234);
   ObjectSetInteger(0, name, OBJPROP_COLOR, arrow_color);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   return true;
}

int OnInit()
{
   if(InpLookbackBars < 3 || InpSwingLeft < 1 || InpSwingRight < 1 || InpExtendFvgBars < 0)
      return INIT_PARAMETERS_INCORRECT;
   if(!SetIndexBuffer(0, SMC_ICT_DummyBuffer, INDICATOR_DATA))
      return INIT_FAILED;
   ArraySetAsSeries(SMC_ICT_DummyBuffer, true);
   IndicatorSetString(INDICATOR_SHORTNAME, "SMC/ICT v0.10 — FVG, swings, sweep proxies");
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   SMC_ICT_DeleteVisualObjects();
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   if(rates_total < 4)
      return 0;
   if(prev_calculated > 0 && rates_total == prev_calculated)
      return rates_total;

   int request = InpLookbackBars;
   if(request > rates_total - 1)
      request = rates_total - 1;
   if(request < 3)
      return rates_total;

   MqlRates bars[];
   ArraySetAsSeries(bars, false);
   const int copied = CopyRates(_Symbol, _Period, 1, request, bars); // start_pos=1 excludes the forming bar
   if(copied < 3)
   {
      PrintFormat("SMC_ICT_Visualizer: CopyRates returned %d closed bars; need at least 3", copied);
      return rates_total;
   }
   ArraySetAsSeries(bars, false); // library contract: oldest bar at index 0
   SMC_ICT_DeleteVisualObjects();

   int period_seconds = PeriodSeconds(_Period);
   if(period_seconds <= 0)
      period_seconds = 60;
   const double arrow_pad = MathMax(_Point * 8.0, 0.0);

   if(InpShowFvg)
   {
      for(int i = 2; i < copied; i++)
      {
         double gap_low = 0.0;
         double gap_high = 0.0;
         const datetime right_edge = bars[i].time + (datetime)(period_seconds * InpExtendFvgBars);
         if(SMC_ICT_IsBullishFVG(bars[i - 2], bars[i - 1], bars[i], gap_low, gap_high))
         {
            const string name = StringFormat("%sFVG_B_%I64d", SMC_ICT_OBJECT_PREFIX, (long)bars[i].time);
            SMC_ICT_DrawZone(name, bars[i - 2].time, right_edge, gap_high, gap_low, InpBullishColor);
         }
         if(SMC_ICT_IsBearishFVG(bars[i - 2], bars[i - 1], bars[i], gap_low, gap_high))
         {
            const string name = StringFormat("%sFVG_S_%I64d", SMC_ICT_OBJECT_PREFIX, (long)bars[i].time);
            SMC_ICT_DrawZone(name, bars[i - 2].time, right_edge, gap_high, gap_low, InpBearishColor);
         }
      }
   }

   if(InpShowConfirmedSwings)
   {
      for(int i = InpSwingLeft; i + InpSwingRight < copied; i++)
      {
         double pivot = 0.0;
         if(SMC_ICT_IsConfirmedSwingHigh(bars, i, InpSwingLeft, InpSwingRight, pivot))
         {
            const string name = StringFormat("%sSWING_H_%I64d", SMC_ICT_OBJECT_PREFIX, (long)bars[i].time);
            SMC_ICT_DrawArrow(name, bars[i].time, pivot + arrow_pad, false, InpSwingColor);
         }
         if(SMC_ICT_IsConfirmedSwingLow(bars, i, InpSwingLeft, InpSwingRight, pivot))
         {
            const string name = StringFormat("%sSWING_L_%I64d", SMC_ICT_OBJECT_PREFIX, (long)bars[i].time);
            SMC_ICT_DrawArrow(name, bars[i].time, pivot - arrow_pad, true, InpSwingColor);
         }
      }
   }

   if(InpShowLiquiditySweeps || InpShowCloseBreaks)
   {
      bool has_swing_high = false;
      bool has_swing_low = false;
      double last_swing_high = 0.0;
      double last_swing_low = 0.0;
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

         if(i == 0)
            continue;

         if(InpShowLiquiditySweeps)
         {
            if(has_swing_high && SMC_ICT_IsLiquiditySweep(bars[i], last_swing_high, SMC_ICT_SWEEP_BUY_SIDE))
            {
               const string name = StringFormat("%sSWEEP_BSL_%I64d", SMC_ICT_OBJECT_PREFIX, (long)bars[i].time);
               SMC_ICT_DrawArrow(name, bars[i].time, bars[i].high + arrow_pad, false, InpBearishColor);
            }
            if(has_swing_low && SMC_ICT_IsLiquiditySweep(bars[i], last_swing_low, SMC_ICT_SWEEP_SELL_SIDE))
            {
               const string name = StringFormat("%sSWEEP_SSL_%I64d", SMC_ICT_OBJECT_PREFIX, (long)bars[i].time);
               SMC_ICT_DrawArrow(name, bars[i].time, bars[i].low - arrow_pad, true, InpBullishColor);
            }
         }

         if(InpShowCloseBreaks)
         {
            if(has_swing_high && SMC_ICT_IsCloseBreak(bars[i].close, last_swing_high, SMC_ICT_DIRECTION_BULLISH) &&
               bars[i - 1].close <= last_swing_high)
            {
               const string name = StringFormat("%sBREAK_UP_%I64d", SMC_ICT_OBJECT_PREFIX, (long)bars[i].time);
               SMC_ICT_DrawArrow(name, bars[i].time, bars[i].low - arrow_pad, true, InpBullishColor);
            }
            if(has_swing_low && SMC_ICT_IsCloseBreak(bars[i].close, last_swing_low, SMC_ICT_DIRECTION_BEARISH) &&
               bars[i - 1].close >= last_swing_low)
            {
               const string name = StringFormat("%sBREAK_DN_%I64d", SMC_ICT_OBJECT_PREFIX, (long)bars[i].time);
               SMC_ICT_DrawArrow(name, bars[i].time, bars[i].high + arrow_pad, false, InpBearishColor);
            }
         }
      }
   }

   ChartRedraw(0);
   return rates_total;
}
