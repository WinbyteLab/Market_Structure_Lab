from __future__ import annotations

from collections import Counter
from datetime import datetime, timezone
import math
from typing import Any, Iterable

ENGINE_VERSION = "0.1.0"


def _parse_time(value: Any) -> datetime:
    if isinstance(value, datetime):
        parsed = value
    elif isinstance(value, (int, float)) and not isinstance(value, bool):
        parsed = datetime.fromtimestamp(float(value), tz=timezone.utc)
    elif isinstance(value, str):
        text = value.strip()
        if text.endswith("Z"):
            text = text[:-1] + "+00:00"
        try:
            parsed = datetime.fromisoformat(text)
        except ValueError as exc:
            raise ValueError(f"invalid bar time: {value!r}") from exc
    else:
        raise ValueError(f"invalid bar time: {value!r}")
    if parsed.tzinfo is None or parsed.utcoffset() is None:
        raise ValueError("bar time must include an explicit timezone")
    return parsed.astimezone(timezone.utc)


def normalize_bars(rows: Iterable[dict[str, Any]]) -> list[dict[str, Any]]:
    """Validate, UTC-normalize and chronologically sort OHLC bars."""
    normalized: list[dict[str, Any]] = []
    for position, row in enumerate(rows):
        try:
            time_utc = _parse_time(row.get("time", row.get("time_utc")))
            prices = {key: float(row[key]) for key in ("open", "high", "low", "close")}
        except (KeyError, TypeError, OverflowError) as exc:
            raise ValueError(f"bar {position} is missing a valid time or OHLC value") from exc
        if not all(math.isfinite(value) for value in prices.values()):
            raise ValueError(f"bar {position} has a non-finite OHLC value")
        if prices["high"] < max(prices["open"], prices["close"], prices["low"]):
            raise ValueError(f"bar {position} has invalid OHLC: high is below another field")
        if prices["low"] > min(prices["open"], prices["close"], prices["high"]):
            raise ValueError(f"bar {position} has invalid OHLC: low is above another field")
        normalized.append({
            **prices,
            "time_utc": time_utc.isoformat().replace("+00:00", "Z"),
            "_dt": time_utc,
            "spread": int(row.get("spread", 0) or 0),
            "tick_volume": int(row.get("tick_volume", 0) or 0),
            "real_volume": int(row.get("real_volume", 0) or 0),
        })
    normalized.sort(key=lambda item: item["_dt"])
    times = [item["_dt"] for item in normalized]
    if len(times) != len(set(times)):
        raise ValueError("duplicate bar times are not allowed")
    for item in normalized:
        item.pop("_dt")
    return normalized


def _base_event(event_type: str, index: int, bars: list[dict[str, Any]], **fields: Any) -> dict[str, Any]:
    return {
        "type": event_type,
        "confirmed_index": index,
        "confirmation_time_utc": bars[index]["time_utc"],
        **fields,
    }


def _fvg_events(bars: list[dict[str, Any]], min_gap: float) -> list[dict[str, Any]]:
    events: list[dict[str, Any]] = []
    for third in range(2, len(bars)):
        first = bars[third - 2]
        current = bars[third]
        # Operational three-candle non-overlap definition; strict inequality is deliberate.
        if current["low"] > first["high"]:
            lower, upper, side = first["high"], current["low"], "BULLISH"
        elif current["high"] < first["low"]:
            lower, upper, side = current["high"], first["low"], "BEARISH"
        else:
            continue
        if upper - lower < min_gap:
            continue
        event = _base_event(
            f"FVG_{side}",
            third,
            bars,
            formation_start_index=third - 2,
            displacement_index=third - 1,
            lower=lower,
            upper=upper,
            definition_status="operational_three_candle_rule",
            outcome_label_only=True,
            first_touch_index=None,
        )
        # Retrospective outcome only: do not confuse a later retest with the signal time.
        for later in range(third + 1, len(bars)):
            if bars[later]["low"] <= upper and bars[later]["high"] >= lower:
                event["first_touch_index"] = later
                event["first_touch_time_utc"] = bars[later]["time_utc"]
                break
        events.append(event)
    return events


def _confirmed_swings(bars: list[dict[str, Any]], left: int, right: int) -> list[dict[str, Any]]:
    events: list[dict[str, Any]] = []
    if left < 1 or right < 1:
        raise ValueError("left and right swing windows must each be at least 1")
    for pivot in range(left, len(bars) - right):
        prior = bars[pivot - left:pivot]
        later = bars[pivot + 1:pivot + right + 1]
        if all(bars[pivot]["high"] > row["high"] for row in prior + later):
            events.append(_base_event(
                "SWING_HIGH_CONFIRMED",
                pivot + right,
                bars,
                pivot_index=pivot,
                pivot_time_utc=bars[pivot]["time_utc"],
                available_index=pivot + right,
                level=bars[pivot]["high"],
                definition_status="strict_left_right_pivot",
            ))
        if all(bars[pivot]["low"] < row["low"] for row in prior + later):
            events.append(_base_event(
                "SWING_LOW_CONFIRMED",
                pivot + right,
                bars,
                pivot_index=pivot,
                pivot_time_utc=bars[pivot]["time_utc"],
                available_index=pivot + right,
                level=bars[pivot]["low"],
                definition_status="strict_left_right_pivot",
            ))
    return events


