# MQL5: build, runtime, and limitations

## Components

- `include/SMC_ICT_Library.mqh` — catalog registry and foundational event helpers.
- `mql5/Indicators/SMC_ICT_Visualizer.mq5` — chart visualization for a limited set of operational primitives.
- `mql5/Scripts/SMC_ICT_Audit1000.mq5` — candidate-status audit over 1,000 closed bars.
- `mql5/Scripts/SMC_ICT_Test_1000Bars.mq5` — minimal harness for foundational events.

Compiled `.ex5` files are generated artifacts and are not committed.

## Compile and run

1. Open the required `.mq5` file in MetaEditor and compile it with **F7**.
2. For a terminal runtime check, copy the resulting `.ex5` to the matching MT5 data-folder subdirectory (`MQL5/Indicators` or `MQL5/Scripts`), refresh Navigator, and run it on a selected chart.
3. Inspect the Experts/Journal output. `NA`, `NOT_IMPLEMENTED`, and related statuses mean that a detector is absent or requires context; they are not zero-event results.

Compilation is not runtime verification. The latest local MetaEditor compile records show `0 errors, 0 warnings`, but an in-terminal runtime test has not been completed. Do not mark that gate complete until the program has run in MT5 and its output has been checked.

## What the audit does — and does not — prove

The audit produces a status row per catalog record. Only foundational primitives have implemented event logic; many records remain manual, contextual, external-data-dependent, or unimplemented. The catalog's 126 rows are neither 126 canonical concepts nor 126 completed detectors. A successful audit run is coverage evidence, not validation of every interpretation and not evidence of profitability.

Signals must be reported at the bar where they become knowable. Do not treat a later FVG touch, swing confirmation, or structure break as though it were available at formation time.

## File output boundary

MQL5 `FileOpen` is sandboxed to the terminal's `MQL5/Files` folder (or the shared terminal folder with `FILE_COMMON`); an MQL5 program cannot freely write to an arbitrary project path. The Python/MCP export path writes only beneath the project `data/raw/` directory. See the official [MQL5 FileOpen reference](https://www.mql5.com/en/docs/files/fileopen).

MT5 applications use their corresponding terminal data-folder subdirectories; see the official [MetaTrader 5 application-folder documentation](https://www.metatrader5.com/en/terminal/help/algotrading/autotrading) and [MetaEditor compilation guide](https://www.metatrader5.com/en/metaeditor/help/beginning/integration_ide).