#ifndef SMC_ICT_LIBRARY_MQH
#define SMC_ICT_LIBRARY_MQH

// Generated from catalog/ict_smc_catalog.json by scripts/generate_mql5_library.py.
// Do not treat registry presence as proof that an item is automatically detectable.
// All bars passed to the detector functions must be ordered oldest to newest.
#define SMC_ICT_CATALOG_VERSION "ict-smc-v0.1"
#define SMC_ICT_CATALOG_COUNT 126

enum ENUM_SMC_ICT_ID
{
   SMC_ICT_C001 = 1,
   SMC_ICT_C002 = 2,
   SMC_ICT_C003 = 3,
   SMC_ICT_C004 = 4,
   SMC_ICT_C005 = 5,
   SMC_ICT_C006 = 6,
   SMC_ICT_C007 = 7,
   SMC_ICT_C008 = 8,
   SMC_ICT_C009 = 9,
   SMC_ICT_C010 = 10,
   SMC_ICT_C011 = 11,
   SMC_ICT_C012 = 12,
   SMC_ICT_C013 = 13,
   SMC_ICT_C014 = 14,
   SMC_ICT_C015 = 15,
   SMC_ICT_C016 = 16,
   SMC_ICT_C017 = 17,
   SMC_ICT_C018 = 18,
   SMC_ICT_C019 = 19,
   SMC_ICT_C020 = 20,
   SMC_ICT_C021 = 21,
   SMC_ICT_C022 = 22,
   SMC_ICT_C023 = 23,
   SMC_ICT_C024 = 24,
   SMC_ICT_C025 = 25,
   SMC_ICT_C026 = 26,
   SMC_ICT_C027 = 27,
   SMC_ICT_C028 = 28,
   SMC_ICT_C029 = 29,
   SMC_ICT_C030 = 30,
   SMC_ICT_C031 = 31,
   SMC_ICT_C032 = 32,
   SMC_ICT_C033 = 33,
   SMC_ICT_C034 = 34,
   SMC_ICT_C035 = 35,
   SMC_ICT_C036 = 36,
   SMC_ICT_C037 = 37,
   SMC_ICT_C038 = 38,
   SMC_ICT_C039 = 39,
   SMC_ICT_C040 = 40,
   SMC_ICT_C041 = 41,
   SMC_ICT_C042 = 42,
   SMC_ICT_C043 = 43,
   SMC_ICT_C044 = 44,
   SMC_ICT_C045 = 45,
   SMC_ICT_C046 = 46,
   SMC_ICT_C047 = 47,
   SMC_ICT_C048 = 48,
   SMC_ICT_C049 = 49,
   SMC_ICT_C050 = 50,
   SMC_ICT_C051 = 51,
   SMC_ICT_C052 = 52,
   SMC_ICT_C053 = 53,
   SMC_ICT_C054 = 54,
   SMC_ICT_C055 = 55,
   SMC_ICT_C056 = 56,
   SMC_ICT_C057 = 57,
   SMC_ICT_C058 = 58,
   SMC_ICT_C059 = 59,
   SMC_ICT_C060 = 60,
   SMC_ICT_C061 = 61,
   SMC_ICT_C062 = 62,
   SMC_ICT_C063 = 63,
   SMC_ICT_C064 = 64,
   SMC_ICT_C065 = 65,
   SMC_ICT_C066 = 66,
   SMC_ICT_C067 = 67,
   SMC_ICT_C068 = 68,
   SMC_ICT_C069 = 69,
   SMC_ICT_C070 = 70,
   SMC_ICT_C071 = 71,
   SMC_ICT_C072 = 72,
   SMC_ICT_C073 = 73,
   SMC_ICT_C074 = 74,
   SMC_ICT_C075 = 75,
   SMC_ICT_C076 = 76,
   SMC_ICT_C077 = 77,
   SMC_ICT_C078 = 78,
   SMC_ICT_C079 = 79,
   SMC_ICT_C080 = 80,
   SMC_ICT_C081 = 81,
   SMC_ICT_C082 = 82,
   SMC_ICT_C083 = 83,
   SMC_ICT_C084 = 84,
   SMC_ICT_C085 = 85,
   SMC_ICT_C086 = 86,
   SMC_ICT_C087 = 87,
   SMC_ICT_C088 = 88,
   SMC_ICT_C089 = 89,
   SMC_ICT_C090 = 90,
   SMC_ICT_C091 = 91,
   SMC_ICT_C092 = 92,
   SMC_ICT_C093 = 93,
   SMC_ICT_C094 = 94,
   SMC_ICT_C095 = 95,
   SMC_ICT_C096 = 96,
   SMC_ICT_C097 = 97,
   SMC_ICT_C098 = 98,
   SMC_ICT_C099 = 99,
   SMC_ICT_C100 = 100,
   SMC_ICT_C101 = 101,
   SMC_ICT_C102 = 102,
   SMC_ICT_C103 = 103,
   SMC_ICT_C104 = 104,
   SMC_ICT_C105 = 105,
   SMC_ICT_C106 = 106,
   SMC_ICT_C107 = 107,
   SMC_ICT_C108 = 108,
   SMC_ICT_C109 = 109,
   SMC_ICT_C110 = 110,
   SMC_ICT_C111 = 111,
   SMC_ICT_C112 = 112,
   SMC_ICT_C113 = 113,
   SMC_ICT_C114 = 114,
   SMC_ICT_C115 = 115,
   SMC_ICT_C116 = 116,
   SMC_ICT_C117 = 117,
   SMC_ICT_C118 = 118,
   SMC_ICT_C119 = 119,
   SMC_ICT_C120 = 120,
   SMC_ICT_C121 = 121,
   SMC_ICT_C122 = 122,
   SMC_ICT_C123 = 123,
   SMC_ICT_C124 = 124,
   SMC_ICT_C125 = 125,
   SMC_ICT_C126 = 126
};

enum ENUM_SMC_ICT_SUPPORT
{
   SMC_ICT_SUPPORT_NOT_FORMALIZED = 0,
   SMC_ICT_SUPPORT_CONTEXT_ONLY = 1,
   SMC_ICT_SUPPORT_EXTERNAL_DATA = 2,
   SMC_ICT_SUPPORT_MANUAL_REVIEW = 3,
   SMC_ICT_SUPPORT_COMBINATION = 4,
   SMC_ICT_SUPPORT_PRIMITIVE_AVAILABLE = 5
};

enum ENUM_SMC_ICT_DIRECTION
{
   SMC_ICT_DIRECTION_BEARISH = -1,
   SMC_ICT_DIRECTION_NONE = 0,
   SMC_ICT_DIRECTION_BULLISH = 1
};

enum ENUM_SMC_ICT_SWEEP_SIDE
{
   SMC_ICT_SWEEP_SELL_SIDE = -1, // Low is swept; close returns above the level.
   SMC_ICT_SWEEP_BUY_SIDE = 1    // High is swept; close returns below the level.
};

struct SMC_ICT_Definition
{
   ENUM_SMC_ICT_ID id;
   string code;
   string term_en;
   string term_ru;
   string family;
   string kind;
   string origin;
   string status;
   string code_status;
   string source_refs;
   ENUM_SMC_ICT_SUPPORT support;
};

int SMC_ICT_CandidateCount()
{
   return SMC_ICT_CATALOG_COUNT;
}

