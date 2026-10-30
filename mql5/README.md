# MQL5 package: status and usage

## Components

- `../include/SMC_ICT_Library.mqh` — shared registry and foundational helpers for FVG, confirmed pivots, close breaks, and liquidity-sweep proxies.
- `Indicators/SMC_ICT_Visualizer.mq5` — chart overlay for the currently implemented primitives.
- `Scripts/SMC_ICT_Audit1000.mq5` — status audit over 1,000 closed bars, one row per catalog ID.
- `Scripts/SMC_ICT_Test_1000Bars.mq5` — minimal harness for foundational events.
- `../scripts/candidate_coverage_1000.py` — read-only MCP coverage report using the Python reference engine.

## Build and runtime

Open the `.mq5` source in MetaEditor and compile with **F7**. To run a compiled program, place its `.ex5` in the matching MT5 data-folder directory (`MQL5/Indicators` or `MQL5/Scripts`) and run it on a chart. Generated `.ex5` binaries and local terminal logs are not source files and are excluded from version control.

Successful compilation is distinct from runtime execution. The latest local compile logs report `0 errors, 0 warnings`; an in-terminal runtime test remains outstanding.

## Coverage semantics

The audit lists every catalog ID, but only a limited set of primitives has event logic. `NA`, `MANUAL_REVIEW`, `CONTEXT_ONLY`, `EXTERNAL_DATA_REQUIRED`, `COMBINATION_NOT_IMPLEMENTED`, and `NOT_IMPLEMENTED` identify work that is not a finished detector. The 126 catalog rows are not 126 completed MQL5 rules.

Official references: [FileOpen sandbox](https://www.mql5.com/en/docs/files/fileopen), [MT5 application folders](https://www.metatrader5.com/en/terminal/help/algotrading/autotrading), and [MetaEditor compilation](https://www.metatrader5.com/en/metaeditor/help/beginning/integration_ide).