def _latest_before(swings: list[dict[str, Any]], event_type: str, index: int) -> dict[str, Any] | None:
    eligible = [
        event for event in swings
        if event["type"] == event_type and event["available_index"] < index
    ]
    return max(eligible, key=lambda event: (event["available_index"], event["pivot_index"])) if eligible else None


def _structure_and_sweeps(
    bars: list[dict[str, Any]], swings: list[dict[str, Any]], ob_lookback: int
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    breaks: list[dict[str, Any]] = []
    sweeps: list[dict[str, Any]] = []
    trend = 0
    for index in range(1, len(bars)):
        current = bars[index]
        previous = bars[index - 1]
        swing_high = _latest_before(swings, "SWING_HIGH_CONFIRMED", index)
        swing_low = _latest_before(swings, "SWING_LOW_CONFIRMED", index)
        if swing_high and previous["close"] <= swing_high["level"] < current["close"]:
            event_type = "MSS_UP" if trend < 0 else "BOS_UP"
            breaks.append(_base_event(
                event_type, index, bars,
                level=swing_high["level"], reference_pivot_index=swing_high["pivot_index"],
                prior_trend=trend,
                definition_status="close_break_of_previously_confirmed_swing",
            ))
            trend = 1
        if swing_low and previous["close"] >= swing_low["level"] > current["close"]:
            event_type = "MSS_DOWN" if trend > 0 else "BOS_DOWN"
            breaks.append(_base_event(
                event_type, index, bars,
                level=swing_low["level"], reference_pivot_index=swing_low["pivot_index"],
                prior_trend=trend,
                definition_status="close_break_of_previously_confirmed_swing",
            ))
            trend = -1
        if swing_high and current["high"] > swing_high["level"] and current["close"] <= swing_high["level"]:
            sweeps.append(_base_event(
                "BUY_SIDE_SWEEP", index, bars,
                level=swing_high["level"], reference_pivot_index=swing_high["pivot_index"],
                definition_status="wick_above_confirmed_swing_then_close_at_or_below",
            ))
        if swing_low and current["low"] < swing_low["level"] and current["close"] >= swing_low["level"]:
            sweeps.append(_base_event(
                "SELL_SIDE_SWEEP", index, bars,
                level=swing_low["level"], reference_pivot_index=swing_low["pivot_index"],
                definition_status="wick_below_confirmed_swing_then_close_at_or_above",
            ))
    # A named OB is not inferable from OHLC alone. This is a declared mechanical proxy:
    # closest opposite-colour candle before a close-break of a confirmed swing.
    order_blocks: list[dict[str, Any]] = []
    for break_event in breaks:
        index = break_event["confirmed_index"]
        bullish = break_event["type"].endswith("UP")
        start = max(0, index - ob_lookback)
        for source_index in range(index - 1, start - 1, -1):
            row = bars[source_index]
            opposite = row["close"] < row["open"] if bullish else row["close"] > row["open"]
            if opposite:
                order_blocks.append(_base_event(
                    "OB_BULL_PROXY" if bullish else "OB_BEAR_PROXY",
                    index,
                    bars,
                    source_candle_index=source_index,
                    lower=row["low"],
                    upper=row["high"],
                    break_type=break_event["type"],
                    definition_status="mechanical_proxy_not_canonical_rule",
                ))
                break
    return breaks + order_blocks, sweeps


def analyze_bars(
    rows: Iterable[dict[str, Any]],
    *,
    left: int = 2,
    right: int = 2,
    min_fvg_gap: float = 0.0,
    ob_lookback: int = 10,
) -> dict[str, Any]:
    """Analyze closed OHLC bars with explicit non-canonical operational rules.

    Input must exclude an unfinished bar. Swing and structure events only become
    available after the required right-side bars and/or close are observed. FVG
    touch indices are retrospective outcome labels, never entry-time signals.
    """
    if min_fvg_gap < 0 or not math.isfinite(float(min_fvg_gap)):
        raise ValueError("min_fvg_gap must be a finite non-negative number")
    if isinstance(ob_lookback, bool) or int(ob_lookback) < 1:
        raise ValueError("ob_lookback must be a positive integer")
    bars = normalize_bars(rows)
    swings = _confirmed_swings(bars, left, right)
    structure, sweeps = _structure_and_sweeps(bars, swings, int(ob_lookback))
    events = _fvg_events(bars, float(min_fvg_gap)) + swings + structure + sweeps
    events.sort(key=lambda event: (
        event["confirmed_index"], event["type"], event.get("formation_start_index", -1)
    ))
    counts = Counter(event["type"] for event in events)
    return {
        "engine_version": ENGINE_VERSION,
        "bar_count": len(bars),
        "events": events,
        "event_counts": dict(sorted(counts.items())),
        "assumptions": {
            "bars_must_be_closed": True,
            "timestamp_semantics": "bar open time in UTC; event index is the close/availability bar",
            "swing_rule": f"strict pivot with left={left}, right={right}; available only after right bars close",
            "fvg_rule": "three-bar non-overlap; strict inequality; later first-touch is outcome-only",
            "sweep_rule": "confirmed swing wick-through with close back at/inside level",
            "order_block_rule": "explicit mechanical proxy; not asserted as canonical ICT/SMC definition",
        },
        "warnings": [
            "OHLC bars do not reveal trader identity, actual resting orders, or institutional intent.",
            "These operational rules are research hypotheses, not a claim of profitability or canonical agreement.",
            "Do not use retrospective FVG touch labels as if they were known at formation time.",
        ],
    }