bool SMC_ICT_GetDefinition(const ENUM_SMC_ICT_ID candidate_id, SMC_ICT_Definition &out)
{
   switch(candidate_id)
   {
      case SMC_ICT_C001:
         out.id = SMC_ICT_C001;
         out.code = "C001";
         out.term_en = "Market Structure";
         out.term_ru = "Рыночная структура";
         out.family = "structure";
         out.kind = "concept";
         out.origin = "ICT/SMC shared";
         out.status = "primary-linked; rule variants pending";
         out.code_status = "Python prototype: pivots and close-breaks";
         out.source_refs = "42,35,48";
         out.support = SMC_ICT_SUPPORT_PRIMITIVE_AVAILABLE;
         return true;
      case SMC_ICT_C002:
         out.id = SMC_ICT_C002;
         out.code = "C002";
         out.term_en = "HH/HL vs LH/LL trend state";
         out.term_ru = "Состояние тренда HH/HL и LH/LL";
         out.family = "structure";
         out.kind = "chart-state";
         out.origin = "shared terminology";
         out.status = "secondary-seeded; pivot rule pending";
         out.code_status = "Python prototype: pivot events";
         out.source_refs = "42,35";
         out.support = SMC_ICT_SUPPORT_PRIMITIVE_AVAILABLE;
         return true;
      case SMC_ICT_C003:
         out.id = SMC_ICT_C003;
         out.code = "C003";
         out.term_en = "Swing Point Hierarchy";
         out.term_ru = "Иерархия swing-точек";
         out.family = "structure";
         out.kind = "concept";
         out.origin = "ICT terminology";
         out.status = "primary source linked; exact nesting rule pending";
         out.code_status = "Python strict-pivot prototype";
         out.source_refs = "42,35,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C004:
         out.id = SMC_ICT_C004;
         out.code = "C004";
         out.term_en = "Short-Term High/Low (STH/STL)";
         out.term_ru = "Краткосрочный максимум/минимум";
         out.family = "structure";
         out.kind = "swing-level";
         out.origin = "ICT terminology";
         out.status = "secondary-seeded; parameterization pending";
         out.code_status = "Python pivot prototype";
         out.source_refs = "42,35,43";
         out.support = SMC_ICT_SUPPORT_PRIMITIVE_AVAILABLE;
         return true;
      case SMC_ICT_C005:
         out.id = SMC_ICT_C005;
         out.code = "C005";
         out.term_en = "Intermediate-Term High/Low (ITH/ITL)";
         out.term_ru = "Промежуточный максимум/минимум";
         out.family = "structure";
         out.kind = "swing-level";
         out.origin = "ICT terminology";
         out.status = "secondary-seeded; primary rule pending";
         out.code_status = "not coded";
         out.source_refs = "42,35,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C006:
         out.id = SMC_ICT_C006;
         out.code = "C006";
         out.term_en = "Long-Term High/Low (LTH/LTL)";
         out.term_ru = "Долгосрочный максимум/минимум";
         out.family = "structure";
         out.kind = "swing-level";
         out.origin = "ICT terminology";
         out.status = "secondary-seeded; primary rule pending";
         out.code_status = "not coded";
         out.source_refs = "42,35,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C007:
         out.id = SMC_ICT_C007;
         out.code = "C007";
         out.term_en = "Break of Structure (BOS)";
         out.term_ru = "Пробой структуры";
         out.family = "structure";
         out.kind = "event";
         out.origin = "mostly SMC label";
         out.status = "secondary definition; terminology fork recorded";
         out.code_status = "Python close-break prototype";
         out.source_refs = "42,35";
         out.support = SMC_ICT_SUPPORT_PRIMITIVE_AVAILABLE;
         return true;
      case SMC_ICT_C008:
         out.id = SMC_ICT_C008;
         out.code = "C008";
         out.term_en = "Change of Character (CHoCH)";
         out.term_ru = "Изменение характера";
         out.family = "structure";
         out.kind = "event";
         out.origin = "SMC/community label";
         out.status = "secondary definition; ICT attribution must not be assumed";
         out.code_status = "not coded as canonical label";
         out.source_refs = "42,35";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C009:
         out.id = SMC_ICT_C009;
         out.code = "C009";
         out.term_en = "Market Structure Shift (MSS)";
         out.term_ru = "Сдвиг рыночной структуры";
         out.family = "structure";
         out.kind = "event";
         out.origin = "ICT primary term";
         out.status = "primary-linked; exact swing tiers pending";
         out.code_status = "Python prototype; definition remains operational";
         out.source_refs = "9,35,48";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C010:
         out.id = SMC_ICT_C010;
         out.code = "C010";
         out.term_en = "Change in State of Delivery (CISD)";
         out.term_ru = "Изменение состояния поставки цены";
         out.family = "structure";
         out.kind = "event";
         out.origin = "ICT term; operational details vary";
         out.status = "secondary-seeded; primary transcript review pending";
         out.code_status = "not coded";
         out.source_refs = "42,48";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C011:
         out.id = SMC_ICT_C011;
         out.code = "C011";
         out.term_en = "Body-Close Confirmation";
         out.term_ru = "Подтверждение закрытием тела";
         out.family = "structure";
         out.kind = "confirmation-rule";
         out.origin = "ICT/SMC practice; convention-dependent";
         out.status = "operational convention; compare wick-based variants";
         out.code_status = "Python prototype uses closes for breaks";
         out.source_refs = "42,51";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C012:
         out.id = SMC_ICT_C012;
         out.code = "C012";
         out.term_en = "Displacement";
         out.term_ru = "Импульсное смещение цены";
         out.family = "structure";
         out.kind = "price-action";
         out.origin = "ICT term";
         out.status = "definition mapped; threshold not canonical";
         out.code_status = "not coded";
         out.source_refs = "9,42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C013:
         out.id = SMC_ICT_C013;
         out.code = "C013";
         out.term_en = "Consolidation";
         out.term_ru = "Консолидация";
         out.family = "structure";
         out.kind = "price-state";
         out.origin = "shared market term";
         out.status = "secondary-seeded; parameterization pending";
         out.code_status = "not coded";
         out.source_refs = "42,32";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C014:
         out.id = SMC_ICT_C014;
         out.code = "C014";
         out.term_en = "Expansion";
         out.term_ru = "Расширение диапазона";
         out.family = "structure";
         out.kind = "price-state";
         out.origin = "ICT/market profile usage";
         out.status = "primary-linked at model level";
         out.code_status = "not coded";
         out.source_refs = "42,34";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C015:
         out.id = SMC_ICT_C015;
         out.code = "C015";
         out.term_en = "Retracement";
         out.term_ru = "Откат";
         out.family = "structure";
         out.kind = "price-state";
         out.origin = "shared market term";
         out.status = "secondary-seeded";
         out.code_status = "not coded";
         out.source_refs = "42,36";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C016:
         out.id = SMC_ICT_C016;
         out.code = "C016";
         out.term_en = "Reversal";
         out.term_ru = "Разворот";
         out.family = "structure";
         out.kind = "price-state";
         out.origin = "shared market term";
         out.status = "general construct; operational rule pending";
         out.code_status = "not coded";
         out.source_refs = "42,35";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C017:
         out.id = SMC_ICT_C017;
         out.code = "C017";
         out.term_en = "Institutional Order Flow";
         out.term_ru = "Институциональный поток ордеров";
         out.family = "order-flow";
         out.kind = "interpretive-framework";
         out.origin = "ICT primary framing";
         out.status = "primary sources identified; observational limits noted";
         out.code_status = "context only";
         out.source_refs = "40,45,46";
         out.support = SMC_ICT_SUPPORT_CONTEXT_ONLY;
         return true;
      case SMC_ICT_C018:
         out.id = SMC_ICT_C018;
         out.code = "C018";
         out.term_en = "Daily Bias";
         out.term_ru = "Дневное направление (bias)";
         out.family = "context";
         out.kind = "filter";
         out.origin = "ICT primary term";
         out.status = "primary-linked; remains a hypothesis";
         out.code_status = "not coded";
         out.source_refs = "32,36,42";
         out.support = SMC_ICT_SUPPORT_CONTEXT_ONLY;
         return true;
      case SMC_ICT_C019:
         out.id = SMC_ICT_C019;
         out.code = "C019";
         out.term_en = "Top-Down Analysis";
         out.term_ru = "Анализ сверху вниз";
         out.family = "context";
         out.kind = "workflow";
         out.origin = "ICT teaching workflow";
         out.status = "secondary-seeded; exact workflow variants pending";
         out.code_status = "not coded";
         out.source_refs = "42,36,45";
         out.support = SMC_ICT_SUPPORT_CONTEXT_ONLY;
         return true;
      case SMC_ICT_C020:
         out.id = SMC_ICT_C020;
         out.code = "C020";
         out.term_en = "Full Time Frame Continuity (FTFC)";
         out.term_ru = "Согласованность таймфреймов";
         out.family = "context";
         out.kind = "filter";
         out.origin = "ICT/community usage";
         out.status = "candidate; source and timeframe matrix pending";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_CONTEXT_ONLY;
         return true;
      case SMC_ICT_C021:
         out.id = SMC_ICT_C021;
         out.code = "C021";
         out.term_en = "Buy-Side / Sell-Side Liquidity (BSL/SSL)";
         out.term_ru = "Ликвидность над максимумами / под минимумами";
         out.family = "liquidity";
         out.kind = "reference-concept";
         out.origin = "ICT primary terminology";
         out.status = "primary-linked; not an order-book measurement";
         out.code_status = "Python sweep prototype";
         out.source_refs = "46,48,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C022:
         out.id = SMC_ICT_C022;
         out.code = "C022";
         out.term_en = "Liquidity Pool";
         out.term_ru = "Пул ликвидности";
         out.family = "liquidity";
         out.kind = "reference-level";
         out.origin = "ICT practitioner term";
         out.status = "primary-linked; amount of resting orders unobservable";
         out.code_status = "not coded as actual orders";
         out.source_refs = "46,42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C023:
         out.id = SMC_ICT_C023;
         out.code = "C023";
         out.term_en = "Draw on Liquidity (DOL)";
         out.term_ru = "Текущая цель ликвидности";
         out.family = "liquidity";
         out.kind = "context-target";
         out.origin = "ICT term";
         out.status = "primary-linked as narrative; selection rule pending";
         out.code_status = "not coded";
         out.source_refs = "46,42,36";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C024:
         out.id = SMC_ICT_C024;
         out.code = "C024";
         out.term_en = "Liquidity Sweep / Raid";
         out.term_ru = "Снятие / рейд ликвидности";
         out.family = "liquidity";
         out.kind = "price-event";
         out.origin = "ICT term; aliases vary";
         out.status = "primary-linked; close-back rule is explicit prototype only";
         out.code_status = "Python prototype";
         out.source_refs = "46,48,42";
         out.support = SMC_ICT_SUPPORT_PRIMITIVE_AVAILABLE;
         return true;
      case SMC_ICT_C025:
         out.id = SMC_ICT_C025;
         out.code = "C025";
         out.term_en = "Liquidity Run";
         out.term_ru = "Проход через пул ликвидности";
         out.family = "liquidity";
         out.kind = "price-event";
         out.origin = "ICT term";
         out.status = "secondary-seeded; taxonomy distinguishes outcome from sweep";
         out.code_status = "not coded";
         out.source_refs = "46,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C026:
         out.id = SMC_ICT_C026;
         out.code = "C026";
         out.term_en = "Relative Equal Highs / Lows (EQH/EQL)";
         out.term_ru = "Относительно равные максимумы / минимумы";
         out.family = "liquidity";
         out.kind = "reference-level";
         out.origin = "ICT/SMC shared";
         out.status = "secondary rule; tolerance must be parameterized";
         out.code_status = "not coded";
         out.source_refs = "46,42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C027:
         out.id = SMC_ICT_C027;
         out.code = "C027";
         out.term_en = "Inducement (IDM)";
         out.term_ru = "Индуцирование ранних входов";
         out.family = "liquidity";
         out.kind = "interpretive-pattern";
         out.origin = "mostly SMC/community label";
         out.status = "attribution/definition fork; subjective";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_CONTEXT_ONLY;
         return true;
      case SMC_ICT_C028:
         out.id = SMC_ICT_C028;
         out.code = "C028";
         out.term_en = "Internal Range Liquidity (IRL)";
         out.term_ru = "Внутренняя ликвидность диапазона";
         out.family = "liquidity";
         out.kind = "range-classification";
         out.origin = "ICT primary term";
         out.status = "primary-linked; inclusion rules pending";
         out.code_status = "not coded";
         out.source_refs = "48,9,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C029:
         out.id = SMC_ICT_C029;
         out.code = "C029";
         out.term_en = "External Range Liquidity (ERL)";
         out.term_ru = "Внешняя ликвидность диапазона";
         out.family = "liquidity";
         out.kind = "range-classification";
         out.origin = "ICT primary term";
         out.status = "primary-linked; range anchoring pending";
         out.code_status = "not coded";
         out.source_refs = "48,9,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C030:
         out.id = SMC_ICT_C030;
         out.code = "C030";
         out.term_en = "Previous Day High / Low (PDH/PDL)";
         out.term_ru = "Максимум / минимум предыдущего дня";
         out.family = "liquidity";
         out.kind = "reference-level";
         out.origin = "ICT reference levels";
         out.status = "source-linked; session-day convention must be pinned";
         out.code_status = "not coded";
         out.source_refs = "50,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C031:
         out.id = SMC_ICT_C031;
         out.code = "C031";
         out.term_en = "Previous Week High / Low (PWH/PWL)";
         out.term_ru = "Максимум / минимум предыдущей недели";
         out.family = "liquidity";
         out.kind = "reference-level";
         out.origin = "ICT reference levels";
         out.status = "secondary-seeded; week boundary varies by instrument";
         out.code_status = "not coded";
         out.source_refs = "46,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C032:
         out.id = SMC_ICT_C032;
         out.code = "C032";
         out.term_en = "Previous Month High / Low (PMH/PML)";
         out.term_ru = "Максимум / минимум предыдущего месяца";
         out.family = "liquidity";
         out.kind = "reference-level";
         out.origin = "ICT/SMC reference extension";
         out.status = "secondary-seeded; monthly calendar convention pending";
         out.code_status = "not coded";
         out.source_refs = "42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C033:
         out.id = SMC_ICT_C033;
         out.code = "C033";
         out.term_en = "Previous Session High / Low";
         out.term_ru = "Максимум / минимум предыдущей сессии";
         out.family = "liquidity";
         out.kind = "reference-level";
         out.origin = "ICT reference level";
         out.status = "primary-linked; session boundaries instrument-specific";
         out.code_status = "not coded";
         out.source_refs = "33,50,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C034:
         out.id = SMC_ICT_C034;
         out.code = "C034";
         out.term_en = "Trendline Liquidity";
         out.term_ru = "Ликвидность у трендовой линии";
         out.family = "liquidity";
         out.kind = "reference-level";
         out.origin = "SMC/community extension";
         out.status = "community candidate; threshold pending";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C035:
         out.id = SMC_ICT_C035;
         out.code = "C035";
         out.term_en = "High/Low Resistance Liquidity Run (HRLR/LRLR)";
         out.term_ru = "Проход с высоким / низким сопротивлением ликвидности";
         out.family = "liquidity";
         out.kind = "path-context";
         out.origin = "ICT terminology";
         out.status = "secondary-seeded; subjective until quantified";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C036:
         out.id = SMC_ICT_C036;
         out.code = "C036";
         out.term_en = "Strong / Weak Highs and Lows";
         out.term_ru = "Сильные / слабые экстремумы";
         out.family = "liquidity";
         out.kind = "swing-quality";
         out.origin = "ICT/SMC usage";
         out.status = "secondary-seeded; rule pending";
         out.code_status = "not coded";
         out.source_refs = "42,35";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C037:
         out.id = SMC_ICT_C037;
         out.code = "C037";
         out.term_en = "Turtle Soup";
         out.term_ru = "Turtle Soup, вход против ложного пробоя";
         out.family = "liquidity";
         out.kind = "reversal-pattern";
         out.origin = "older pattern adapted by ICT";
         out.status = "primary/secondary linked; distinguish Raschke original";
         out.code_status = "catalogued";
         out.source_refs = "45,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C038:
         out.id = SMC_ICT_C038;
         out.code = "C038";
         out.term_en = "Stop Hunt";
         out.term_ru = "Стоп-хант";
         out.family = "liquidity";
         out.kind = "interpretive-alias";
         out.origin = "general/SMC alias";
         out.status = "alias grouped with sweep; no actor intent inferred";
         out.code_status = "alias";
         out.source_refs = "42,46";
         out.support = SMC_ICT_SUPPORT_CONTEXT_ONLY;
         return true;
      case SMC_ICT_C039:
         out.id = SMC_ICT_C039;
         out.code = "C039";
         out.term_en = "Double Purge";
         out.term_ru = "Двойное снятие ликвидности";
         out.family = "liquidity";
         out.kind = "sequence-pattern";
         out.origin = "SMC/community / later ICT glossary";
         out.status = "candidate; primary source pending";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C040:
         out.id = SMC_ICT_C040;
         out.code = "C040";
         out.term_en = "Open-Float Liquidity Pool";
         out.term_ru = "Open-float liquidity pool";
         out.family = "liquidity";
         out.kind = "reference-concept";
         out.origin = "community candidate";
         out.status = "discovery-only; not defined as ICT canonical";
         out.code_status = "not coded";
         out.source_refs = "43";
         out.support = SMC_ICT_SUPPORT_MANUAL_REVIEW;
         return true;
      case SMC_ICT_C041:
         out.id = SMC_ICT_C041;
         out.code = "C041";
         out.term_en = "Liquidity Engineering";
         out.term_ru = "Инженерия ликвидности";
         out.family = "liquidity";
         out.kind = "interpretive-phase";
         out.origin = "community/market-maker narrative";
         out.status = "interpretive; needs primary terminology audit";
         out.code_status = "not coded";
         out.source_refs = "43,46";
         out.support = SMC_ICT_SUPPORT_CONTEXT_ONLY;
         return true;
      case SMC_ICT_C042:
         out.id = SMC_ICT_C042;
         out.code = "C042";
         out.term_en = "Fair Value Gap (FVG)";
         out.term_ru = "Fair Value Gap, трёхсвечной дисбаланс";
         out.family = "pd_array";
         out.kind = "imbalance";
         out.origin = "ICT primary term";
         out.status = "primary-linked; implementation rule explicit";
         out.code_status = "Python prototype; available to future MQL5 indicator";
         out.source_refs = "9,51,42,41";
         out.support = SMC_ICT_SUPPORT_PRIMITIVE_AVAILABLE;
         return true;
      case SMC_ICT_C043:
         out.id = SMC_ICT_C043;
         out.code = "C043";
         out.term_en = "BISI";
         out.term_ru = "Buy-Side Imbalance, Sell-Side Inefficiency";
         out.family = "pd_array";
         out.kind = "imbalance-alias";
         out.origin = "ICT abbreviation";
         out.status = "secondary/primary vocabulary linked; mirrored BISI/SIBI grouped at family level";
         out.code_status = "alias of FVG_BULLISH";
         out.source_refs = "42,41,51";
         out.support = SMC_ICT_SUPPORT_PRIMITIVE_AVAILABLE;
         return true;
      case SMC_ICT_C044:
         out.id = SMC_ICT_C044;
         out.code = "C044";
         out.term_en = "SIBI";
         out.term_ru = "Sell-Side Imbalance, Buy-Side Inefficiency";
         out.family = "pd_array";
         out.kind = "imbalance-alias";
         out.origin = "ICT abbreviation";
         out.status = "secondary/primary vocabulary linked; mirrored BISI/SIBI grouped at family level";
         out.code_status = "alias of FVG_BEARISH";
         out.source_refs = "42,41,51";
         out.support = SMC_ICT_SUPPORT_PRIMITIVE_AVAILABLE;
         return true;
      case SMC_ICT_C045:
         out.id = SMC_ICT_C045;
         out.code = "C045";
         out.term_en = "Consequent Encroachment (CE)";
         out.term_ru = "Середина FVG/диапазона";
         out.family = "pd_array";
         out.kind = "reference-price";
         out.origin = "ICT term";
         out.status = "secondary-seeded; clarify object variants before coding";
         out.code_status = "not coded";
         out.source_refs = "42,41,34";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C046:
         out.id = SMC_ICT_C046;
         out.code = "C046";
         out.term_en = "Mean Threshold (MT)";
         out.term_ru = "Средний порог Order Block";
         out.family = "pd_array";
         out.kind = "reference-price";
         out.origin = "ICT term";
         out.status = "variant-sensitive; body-vs-wick fork pending";
         out.code_status = "not coded";
         out.source_refs = "42,41,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C047:
         out.id = SMC_ICT_C047;
         out.code = "C047";
         out.term_en = "Inverse Fair Value Gap (IFVG)";
         out.term_ru = "Инвертированный FVG";
         out.family = "pd_array";
         out.kind = "state-transition";
         out.origin = "ICT/community term; variants exist";
         out.status = "secondary-seeded; close vs wick rule pending";
         out.code_status = "not coded";
         out.source_refs = "42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C048:
         out.id = SMC_ICT_C048;
         out.code = "C048";
         out.term_en = "Implied Fair Value Gap";
         out.term_ru = "Implied FVG";
         out.family = "pd_array";
         out.kind = "imbalance-variant";
         out.origin = "ICT/community variant";
         out.status = "variant-defined; primary rule pending";
         out.code_status = "not coded";
         out.source_refs = "42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C049:
         out.id = SMC_ICT_C049;
         out.code = "C049";
         out.term_en = "Volume Imbalance (VI)";
         out.term_ru = "Объёмный/свечной дисбаланс";
         out.family = "pd_array";
         out.kind = "imbalance";
         out.origin = "ICT term; definitions vary";
         out.status = "secondary-seeded; price-vs-volume terminology check pending";
         out.code_status = "not coded";
         out.source_refs = "42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C050:
         out.id = SMC_ICT_C050;
         out.code = "C050";
         out.term_en = "Liquidity Void";
         out.term_ru = "Пустота ликвидности";
         out.family = "pd_array";
         out.kind = "imbalance-zone";
         out.origin = "ICT primary/community usage";
         out.status = "primary source identified; algorithmic threshold pending";
         out.code_status = "not coded";
         out.source_refs = "52,41,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C051:
         out.id = SMC_ICT_C051;
         out.code = "C051";
         out.term_en = "Balanced Price Range (BPR)";
         out.term_ru = "Сбалансированный ценовой диапазон";
         out.family = "pd_array";
         out.kind = "overlap-zone";
         out.origin = "ICT/community term";
         out.status = "secondary-seeded; overlap lifecycle pending";
         out.code_status = "not coded";
         out.source_refs = "42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C052:
         out.id = SMC_ICT_C052;
         out.code = "C052";
         out.term_en = "Order Block (OB)";
         out.term_ru = "Order Block";
         out.family = "pd_array";
         out.kind = "origin-zone";
         out.origin = "ICT term; rule variants";
         out.status = "primary-linked; boundary variants pending";
         out.code_status = "Python proxy prototype, explicitly non-canonical";
         out.source_refs = "40,34,42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C053:
         out.id = SMC_ICT_C053;
         out.code = "C053";
         out.term_en = "Breaker Block";
         out.term_ru = "Breaker Block";
         out.family = "pd_array";
         out.kind = "failed-zone-flip";
         out.origin = "ICT primary term";
         out.status = "primary/secondary linked; failure-state variants pending";
         out.code_status = "not coded";
         out.source_refs = "42,45,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C054:
         out.id = SMC_ICT_C054;
         out.code = "C054";
         out.term_en = "Mitigation Block";
         out.term_ru = "Mitigation Block";
         out.family = "pd_array";
         out.kind = "failed-swing-zone";
         out.origin = "ICT term; distinction varies";
         out.status = "secondary-seeded; breaker distinction under primary review";
         out.code_status = "not coded";
         out.source_refs = "42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C055:
         out.id = SMC_ICT_C055;
         out.code = "C055";
         out.term_en = "Rejection Block";
         out.term_ru = "Rejection Block";
         out.family = "pd_array";
         out.kind = "wick-zone";
         out.origin = "ICT term";
         out.status = "secondary-seeded; wick/body threshold pending";
         out.code_status = "not coded";
         out.source_refs = "42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C056:
         out.id = SMC_ICT_C056;
         out.code = "C056";
         out.term_en = "Propulsion Block";
         out.term_ru = "Propulsion Block";
         out.family = "pd_array";
         out.kind = "continuation-zone";
         out.origin = "ICT/community term";
         out.status = "secondary/community definition; primary timestamp pending";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C057:
         out.id = SMC_ICT_C057;
         out.code = "C057";
         out.term_en = "Vacuum Block";
         out.term_ru = "Vacuum Block";
         out.family = "pd_array";
         out.kind = "gap-zone";
         out.origin = "community/variant";
         out.status = "candidate; no canonical rule located";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C058:
         out.id = SMC_ICT_C058;
         out.code = "C058";
         out.term_en = "Hidden Order Block";
         out.term_ru = "Скрытый Order Block";
         out.family = "pd_array";
         out.kind = "zone-variant";
         out.origin = "community candidate";
         out.status = "discovery-only; definition pending";
         out.code_status = "not coded";
         out.source_refs = "43,41";
         out.support = SMC_ICT_SUPPORT_MANUAL_REVIEW;
         return true;
      case SMC_ICT_C059:
         out.id = SMC_ICT_C059;
         out.code = "C059";
         out.term_en = "Reclaimed Order Block";
         out.term_ru = "Возвращённый/восстановленный Order Block";
         out.family = "pd_array";
         out.kind = "zone-state";
         out.origin = "community candidate";
         out.status = "candidate; compare with breaker/mitigation";
         out.code_status = "not coded";
         out.source_refs = "43,41";
         out.support = SMC_ICT_SUPPORT_MANUAL_REVIEW;
         return true;
      case SMC_ICT_C060:
         out.id = SMC_ICT_C060;
         out.code = "C060";
         out.term_en = "First Presented Fair Value Gap";
         out.term_ru = "Первый FVG после сессионного открытия";
         out.family = "pd_array";
         out.kind = "session-conditioned-zone";
         out.origin = "ICT/community terminology";
         out.status = "secondary-seeded; window/qualification pending";
         out.code_status = "not coded";
         out.source_refs = "42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C061:
         out.id = SMC_ICT_C061;
         out.code = "C061";
         out.term_en = "New Day Opening Gap (NDOG)";
         out.term_ru = "Дневной opening gap";
         out.family = "pd_array";
         out.kind = "opening-gap";
         out.origin = "ICT reference term";
         out.status = "secondary-seeded; market-specific session boundary pending";
         out.code_status = "not coded";
         out.source_refs = "42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C062:
         out.id = SMC_ICT_C062;
         out.code = "C062";
         out.term_en = "New Week Opening Gap (NWOG)";
         out.term_ru = "Недельный opening gap";
         out.family = "pd_array";
         out.kind = "opening-gap";
         out.origin = "ICT reference term";
         out.status = "secondary-seeded; instrument-specific";
         out.code_status = "not coded";
         out.source_refs = "42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C063:
         out.id = SMC_ICT_C063;
         out.code = "C063";
         out.term_en = "Opening Range Gap (ORG)";
         out.term_ru = "Разрыв regular-session opening";
         out.family = "pd_array";
         out.kind = "opening-gap";
         out.origin = "ICT/SMC-adjacent reference";
         out.status = "secondary-seeded; market-specific";
         out.code_status = "not coded";
         out.source_refs = "42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C064:
         out.id = SMC_ICT_C064;
         out.code = "C064";
         out.term_en = "Premium/Discount Array (PD Array)";
         out.term_ru = "PD Array";
         out.family = "pd_array";
         out.kind = "umbrella";
         out.origin = "ICT primary umbrella";
         out.status = "source-linked; membership varies by lesson";
         out.code_status = "catalogue registry pending";
         out.source_refs = "40,41,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C065:
         out.id = SMC_ICT_C065;
         out.code = "C065";
         out.term_en = "PD Array Matrix / Hierarchy";
         out.term_ru = "Матрица / иерархия PD Arrays";
         out.family = "pd_array";
         out.kind = "priority-framework";
         out.origin = "ICT/community taxonomy";
         out.status = "variant-conflict flagged; no universal ranking";
         out.code_status = "not coded";
         out.source_refs = "41,42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C066:
         out.id = SMC_ICT_C066;
         out.code = "C066";
         out.term_en = "Point of Interest (POI)";
         out.term_ru = "Точка интереса";
         out.family = "pd_array";
         out.kind = "general-reference";
         out.origin = "general trading term";
         out.status = "secondary-seeded; generic term";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C067:
         out.id = SMC_ICT_C067;
         out.code = "C067";
         out.term_en = "Redelivered Rebalanced Price Range (RDRB)";
         out.term_ru = "Повторно доставленный сбалансированный диапазон";
         out.family = "pd_array";
         out.kind = "range-state";
         out.origin = "newer/community term";
         out.status = "candidate; primary confirmation pending";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C068:
         out.id = SMC_ICT_C068;
         out.code = "C068";
         out.term_en = "Suspension Block";
         out.term_ru = "Suspension Block";
         out.family = "pd_array";
         out.kind = "newer-zone";
         out.origin = "newer ICT term (2025), secondary summary";
         out.status = "candidate; primary lesson timestamp pending";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C069:
         out.id = SMC_ICT_C069;
         out.code = "C069";
         out.term_en = "Failure Swing";
         out.term_ru = "Неудавшийся swing";
         out.family = "structure/pd_array";
         out.kind = "failed-breakout";
         out.origin = "ICT/SMC usage";
         out.status = "secondary-seeded; failure sequence pending";
         out.code_status = "not coded";
         out.source_refs = "42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C070:
         out.id = SMC_ICT_C070;
         out.code = "C070";
         out.term_en = "Dealing Range (DR)";
         out.term_ru = "Рабочий торговый диапазон";
         out.family = "range";
         out.kind = "reference-range";
         out.origin = "ICT term";
         out.status = "source-linked; anchors require rule version";
         out.code_status = "not coded";
         out.source_refs = "42,41,34";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C071:
         out.id = SMC_ICT_C071;
         out.code = "C071";
         out.term_en = "Equilibrium (EQ)";
         out.term_ru = "Равновесие, 50% диапазона";
         out.family = "range";
         out.kind = "reference-price";
         out.origin = "ICT/SMC shared";
         out.status = "source-linked; range dependency explicit";
         out.code_status = "not coded";
         out.source_refs = "42,34";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C072:
         out.id = SMC_ICT_C072;
         out.code = "C072";
         out.term_en = "Premium / Discount Classification";
         out.term_ru = "Классификация premium/discount";
         out.family = "range";
         out.kind = "location-filter";
         out.origin = "ICT/SMC shared";
         out.status = "secondary/primary references; range selection pending";
         out.code_status = "not coded";
         out.source_refs = "42,34,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C073:
         out.id = SMC_ICT_C073;
         out.code = "C073";
         out.term_en = "Optimal Trade Entry (OTE)";
         out.term_ru = "Зона оптимального входа";
         out.family = "range";
         out.kind = "retracement-zone";
         out.origin = "ICT term";
         out.status = "primary-linked; fib anchoring variants pending";
         out.code_status = "not coded";
         out.source_refs = "36,42,47";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C074:
         out.id = SMC_ICT_C074;
         out.code = "C074";
         out.term_en = "OTE Fibonacci Levels 0.62/0.705/0.79";
         out.term_ru = "Уровни OTE 62/70,5/79%";
         out.family = "range";
         out.kind = "measurement-levels";
         out.origin = "ICT/practitioner conventions";
         out.status = "secondary-seeded; anchor convention pending";
         out.code_status = "not coded";
         out.source_refs = "42,41,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C075:
         out.id = SMC_ICT_C075;
         out.code = "C075";
         out.term_en = "Standard Deviation Projections";
         out.term_ru = "Проекции стандартного отклонения";
         out.family = "range";
         out.kind = "projection-tool";
         out.origin = "ICT analysis tool";
         out.status = "discovery-seeded; formula variant pending";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C076:
         out.id = SMC_ICT_C076;
         out.code = "C076";
         out.term_en = "ADR / 5ADR";
         out.term_ru = "Средний дневной диапазон";
         out.family = "range";
         out.kind = "range-statistic";
         out.origin = "supplementary measurement";
         out.status = "technical supplement; period formula pending";
         out.code_status = "not coded";
         out.source_refs = "43,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C077:
         out.id = SMC_ICT_C077;
         out.code = "C077";
         out.term_en = "Interbank Price Delivery Algorithm (IPDA)";
         out.term_ru = "IPDA, модель доставки цены";
         out.family = "range/context";
         out.kind = "teaching-model";
         out.origin = "ICT teaching model";
         out.status = "primary/secondary linked; interpretive not directly observable";
         out.code_status = "context label only";
         out.source_refs = "42,40,45";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C078:
         out.id = SMC_ICT_C078;
         out.code = "C078";
         out.term_en = "IPDA 20/40/60-Day Data Ranges";
         out.term_ru = "Диапазоны данных IPDA 20/40/60 дней";
         out.family = "range";
         out.kind = "lookback-levels";
         out.origin = "ICT teaching tool";
         out.status = "secondary-seeded; time-series calendar pending";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C079:
         out.id = SMC_ICT_C079;
         out.code = "C079";
         out.term_en = "Quarterly Shift";
         out.term_ru = "Квартальный сдвиг";
         out.family = "range/time";
         out.kind = "regime-hypothesis";
         out.origin = "ICT usage";
         out.status = "secondary-seeded; not a precise deterministic signal";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C080:
         out.id = SMC_ICT_C080;
         out.code = "C080";
         out.term_en = "Quarterly Theory (QT)";
         out.term_ru = "Quarterly Theory";
         out.family = "range/time";
         out.kind = "time-partition";
         out.origin = "community framework";
         out.status = "community-only; verify author/timezone rules";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_MANUAL_REVIEW;
         return true;
      case SMC_ICT_C081:
         out.id = SMC_ICT_C081;
         out.code = "C081";
         out.term_en = "Daily Profile";
         out.term_ru = "Дневной профиль";
         out.family = "profile";
         out.kind = "session-model";
         out.origin = "ICT profile family";
         out.status = "secondary-seeded; taxonomy/labels pending";
         out.code_status = "not coded";
         out.source_refs = "42,34,49";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C082:
         out.id = SMC_ICT_C082;
         out.code = "C082";
         out.term_en = "Weekly Profile";
         out.term_ru = "Недельный профиль";
         out.family = "profile";
         out.kind = "session-model";
         out.origin = "ICT profile family";
         out.status = "secondary-seeded; profile labels pending";
         out.code_status = "not coded";
         out.source_refs = "42,34,46";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C083:
         out.id = SMC_ICT_C083;
         out.code = "C083";
         out.term_en = "Monthly Profile";
         out.term_ru = "Месячный профиль";
         out.family = "profile";
         out.kind = "session-model";
         out.origin = "ICT/profile usage";
         out.status = "secondary-seeded; primary rule pending";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C084:
         out.id = SMC_ICT_C084;
         out.code = "C084";
         out.term_en = "True Day Open (TDO)";
         out.term_ru = "Истинное открытие торгового дня";
         out.family = "time/levels";
         out.kind = "reference-level";
         out.origin = "ICT/futures convention";
         out.status = "secondary/primary context linked; instrument boundary must be fixed";
         out.code_status = "not coded";
         out.source_refs = "41,42,50";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C085:
         out.id = SMC_ICT_C085;
         out.code = "C085";
         out.term_en = "New York Midnight Open (MNO)";
         out.term_ru = "Открытие Нью-Йоркской полуночи";
         out.family = "time/levels";
         out.kind = "reference-level";
         out.origin = "ICT primary reference";
         out.status = "primary-linked; chart time alignment pending";
         out.code_status = "not coded";
         out.source_refs = "50,36,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C086:
         out.id = SMC_ICT_C086;
         out.code = "C086";
         out.term_en = "Daily Open";
         out.term_ru = "Дневное открытие инструмента";
         out.family = "time/levels";
         out.kind = "reference-level";
         out.origin = "general/ICT reference";
         out.status = "source-linked; daily-session definition pending";
         out.code_status = "not coded";
         out.source_refs = "42,50";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C087:
         out.id = SMC_ICT_C087;
         out.code = "C087";
         out.term_en = "Weekly Open";
         out.term_ru = "Недельное открытие";
         out.family = "time/levels";
         out.kind = "reference-level";
         out.origin = "ICT/futures reference";
         out.status = "secondary-seeded; instrument calendar pending";
         out.code_status = "not coded";
         out.source_refs = "41,42,46";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C088:
         out.id = SMC_ICT_C088;
         out.code = "C088";
         out.term_en = "8:30 New York Open";
         out.term_ru = "Открытие 8:30 по Нью-Йорку";
         out.family = "time/levels";
         out.kind = "reference-level";
         out.origin = "ICT primary reference";
         out.status = "primary-linked; event-vs-session role to disambiguate";
         out.code_status = "not coded";
         out.source_refs = "50,36,49";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C089:
         out.id = SMC_ICT_C089;
         out.code = "C089";
         out.term_en = "9:30 NY Cash Open";
         out.term_ru = "Открытие cash-сессии США 9:30";
         out.family = "time/levels";
         out.kind = "reference-level";
         out.origin = "ICT/session context";
         out.status = "primary/context linked; asset scope explicit";
         out.code_status = "not coded";
         out.source_refs = "50,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C090:
         out.id = SMC_ICT_C090;
         out.code = "C090";
         out.term_en = "Settlement Price";
         out.term_ru = "Расчётная цена закрытия";
         out.family = "time/levels";
         out.kind = "reference-level";
         out.origin = "supplementary market reference";
         out.status = "definition depends on exchange feed";
         out.code_status = "not coded";
         out.source_refs = "41,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C091:
         out.id = SMC_ICT_C091;
         out.code = "C091";
         out.term_en = "Previous Session Range";
         out.term_ru = "Диапазон предыдущей сессии";
         out.family = "time/levels";
         out.kind = "reference-range";
         out.origin = "ICT reference tool";
         out.status = "source-linked; windows vary by teaching/instrument";
         out.code_status = "not coded";
         out.source_refs = "33,36,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C092:
         out.id = SMC_ICT_C092;
         out.code = "C092";
         out.term_en = "Asian Range";
         out.term_ru = "Азиатский диапазон";
         out.family = "session";
         out.kind = "session-range";
         out.origin = "ICT primary/session term";
         out.status = "primary-linked; exact time convention versioned";
         out.code_status = "not coded";
         out.source_refs = "34,36,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C093:
         out.id = SMC_ICT_C093;
         out.code = "C093";
         out.term_en = "Asian Kill Zone";
         out.term_ru = "Азиатское окно внимания";
         out.family = "session";
         out.kind = "time-filter";
         out.origin = "ICT/community timing term";
         out.status = "source conflict; timezone/hour convention pending";
         out.code_status = "not coded";
         out.source_refs = "42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C094:
         out.id = SMC_ICT_C094;
         out.code = "C094";
         out.term_en = "London Open Kill Zone";
         out.term_ru = "London Open Kill Zone";
         out.family = "session";
         out.kind = "time-filter";
         out.origin = "ICT primary session term";
         out.status = "primary-linked; test DST conversion";
         out.code_status = "not coded";
         out.source_refs = "33,36,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C095:
         out.id = SMC_ICT_C095;
         out.code = "C095";
         out.term_en = "New York AM / Open Kill Zone";
         out.term_ru = "New York AM Kill Zone";
         out.family = "session";
         out.kind = "time-filter";
         out.origin = "ICT primary, product-specific";
         out.status = "primary-linked; FX/index windows separate variants";
         out.code_status = "not coded";
         out.source_refs = "33,36,39,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C096:
         out.id = SMC_ICT_C096;
         out.code = "C096";
         out.term_en = "New York PM Session";
         out.term_ru = "Нью-Йоркская дневная сессия";
         out.family = "session";
         out.kind = "time-context";
         out.origin = "ICT primary session topic";
         out.status = "primary-linked; session model pending";
         out.code_status = "not coded";
         out.source_refs = "34,39,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C097:
         out.id = SMC_ICT_C097;
         out.code = "C097";
         out.term_en = "London Close Kill Zone";
         out.term_ru = "London Close Kill Zone";
         out.family = "session";
         out.kind = "time-filter";
         out.origin = "ICT/community timing term";
         out.status = "secondary-seeded; verify author-specific boundaries";
         out.code_status = "not coded";
         out.source_refs = "42,41";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C098:
         out.id = SMC_ICT_C098;
         out.code = "C098";
         out.term_en = "New York Lunch";
         out.term_ru = "Обеденное окно Нью-Йорка";
         out.family = "session";
         out.kind = "time-filter";
         out.origin = "ICT teaching topic";
         out.status = "primary-linked; source times need normalization";
         out.code_status = "not coded";
         out.source_refs = "49,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C099:
         out.id = SMC_ICT_C099;
         out.code = "C099";
         out.term_en = "ICT Macro Times";
         out.term_ru = "Макро-окна ICT";
         out.family = "session";
         out.kind = "time-filter";
         out.origin = "ICT term; schedule varies";
         out.status = "secondary/primary candidate; exact list is versioned";
         out.code_status = "not coded";
         out.source_refs = "47,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C100:
         out.id = SMC_ICT_C100;
         out.code = "C100";
         out.term_en = "Red Folder News Filter";
         out.term_ru = "Фильтр новостей высокого влияния";
         out.family = "risk/context";
         out.kind = "event-filter";
         out.origin = "supplementary ICT process";
         out.status = "context rule; no performance claim";
         out.code_status = "not coded";
         out.source_refs = "42,49";
         out.support = SMC_ICT_SUPPORT_CONTEXT_ONLY;
         return true;
      case SMC_ICT_C101:
         out.id = SMC_ICT_C101;
         out.code = "C101";
         out.term_en = "Seasonal Tendencies";
         out.term_ru = "Сезонные тенденции";
         out.family = "context";
         out.kind = "statistical-filter";
         out.origin = "ICT/community context";
         out.status = "candidate; no trading edge assumed";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_CONTEXT_ONLY;
         return true;
      case SMC_ICT_C102:
         out.id = SMC_ICT_C102;
         out.code = "C102";
         out.term_en = "COT Positioning Filter";
         out.term_ru = "Фильтр Commitments of Traders";
         out.family = "context";
         out.kind = "external-data-filter";
         out.origin = "supplementary market-data filter";
         out.status = "not a core ICT pattern; external data specification pending";
         out.code_status = "not coded";
         out.source_refs = "43";
         out.support = SMC_ICT_SUPPORT_EXTERNAL_DATA;
         return true;
      case SMC_ICT_C103:
         out.id = SMC_ICT_C103;
         out.code = "C103";
         out.term_en = "Power of Three (PO3) / AMD";
         out.term_ru = "Power of Three: накопление–манипуляция–распределение";
         out.family = "model";
         out.kind = "three-phase-model";
         out.origin = "ICT primary model";
         out.status = "primary-linked; phase boundaries require operational rules";
         out.code_status = "not coded";
         out.source_refs = "34,36,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C104:
         out.id = SMC_ICT_C104;
         out.code = "C104";
         out.term_en = "Judas Swing";
         out.term_ru = "Judas Swing";
         out.family = "model";
         out.kind = "session-pattern";
         out.origin = "ICT primary term";
         out.status = "primary-linked; directional narrative remains hypothesis";
         out.code_status = "not coded";
         out.source_refs = "34,36,47,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C105:
         out.id = SMC_ICT_C105;
         out.code = "C105";
         out.term_en = "Market Maker Buy / Sell Model (MMBM/MMSM)";
         out.term_ru = "Market Maker Buy/Sell Model";
         out.family = "model";
         out.kind = "multi-phase-model";
         out.origin = "ICT primary model family";
         out.status = "primary-linked; phase chart/variant audit pending";
         out.code_status = "not coded";
         out.source_refs = "46,47,42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C106:
         out.id = SMC_ICT_C106;
         out.code = "C106";
         out.term_en = "Smart Money Reversal (SMR)";
         out.term_ru = "Разворот Smart Money";
         out.family = "model";
         out.kind = "model-phase";
         out.origin = "ICT/MM model vocabulary";
         out.status = "secondary/community taxonomy; primary timestamp pending";
         out.code_status = "not coded";
         out.source_refs = "43,46,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C107:
         out.id = SMC_ICT_C107;
         out.code = "C107";
         out.term_en = "Terminus";
         out.term_ru = "Конечная цель модели";
         out.family = "model";
         out.kind = "target-concept";
         out.origin = "ICT/community model vocabulary";
         out.status = "secondary-seeded; model-specific rules pending";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C108:
         out.id = SMC_ICT_C108;
         out.code = "C108";
         out.term_en = "ICT 2022 Model";
         out.term_ru = "Модель ICT 2022";
         out.family = "model";
         out.kind = "entry-model";
         out.origin = "ICT primary series; later shorthand";
         out.status = "primary series linked; consolidated rule still needs episode-by-episode audit";
         out.code_status = "Python features support only primitives, not full strategy";
         out.source_refs = "30,9,32,33,39,42";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C109:
         out.id = SMC_ICT_C109;
         out.code = "C109";
         out.term_en = "Institutional Order Flow Entry Drill (IOFED)";
         out.term_ru = "IOFED, упражнение входа по потоку ордеров";
         out.family = "model";
         out.kind = "entry-technique";
         out.origin = "ICT/community abbreviation";
         out.status = "secondary-seeded; primary wording pending";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C110:
         out.id = SMC_ICT_C110;
         out.code = "C110";
         out.term_en = "One Shot One Kill (OSOK)";
         out.term_ru = "One Shot One Kill";
         out.family = "model";
         out.kind = "named-model";
         out.origin = "ICT named model, details pending";
         out.status = "candidate; primary lesson/timecode pending";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C111:
         out.id = SMC_ICT_C111;
         out.code = "C111";
         out.term_en = "Silver Bullet";
         out.term_ru = "Silver Bullet";
         out.family = "model";
         out.kind = "time-boxed-entry-model";
         out.origin = "ICT model/community shorthand";
         out.status = "secondary-seeded; original 2023 lesson timecode pending";
         out.code_status = "not coded";
         out.source_refs = "42,41,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C112:
         out.id = SMC_ICT_C112;
         out.code = "C112";
         out.term_en = "Unicorn Model";
         out.term_ru = "Модель Unicorn";
         out.family = "model";
         out.kind = "confluence-model";
         out.origin = "ICT/community model";
         out.status = "secondary-seeded; overlap rule pending";
         out.code_status = "not coded";
         out.source_refs = "42,41,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C113:
         out.id = SMC_ICT_C113;
         out.code = "C113";
         out.term_en = "Venom Model";
         out.term_ru = "Модель Venom";
         out.family = "model";
         out.kind = "newer-session-model";
         out.origin = "newer ICT model (2025), secondary source";
         out.status = "candidate; primary lesson/timecode pending";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C114:
         out.id = SMC_ICT_C114;
         out.code = "C114";
         out.term_en = "TGIF Setup";
         out.term_ru = "Пятничная модель TGIF";
         out.family = "model";
         out.kind = "weekly-session-model";
         out.origin = "ICT named setup";
         out.status = "secondary-seeded; primary rules pending";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C115:
         out.id = SMC_ICT_C115;
         out.code = "C115";
         out.term_en = "Seek and Destroy Profile";
         out.term_ru = "Профиль Seek and Destroy";
         out.family = "model";
         out.kind = "no-trade/profile";
         out.origin = "ICT term";
         out.status = "source-linked; measurable churn threshold pending";
         out.code_status = "not coded";
         out.source_refs = "42,47";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C116:
         out.id = SMC_ICT_C116;
         out.code = "C116";
         out.term_en = "Candle Range Theory (CRT)";
         out.term_ru = "Candle Range Theory";
         out.family = "model";
         out.kind = "candle-range-setup";
         out.origin = "community framework";
         out.status = "community-only; do not label ICT-authored";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_MANUAL_REVIEW;
         return true;
      case SMC_ICT_C117:
         out.id = SMC_ICT_C117;
         out.code = "C117";
         out.term_en = "Reaper IFVG";
         out.term_ru = "Reaper IFVG";
         out.family = "model";
         out.kind = "IFVG-variant";
         out.origin = "newer/community variation";
         out.status = "candidate; definition and provenance pending";
         out.code_status = "not coded";
         out.source_refs = "42,43";
         out.support = SMC_ICT_SUPPORT_NOT_FORMALIZED;
         return true;
      case SMC_ICT_C118:
         out.id = SMC_ICT_C118;
         out.code = "C118";
         out.term_en = "Sweep → MSS → FVG Retrace";
         out.term_ru = "Комбинация sweep → MSS → возврат в FVG";
         out.family = "combination";
         out.kind = "entry-sequence";
         out.origin = "ICT 2022 model primitive sequence";
         out.status = "primary-linked; sequence rule is project operationalization";
         out.code_status = "Python primitives available; combo not coded";
         out.source_refs = "9,48,49,42";
         out.support = SMC_ICT_SUPPORT_COMBINATION;
         return true;
      case SMC_ICT_C119:
         out.id = SMC_ICT_C119;
         out.code = "C119";
         out.term_en = "Sweep → MSS → Order-Block Retest";
         out.term_ru = "Комбинация sweep → MSS → возврат в OB";
         out.family = "combination";
         out.kind = "entry-sequence";
         out.origin = "ICT/SMC practitioner model";
         out.status = "operational hypothesis; OB definition fork pending";
         out.code_status = "OB prototype only; combo pending";
         out.source_refs = "9,48,42,40";
         out.support = SMC_ICT_SUPPORT_COMBINATION;
         return true;
      case SMC_ICT_C120:
         out.id = SMC_ICT_C120;
         out.code = "C120";
         out.term_en = "OTE + PD Array Confluence";
         out.term_ru = "Совпадение OTE и PD Array";
         out.family = "combination";
         out.kind = "location-confluence";
         out.origin = "ICT practitioner combination";
         out.status = "secondary-seeded; overlap threshold pending";
         out.code_status = "not coded";
         out.source_refs = "36,42,41";
         out.support = SMC_ICT_SUPPORT_COMBINATION;
         return true;
      case SMC_ICT_C121:
         out.id = SMC_ICT_C121;
         out.code = "C121";
         out.term_en = "SMT + Liquidity Sweep Confirmation";
         out.term_ru = "SMT-подтверждение sweep";
         out.family = "combination";
         out.kind = "intermarket-confirmation";
         out.origin = "ICT primary idea + combination hypothesis";
         out.status = "sources linked; synchronization formula pending";
         out.code_status = "not coded";
         out.source_refs = "45,46,42";
         out.support = SMC_ICT_SUPPORT_COMBINATION;
         return true;
      case SMC_ICT_C122:
         out.id = SMC_ICT_C122;
         out.code = "C122";
         out.term_en = "PO3 + Judas Session Profile";
         out.term_ru = "Сочетание PO3 и Judas Swing";
         out.family = "combination";
         out.kind = "session-sequence";
         out.origin = "ICT primary model combination";
         out.status = "primary references linked; session phase rule pending";
         out.code_status = "not coded";
         out.source_refs = "34,36,47";
         out.support = SMC_ICT_SUPPORT_COMBINATION;
         return true;
      case SMC_ICT_C123:
         out.id = SMC_ICT_C123;
         out.code = "C123";
         out.term_en = "Opening Gap + CE Rebalance";
         out.term_ru = "Возврат в opening gap до CE";
         out.family = "combination";
         out.kind = "range-entry";
         out.origin = "ICT reference-level combination";
         out.status = "secondary-seeded; gap source/timezone pending";
         out.code_status = "not coded";
         out.source_refs = "41,42";
         out.support = SMC_ICT_SUPPORT_COMBINATION;
         return true;
      case SMC_ICT_C124:
         out.id = SMC_ICT_C124;
         out.code = "C124";
         out.term_en = "MMXM Four-Phase Sequence";
         out.term_ru = "Четырёхфазный Market Maker Model";
         out.family = "combination";
         out.kind = "multi-phase-sequence";
         out.origin = "ICT/community model taxonomy";
         out.status = "discovery taxonomy; each phase needs primary source/timecode";
         out.code_status = "not coded";
         out.source_refs = "43,46,47";
         out.support = SMC_ICT_SUPPORT_COMBINATION;
         return true;
      case SMC_ICT_C125:
         out.id = SMC_ICT_C125;
         out.code = "C125";
         out.term_en = "New York Session Profile";
         out.term_ru = "Сценарий Нью-Йоркской сессии";
         out.family = "combination";
         out.kind = "session-model";
         out.origin = "ICT primary session framework";
         out.status = "primary sources linked; exact session profile labels pending";
         out.code_status = "not coded";
         out.source_refs = "33,36,39,50";
         out.support = SMC_ICT_SUPPORT_COMBINATION;
         return true;
      case SMC_ICT_C126:
         out.id = SMC_ICT_C126;
         out.code = "C126";
         out.term_en = "Intermarket Correlation Filter (DXY/FX or ES/NQ)";
         out.term_ru = "Межрыночный фильтр корреляции";
         out.family = "combination";
         out.kind = "intermarket-filter";
         out.origin = "ICT 2016 primary concept; quantitative rule project-defined";
         out.status = "primary concept linked; rolling-correlation/pair rules pending";
         out.code_status = "not coded";
         out.source_refs = "45,42";
         out.support = SMC_ICT_SUPPORT_COMBINATION;
         return true;
   }
   return false;
}

