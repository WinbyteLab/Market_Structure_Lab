# Contributing

Contributions that make ICT/SMC hypotheses more explicit, reproducible, and falsifiable are welcome.

## Before proposing a detector

1. Record the source and distinguish an educator's original term from later community usage.
2. Specify the exact bars, inequalities, timeframe/session assumptions, confirmation time, invalidation, expiry, and any variant.
3. State when the event becomes knowable. A later touch or confirmation must not be presented as a signal available earlier.
4. Add positive and negative synthetic OHLC fixtures before implementing the rule.
5. Keep descriptive event detection separate from entries, exits, and profitability claims.

## Local checks

```bash
python -m pytest -q
python scripts/generate_mql5_library.py --check
```

For MQL5 changes, compile the actual source in MetaEditor and report the compiler result separately from any in-terminal runtime test. Python tests or a successful compile do not prove MT5 runtime behavior.

## Safety and data handling

- Do not add order placement, modification, or close methods to the MCP server.
- Do not commit account identifiers, credentials, terminal profiles, private notes, raw market exports, or generated reports.
- Use only closed bars for close-confirmed events and preserve UTC timestamps and data provenance.
- Do not describe a pattern as institutional intent based on OHLC alone.
- Do not claim positive expectancy without a documented, cost-aware holdout test.