// OHLC validation used by the deterministic primitives below.
bool SMC_ICT_IsValidBar(const MqlRates &bar)
{
   if(bar.high < bar.low) return false;
   if(bar.open < bar.low || bar.open > bar.high) return false;
   if(bar.close < bar.low || bar.close > bar.high) return false;
   return true;
}

// Three chronological closed bars: bar1 is oldest, bar3 is newest.
// Outputs are valid only when the function returns true.
bool SMC_ICT_IsBullishFVG(const MqlRates &bar1, const MqlRates &bar2, const MqlRates &bar3, double &gap_low, double &gap_high)
{
   gap_low = 0.0;
   gap_high = 0.0;
   if(!SMC_ICT_IsValidBar(bar1) || !SMC_ICT_IsValidBar(bar2) || !SMC_ICT_IsValidBar(bar3)) return false;
   if(bar3.low <= bar1.high) return false;
   gap_low = bar1.high;
   gap_high = bar3.low;
   return true;
}

bool SMC_ICT_IsBearishFVG(const MqlRates &bar1, const MqlRates &bar2, const MqlRates &bar3, double &gap_low, double &gap_high)
{
   gap_low = 0.0;
   gap_high = 0.0;
   if(!SMC_ICT_IsValidBar(bar1) || !SMC_ICT_IsValidBar(bar2) || !SMC_ICT_IsValidBar(bar3)) return false;
   if(bar3.high >= bar1.low) return false;
   gap_low = bar3.high;
   gap_high = bar1.low;
   return true;
}

bool SMC_ICT_IsCloseBreak(const double close_price, const double reference_level, const ENUM_SMC_ICT_DIRECTION direction)
{
   if(direction == SMC_ICT_DIRECTION_BULLISH) return close_price > reference_level;
   if(direction == SMC_ICT_DIRECTION_BEARISH) return close_price < reference_level;
   return false;
}

// Buy-side sweep: high pierces level and close returns below. Sell-side is mirrored.
bool SMC_ICT_IsLiquiditySweep(const MqlRates &bar, const double reference_level, const ENUM_SMC_ICT_SWEEP_SIDE side)
{
   if(!SMC_ICT_IsValidBar(bar)) return false;
   if(side == SMC_ICT_SWEEP_BUY_SIDE) return (bar.high > reference_level && bar.close < reference_level);
   if(side == SMC_ICT_SWEEP_SELL_SIDE) return (bar.low < reference_level && bar.close > reference_level);
   return false;
}

// Rates must be chronological oldest->newest. A pivot is unavailable until right_bars exist.
// Strict comparisons intentionally reject ties; caller should plot only after confirmation.
bool SMC_ICT_IsConfirmedSwingHigh(const MqlRates &rates[], const int index, const int left_bars, const int right_bars, double &price)
{
   price = 0.0;
   const int total = ArraySize(rates);
   if(left_bars < 1 || right_bars < 1 || index < left_bars || index + right_bars >= total) return false;
   for(int i = index - left_bars; i <= index + right_bars; ++i)
   {
      if(i == index) continue;
      if(rates[i].high >= rates[index].high) return false;
   }
   price = rates[index].high;
   return true;
}

bool SMC_ICT_IsConfirmedSwingLow(const MqlRates &rates[], const int index, const int left_bars, const int right_bars, double &price)
{
   price = 0.0;
   const int total = ArraySize(rates);
   if(left_bars < 1 || right_bars < 1 || index < left_bars || index + right_bars >= total) return false;
   for(int i = index - left_bars; i <= index + right_bars; ++i)
   {
      if(i == index) continue;
      if(rates[i].low <= rates[index].low) return false;
   }
   price = rates[index].low;
   return true;
}

#endif // SMC_ICT_LIBRARY_MQH
