//< 1. Property >==============================================================================================//<  1>
                                                                                                               //<  2>
#property     copyright                 "Copyright (C) 2009, MetaQuotes Software Corp."                        //<  3>
#property     link                      "http://www.metaquotes.net"                                            //<  4>
                                                                                                               //<  5>
#define       A.System.Series           "AIS"                                                                  //<  6>
#define       A.System.Modification     "10316"                                                                //<  7>
#define       A.System.ReleaseDate      "26.02.2009"                                                           //<  8>
#define       A.System.Program          "Advanced Indicator"                                                   //<  9>
#define       A.System.Programmer       "Airat Safin                            http://www.mql4.com/users/Ais" //< 10>
                                                                                                               //< 11>
//</1. Property >==============================================================================================//< 12>
                                                                                                               //< 13>
//< 2. Program     >===========================================================================================//< 14>
                                                                                                               //< 15>
//< 2.1. Global Data >-----------------------------------------------------------------------------------------//< 16>
                                                                                                               //< 17>
string        A.System.Name           = "A System"                                                           ; //< 18>
                                                                                                               //< 19>
string        A.System.Stamp                                                                                 ; //< 20>
                                                                                                               //< 21>
#property     indicator_chart_window                                                                           //< 22>
                                                                                                               //< 23>
double        arv.Chart          [] = { EMPTY                                                                , //< 24>
                                        EMPTY                                                                , //< 25>
                                        EMPTY                                                                , //< 26>
                                        EMPTY                                                                , //< 27>
                                        EMPTY                                                                , //< 28>
                                        EMPTY                                                                , //< 29>
                                        EMPTY                                                                , //< 30>
                                        EMPTY                                                                , //< 31>
                                        EMPTY                                                                , //< 32>
                                        EMPTY                                                              } ; //< 33>
                                                                                                               //< 34>
#define       ari.ZeroTime              0                                                                      //< 35>
#define       ari.Resolution.H          1                                                                      //< 36>
#define       ari.LastBar               2                                                                      //< 37>
#define       ari.FirstBar              3                                                                      //< 38>
#define       ari.TotalBars             4                                                                      //< 39>
#define       ari.ShiftBars             5                                                                      //< 40>
#define       ari.PriceMax              6                                                                      //< 41>
#define       ari.PriceMin              7                                                                      //< 42>
#define       ari.PriceRange            8                                                                      //< 43>
#define       ari.Resolution.V          9                                                                      //< 44>
                                                                                                               //< 45>
#define       acs.Ask                   "Ask"                                                                  //< 46>
#define       acs.Bid                   "Bid"                                                                  //< 47>
#define       acs.Price                 "Price"                                                                //< 48>
#define       acs.Spread                "Spread"                                                               //< 49>
#define       acs.MarginHigh            "MarginHigh"                                                           //< 50>
#define       acs.MarginLow             "MarginLow"                                                            //< 51>
#define       acs.StopsHigh             "StopsHigh"                                                            //< 52>
#define       acs.StopsLow              "StopsLow"                                                             //< 53>
#define       acs.BeginTime             "BeginTime"                                                            //< 54>
#define       acs.EndTime               "EndTime"                                                              //< 55>
#define       acs.SuperTrend            "SuperTrend"                                                           //< 56>
#define       acs.SuperLabel            "SuperLabel"                                                           //< 57>
#define       acs.MaxMinTrend           "MaxMinTrend"                                                          //< 58>
#define       acs.MaxMinLabel           "MaxMinLabel"                                                          //< 59>
#define       acs.ZeroTrend             "ZeroTrend"                                                            //< 60>
#define       acs.ZeroMaxTrend          "ZeroMaxTrend"                                                         //< 61>
#define       acs.ZeroMaxLevel          "ZeroMaxLevel"                                                         //< 62>
#define       acs.ZeroMinTrend          "ZeroMinTrend"                                                         //< 63>
#define       acs.ZeroMinLevel          "ZeroMinLevel"                                                         //< 64>
#define       acs.MaxPrice              "MaxPrice"                                                             //< 65>
#define       acs.MinPrice              "MinPrice"                                                             //< 66>
#define       acs.MaxTime               "MaxTime"                                                              //< 67>
#define       acs.MinTime               "MinTime"                                                              //< 68>
#define       acs.MaxPeak               "MaxPeak"                                                              //< 69>
#define       acs.MinPeak               "MinPeak"                                                              //< 70>
#define       acs.MaxInterval           "MaxInterval"                                                          //< 71>
#define       acs.MinInterval           "MinInterval"                                                          //< 72>
#define       acs.OverlapMaximum        "OverlapMaximum"                                                       //< 73>
#define       acs.OverlapAverage        "OverlapAverage"                                                       //< 74>
#define       acs.VolatilityMaximum     "VolatilityMaximum"                                                    //< 75>
#define       acs.VolatilityAverage     "VolatilityAverage"                                                    //< 76>
                                                                                                               //< 77>
string        avs.Ask                                                                                        ; //< 78>
string        avs.Bid                                                                                        ; //< 79>
string        avs.Price                                                                                      ; //< 80>
string        avs.Spread                                                                                     ; //< 81>
string        avs.MarginHigh                                                                                 ; //< 82>
string        avs.MarginLow                                                                                  ; //< 83>
string        avs.StopsHigh                                                                                  ; //< 84>
string        avs.StopsLow                                                                                   ; //< 85>
string        avs.BeginTime                                                                                  ; //< 86>
string        avs.EndTime                                                                                    ; //< 87>
string        avs.SuperTrend                                                                                 ; //< 88>
string        avs.SuperLabel                                                                                 ; //< 89>
string        avs.MaxMinTrend                                                                                ; //< 90>
string        avs.MaxMinLabel                                                                                ; //< 91>
string        avs.ZeroTrend                                                                                  ; //< 92>
string        avs.ZeroMaxTrend                                                                               ; //< 93>
string        avs.ZeroMaxLevel                                                                               ; //< 94>
string        avs.ZeroMinTrend                                                                               ; //< 95>
string        avs.ZeroMinLevel                                                                               ; //< 96>
string        avs.MaxPrice                                                                                   ; //< 97>
string        avs.MinPrice                                                                                   ; //< 98>
string        avs.MaxTime                                                                                    ; //< 99>
string        avs.MinTime                                                                                    ; //<100>
string        avs.MaxPeak                                                                                    ; //<101>
string        avs.MinPeak                                                                                    ; //<102>
string        avs.MaxInterval                                                                                ; //<103>
string        avs.MinInterval                                                                                ; //<104>
string        avs.OverlapMaximum                                                                             ; //<105>
string        avs.OverlapAverage                                                                             ; //<106>
string        avs.VolatilityMaximum                                                                          ; //<107>
string        avs.VolatilityAverage                                                                          ; //<108>
                                                                                                               //<109>
string        avs.Prefix                                                                                     ; //<110>
                                                                                                               //<111>
string        avs.PrefixMetrics                                                                              ; //<112>
string        avs.PrefixAskBars                                                                              ; //<113>
string        avs.PrefixBidBars                                                                              ; //<114>
string        avs.PrefixOverlap                                                                              ; //<115>
string        avs.PrefixSynthBars                                                                            ; //<116>
string        avs.PrefixSynthMean                                                                            ; //<117>
string        avs.PrefixSynthSlopeA                                                                          ; //<118>
string        avs.PrefixSynthSlopeB                                                                          ; //<119>
                                                                                                               //<120>
string        avs.SetupMetrics                                                                               ; //<121>
string        avs.SetupOrderLevels                                                                           ; //<122>
string        avs.SetupChartFrames                                                                           ; //<123>
string        avs.SetupSynthFrames                                                                           ; //<124>
string        avs.SetupSynth                                                                                 ; //<125>
                                                                                                               //<126>
int           avi.FlagMetricsShow                                                                            ; //<127>
int           avi.FlagMetricsCreate                                                                          ; //<128>
int           avi.FlagOrderLevelsShow                                                                        ; //<129>
int           avi.FlagOrderLevelsCreate                                                                      ; //<130>
int           avi.FlagChartFramesShow                                                                        ; //<131>
int           avi.FlagChartFramesCreate                                                                      ; //<132>
int           avi.FlagSynthFramesShow                                                                        ; //<133>
int           avi.FlagSynthFramesCreate                                                                      ; //<134>
                                                                                                               //<135>
double        avd.Overlap []                                                                                 ; //<136>
int           avi.Synths                                                                                     ; //<137>
                                                                                                               //<138>
string        avs.Symbol                                                                                     ; //<139>
int           avi.Period                                                                                     ; //<140>
int           avi.Synth                                                                                      ; //<141>
                                                                                                               //<142>
//</2.1. Global Data >-----------------------------------------------------------------------------------------//<143>
                                                                                                               //<144>
//< 2.2. Special Functions >-----------------------------------------------------------------------------------//<145>
                                                                                                               //<146>
//< A.System.Indicator: Function init >````````````````````````````````````````````````````````````````````````//<147>
                                                                                                               //<148>
int    init   ()                                                                                               //<149>
{                                                                                                              //<150>
avs.Symbol                            = Symbol ()                                                            ; //<151>
avi.Period                            = Period ()                                                            ; //<152>
avi.Synth                             = PERIOD_D1                                                            ; //<153>
                                                                                                               //<154>
arv.Chart   [ ari.ZeroTime         ]  = EMPTY                                                                ; //<155>
arv.Chart   [ ari.Resolution.H     ]  = EMPTY                                                                ; //<156>
arv.Chart   [ ari.LastBar          ]  = EMPTY                                                                ; //<157>
arv.Chart   [ ari.PriceMax         ]  = EMPTY                                                                ; //<158>
arv.Chart   [ ari.PriceMin         ]  = EMPTY                                                                ; //<159>
                                                                                                               //<160>
avs.Prefix                            = A.System.Series   + A.System.Modification + "."                      ; //<161>
                                                                                                               //<162>
avs.SetupMetrics                      = avs.Prefix        + "Setup.Metrics"                                  ; //<163>
avs.SetupOrderLevels                  = avs.Prefix        + "Setup.OrderLevels"                              ; //<164>
avs.SetupChartFrames                  = avs.Prefix        + "Setup.ChartFrames"                              ; //<165>
avs.SetupSynthFrames                  = avs.Prefix        + "Setup.SynthFrames"                              ; //<166>
avs.SetupSynth                        = avs.Prefix        + "Setup.SynthSize"                                ; //<167>
                                                                                                               //<168>
avs.PrefixMetrics                     = avs.Prefix        + "Metric."                                        ; //<169>
avs.PrefixAskBars                     = avs.Prefix        + "AskBar."                                        ; //<170>
avs.PrefixBidBars                     = avs.Prefix        + "BidBar."                                        ; //<171>
avs.PrefixOverlap                     = avs.Prefix        + "OverlapBar."                                    ; //<172>
avs.PrefixSynthBars                   = avs.Prefix        + "SynthBar."                                      ; //<173>
avs.PrefixSynthMean                   = avs.Prefix        + "SynthMean."                                     ; //<174>
avs.PrefixSynthSlopeA                 = avs.Prefix        + "SynthSlopeA."                                   ; //<175>
avs.PrefixSynthSlopeB                 = avs.Prefix        + "SynthSlopeB."                                   ; //<176>
                                                                                                               //<177>
avs.Ask                               = avs.PrefixMetrics + acs.Ask                                          ; //<178>
avs.Bid                               = avs.PrefixMetrics + acs.Bid                                          ; //<179>
avs.Price                             = avs.PrefixMetrics + acs.Price                                        ; //<180>
avs.Spread                            = avs.PrefixMetrics + acs.Spread                                       ; //<181>
avs.MarginHigh                        = avs.PrefixMetrics + acs.MarginHigh                                   ; //<182>
avs.MarginLow                         = avs.PrefixMetrics + acs.MarginLow                                    ; //<183>
avs.StopsHigh                         = avs.PrefixMetrics + acs.StopsHigh                                    ; //<184>
avs.StopsLow                          = avs.PrefixMetrics + acs.StopsLow                                     ; //<185>
avs.BeginTime                         = avs.PrefixMetrics + acs.BeginTime                                    ; //<186>
avs.EndTime                           = avs.PrefixMetrics + acs.EndTime                                      ; //<187>
avs.SuperTrend                        = avs.PrefixMetrics + acs.SuperTrend                                   ; //<188>
avs.SuperLabel                        = avs.PrefixMetrics + acs.SuperLabel                                   ; //<189>
avs.MaxMinTrend                       = avs.PrefixMetrics + acs.MaxMinTrend                                  ; //<190>
avs.MaxMinLabel                       = avs.PrefixMetrics + acs.MaxMinLabel                                  ; //<191>
avs.ZeroTrend                         = avs.PrefixMetrics + acs.ZeroTrend                                    ; //<192>
avs.ZeroMaxTrend                      = avs.PrefixMetrics + acs.ZeroMaxTrend                                 ; //<193>
avs.ZeroMaxLevel                      = avs.PrefixMetrics + acs.ZeroMaxLevel                                 ; //<194>
avs.ZeroMinTrend                      = avs.PrefixMetrics + acs.ZeroMinTrend                                 ; //<195>
avs.ZeroMinLevel                      = avs.PrefixMetrics + acs.ZeroMinLevel                                 ; //<196>
avs.MaxPrice                          = avs.PrefixMetrics + acs.MaxPrice                                     ; //<197>
avs.MinPrice                          = avs.PrefixMetrics + acs.MinPrice                                     ; //<198>
avs.MaxTime                           = avs.PrefixMetrics + acs.MaxTime                                      ; //<199>
avs.MinTime                           = avs.PrefixMetrics + acs.MinTime                                      ; //<200>
avs.MaxPeak                           = avs.PrefixMetrics + acs.MaxPeak                                      ; //<201>
avs.MinPeak                           = avs.PrefixMetrics + acs.MinPeak                                      ; //<202>
avs.MaxInterval                       = avs.PrefixMetrics + acs.MaxInterval                                  ; //<203>
avs.MinInterval                       = avs.PrefixMetrics + acs.MinInterval                                  ; //<204>
avs.OverlapMaximum                    = avs.PrefixMetrics + acs.OverlapMaximum                               ; //<205>
avs.OverlapAverage                    = avs.PrefixMetrics + acs.OverlapAverage                               ; //<206>
avs.VolatilityMaximum                 = avs.PrefixMetrics + acs.VolatilityMaximum                            ; //<207>
avs.VolatilityAverage                 = avs.PrefixMetrics + acs.VolatilityAverage                            ; //<208>
                                                                                                               //<209>
int   i , N ; N         = ObjectsTotal ()       - 1                                                          ; //<210>
for ( i = N ; i >= 0    ; i --                      )                                                          //<211>
    { if ( StringLen    ( ObjectName  ( i ) )  >= 9 )                                                          //<212>
      if ( StringSubstr ( ObjectName  ( i ) , 0 , 9 )    == avs.Prefix )                                       //<213>
           ObjectDelete ( ObjectName  ( i )         )                                                      ; } //<214>
                                                                                                               //<215>
avi.FlagMetricsShow                   = 0                                                                    ; //<216>
avi.FlagMetricsCreate                 = 0                                                                    ; //<217>
avi.FlagOrderLevelsShow               = 0                                                                    ; //<218>
avi.FlagOrderLevelsCreate             = 0                                                                    ; //<219>
avi.FlagChartFramesShow               = 0                                                                    ; //<220>
avi.FlagChartFramesCreate             = 0                                                                    ; //<221>
avi.FlagSynthFramesShow               = 0                                                                    ; //<222>
avi.FlagSynthFramesCreate             = 0                                                                    ; //<223>
                                                                                                               //<224>
GlobalVariableSet                     ( avs.SetupMetrics      , 1                                          ) ; //<225>
GlobalVariableSet                     ( avs.SetupOrderLevels  , 1                                          ) ; //<226>
GlobalVariableSet                     ( avs.SetupChartFrames  , 1                                          ) ; //<227>
GlobalVariableSet                     ( avs.SetupSynthFrames  , 1                                          ) ; //<228>
GlobalVariableSet                     ( avs.SetupSynth        , avi.Synth                                  ) ; //<229>
                                                                                                               //<230>
A.System.Stamp                        = A.System.Name         + ": " +                                         //<231>
                                        A.System.Series       +                                                //<232>
                                        A.System.Modification + " "  +                                         //<233>
                                        A.System.Program      + " "  +                                         //<234>
                                        avs.Symbol            + " "  +                                         //<235>
                                        avi.Period                                                           ; //<236>
                                                                                                               //<237>
Alert                                 ( A.System.Stamp        , " Reload "         , UninitializeReason () ) ; //<238>
}                                                                                                              //<239>
//</A.System.Indicator: Function init >````````````````````````````````````````````````````````````````````````//<240>
                                                                                                               //<241>
//< A.System.Indicator: Function deinit >``````````````````````````````````````````````````````````````````````//<242>
                                                                                                               //<243>
int    deinit ()                                                                                               //<244>
{                                                                                                              //<245>
afr.DeleteMetrics                     ()                                                                     ; //<246>
afr.DeleteOrderLevels                 ()                                                                     ; //<247>
afr.DeleteChartFrames                 ()                                                                     ; //<248>
afr.DeleteSynthFrames                 ()                                                                     ; //<249>
                                                                                                               //<250>
GlobalVariableDel                     ( avs.SetupMetrics                                                   ) ; //<251>
GlobalVariableDel                     ( avs.SetupOrderLevels                                               ) ; //<252>
GlobalVariableDel                     ( avs.SetupChartFrames                                               ) ; //<253>
GlobalVariableDel                     ( avs.SetupSynthFrames                                               ) ; //<254>
GlobalVariableDel                     ( avs.SetupSynth                                                     ) ; //<255>
                                                                                                               //<256>
Alert                                 ( A.System.Stamp        , " Stop "           , UninitializeReason () ) ; //<257>
}                                                                                                              //<258>
//</A.System.Indicator: Function deinit >``````````````````````````````````````````````````````````````````````//<259>
                                                                                                               //<260>
//< A.System.Indicator: Function start >```````````````````````````````````````````````````````````````````````//<261>
                                                                                                               //<262>
int    start  ()                                                                                               //<263>
{                                                                                                              //<264>
if ( ! GlobalVariableCheck ( avs.SetupMetrics     ) ) GlobalVariableSet ( avs.SetupMetrics     , 1         ) ; //<265>
if ( ! GlobalVariableCheck ( avs.SetupOrderLevels ) ) GlobalVariableSet ( avs.SetupOrderLevels , 1         ) ; //<266>
if ( ! GlobalVariableCheck ( avs.SetupChartFrames ) ) GlobalVariableSet ( avs.SetupChartFrames , 1         ) ; //<267>
if ( ! GlobalVariableCheck ( avs.SetupSynthFrames ) ) GlobalVariableSet ( avs.SetupSynthFrames , 1         ) ; //<268>
if ( ! GlobalVariableCheck ( avs.SetupSynth       ) ) GlobalVariableSet ( avs.SetupSynth       , avi.Synth ) ; //<269>
                                                                                                               //<270>
if ( arv.Chart [ ari.ZeroTime      ] != Time [ 0 ]                                                             //<271>
  || arv.Chart [ ari.Resolution.H  ] != WindowBarsPerChart                                                ()   //<272>
  || arv.Chart [ ari.LastBar       ] != WindowFirstVisibleBar                                             ()   //<273>
  || arv.Chart [ ari.PriceMax      ] != WindowPriceMax                                                    ()   //<274>
  || arv.Chart [ ari.PriceMin      ] != WindowPriceMin                                                    ()   //<275>
  || avi.Synth                       != GlobalVariableGet               ( avs.SetupSynth                   ) ) //<276>
                                                                                                               //<277>
   { avi.Synth                        = GlobalVariableGet               ( avs.SetupSynth                   ) ; //<278>
     afr.MeasureChart                                                                                     () ; //<279>
                                                                                                               //<280>
     afr.DeleteChartFrames                                                                                () ; //<281>
     avi.FlagChartFramesCreate        = 1                                                                    ; //<282>
     afr.DeleteSynthFrames                                                                                () ; //<283>
     avi.FlagSynthFramesCreate        = 1                                                                  ; } //<284>
                                                                                                               //<285>
if ( GlobalVariableGet ( avs.SetupMetrics     ) == 1 )                                                         //<286>
   { if ( avi.FlagMetricsShow        == 0            )                                                         //<287>
        { avi.FlagMetricsShow         = 1                                                                  ;   //<288>
          avi.FlagMetricsCreate       = 1                                                                  ; } //<289>
     afr.PlotMetrics                                                                                    () ; } //<290>
else if ( avi.FlagMetricsShow        == 1            )                                                         //<291>
        { avi.FlagMetricsShow         = 0                                                                  ;   //<292>
          afr.DeleteMetrics                                                                             () ; } //<293>
                                                                                                               //<294>
if ( GlobalVariableGet ( avs.SetupOrderLevels ) == 1 )                                                         //<295>
   { if ( avi.FlagOrderLevelsShow    == 0            )                                                         //<296>
        { avi.FlagOrderLevelsShow     = 1                                                                  ;   //<297>
          avi.FlagOrderLevelsCreate   = 1                                                                  ; } //<298>
     afr.PlotOrderLevels                                                                                () ; } //<299>
else if ( avi.FlagOrderLevelsShow    == 1            )                                                         //<300>
        { avi.FlagOrderLevelsShow     = 0                                                                  ;   //<301>
          afr.DeleteOrderLevels                                                                         () ; } //<302>
                                                                                                               //<303>
if ( GlobalVariableGet ( avs.SetupChartFrames ) == 1 )                                                         //<304>
   { if ( avi.FlagChartFramesShow    == 0            )                                                         //<305>
        { avi.FlagChartFramesShow     = 1                                                                  ;   //<306>
          avi.FlagChartFramesCreate   = 1                                                                  ; } //<307>
     afr.PlotChartFrames                                                                                () ; } //<308>
else if ( avi.FlagChartFramesShow    == 1            )                                                         //<309>
        { avi.FlagChartFramesShow     = 0                                                                  ;   //<310>
          afr.DeleteChartFrames                                                                         () ; } //<311>
                                                                                                               //<312>
if ( GlobalVariableGet ( avs.SetupSynthFrames ) == 1 )                                                         //<313>
   { if ( avi.FlagSynthFramesShow    == 0            )                                                         //<314>
        { avi.FlagSynthFramesShow     = 1                                                                  ;   //<315>
          avi.FlagSynthFramesCreate   = 1                                                                  ; } //<316>
     afr.PlotSynthFrames                                                                                () ; } //<317>
else if ( avi.FlagSynthFramesShow    == 1            )                                                         //<318>
        { avi.FlagSynthFramesShow     = 0                                                                  ;   //<319>
          afr.DeleteSynthFrames                                                                         () ; } //<320>
}                                                                                                              //<321>
//</A.System.Indicator: Function start >```````````````````````````````````````````````````````````````````````//<322>
                                                                                                               //<323>
//</2.2. Special Functions >-----------------------------------------------------------------------------------//<324>
                                                                                                               //<325>
//< 2.3. Common  Functions >-----------------------------------------------------------------------------------//<326>
                                                                                                               //<327>
//< A.System.Indicator: Function  List >```````````````````````````````````````````````````````````````````````//<328>
// 01 int    afr.MeasureChart                                                                          //   12 //<329>
// 02 string afs.Interval                                                                              //    8 //<330>
// 03 int    afr.CreateArrow                                                                           //    4 //<331>
// 04 int    afr.ResetArrow                                                                            //    2 //<332>
// 05 int    afr.CreateText                                                                            //    2 //<333>
// 06 int    afr.ResetText                                                                             //    3 //<334>
// 07 int    afr.CreateLineT                                                                           //    5 //<335>
// 08 int    afr.ResetLineT                                                                            //    5 //<336>
// 09 int    afr.CreateLineV                                                                           //    4 //<337>
// 10 int    afr.ResetLineV                                                                            //    1 //<338>
// 11 int    afr.CreateLineH                                                                           //    4 //<339>
// 12 int    afr.ResetLineH                                                                            //    1 //<340>
// 13 int    afr.Reserved                                                                              //    3 //<341>
// 14 int    afr.CreateFrame                                                                           //    3 //<342>
// 15 int    afr.ResetFrame                                                                            //    4 //<343>
// 16 int    afr.DeleteMetrics                                                                         //   27 //<344>
// 17 int    afr.DeleteChartFrames                                                                     //   12 //<345>
// 18 int    afr.DeleteSynthFrames                                                                     //    8 //<346>
// 19 int    afr.DeleteOrderLevels                                                                     //      //<347>
// 20 int    afr.PlotMetrics                                                                           //  183 //<348>
// 21 int    afr.PlotOrderLevels                                                                       //      //<349>
// 22 int    afr.PlotChartFrames                                                                       //   71 //<350>
// 23 int    afr.PlotSynthFrames                                                                       //   46 //<351>
//< A.System.Indicator: Function  List >```````````````````````````````````````````````````````````````````````//<352>
                                                                                                               //<353>
//< A.System.Indicator: Function  1 >``````````````````````````````````````````````````````````````````````````//<354>
int    afr.MeasureChart                   ()                                                           //   12 //<355>
{                                                                                                              //<356>
arv.Chart [ ari.ZeroTime      ] = Time [ 0 ]                                                                 ; //<357>
arv.Chart [ ari.Resolution.H  ] = WindowBarsPerChart                                                      () ; //<358>
arv.Chart [ ari.LastBar       ] = WindowFirstVisibleBar                                                   () ; //<359>
if ( arv.Chart [ ari.LastBar  ] < arv.Chart [ ari.Resolution.H ] )                                             //<360>
     arv.Chart [ ari.FirstBar ] = 0                                                                          ; //<361>
else arv.Chart [ ari.FirstBar ] = arv.Chart [ ari.LastBar      ] - arv.Chart [ ari.Resolution.H ] + 1        ; //<362>
arv.Chart [ ari.TotalBars     ] = arv.Chart [ ari.LastBar      ] - arv.Chart [ ari.FirstBar     ] + 1        ; //<363>
arv.Chart [ ari.ShiftBars     ] = arv.Chart [ ari.Resolution.H ] - arv.Chart [ ari.TotalBars    ]            ; //<364>
arv.Chart [ ari.PriceMax      ] = WindowPriceMax                                                          () ; //<365>
arv.Chart [ ari.PriceMin      ] = WindowPriceMin                                                          () ; //<366>
arv.Chart [ ari.PriceRange    ] = arv.Chart [ ari.PriceMax     ] - arv.Chart [ ari.PriceMin     ]            ; //<367>
arv.Chart [ ari.Resolution.V  ] = arv.Chart [ ari.PriceRange   ] / Point                                     ; //<368>
}                                                                                                              //<369>
//</A.System.Indicator: Function  1 >``````````````````````````````````````````````````````````````````````````//<370>
                                                                                                               //<371>
//< A.System.Indicator: Function  2 >``````````````````````````````````````````````````````````````````````````//<372>
string afs.Interval                       (                                                            //    8 //<373>
       int     aai.Interval               )                                                                    //<374>
{                                                                                                              //<375>
static string  als.Result                                                                                    ; //<376>
static int     ali.Interval               ; ali.Interval = MathAbs      ( aai.Interval                     ) ; //<377>
                                            als.Result   = TimeToStr    ( ali.Interval , TIME_MINUTES      ) ; //<378>
                                                                                                               //<379>
if           ( ali.Interval >= 86400      ) als.Result   = ali.Interval / 86400 + "+"  + als.Result          ; //<380>
else if      ( aai.Interval  < 0          ) als.Result   = "-"                         + als.Result          ; //<381>
                                                                                                               //<382>
return       ( als.Result                                                                                  ) ; //<383>
}                                                                                                              //<384>
//</A.System.Indicator: Function  2 >``````````````````````````````````````````````````````````````````````````//<385>
                                                                                                               //<386>
//< A.System.Indicator: Function  3 >``````````````````````````````````````````````````````````````````````````//<387>
int    afr.CreateArrow                    (                                                            //    4 //<388>
       string  aas.Name                   ,                                                                    //<389>
       int     aai.Color                  ,                                                                    //<390>
       int     aai.Width                  ,                                                                    //<391>
       int     aai.Char                   ,                                                                    //<392>
       int     aai.Time                   ,                                                                    //<393>
       double  aad.Price                  )                                                                    //<394>
{                                                                                                              //<395>
ObjectCreate ( aas.Name  , OBJ_ARROW  , 0 , aai.Time  , aad.Price                                          ) ; //<396>
ObjectSet    ( aas.Name  , OBJPROP_COLOR              , aai.Color                                          ) ; //<397>
ObjectSet    ( aas.Name  , OBJPROP_WIDTH              , aai.Width                                          ) ; //<398>
ObjectSet    ( aas.Name  , OBJPROP_ARROWCODE          , aai.Char                                           ) ; //<399>
}                                                                                                              //<400>
//</A.System.Indicator: Function  3 >``````````````````````````````````````````````````````````````````````````//<401>
                                                                                                               //<402>
//< A.System.Indicator: Function  4 >``````````````````````````````````````````````````````````````````````````//<403>
int    afr.ResetArrow                     (                                                            //    2 //<404>
       string  aas.Name                   ,                                                                    //<405>
       int     aai.Time                   ,                                                                    //<406>
       double  aad.Price                  )                                                                    //<407>
{                                                                                                              //<408>
ObjectSet    ( aas.Name  , OBJPROP_TIME1  , aai.Time                                                       ) ; //<409>
ObjectSet    ( aas.Name  , OBJPROP_PRICE1 , aad.Price                                                      ) ; //<410>
}                                                                                                              //<411>
//</A.System.Indicator: Function  4 >``````````````````````````````````````````````````````````````````````````//<412>
                                                                                                               //<413>
//< A.System.Indicator: Function  5 >``````````````````````````````````````````````````````````````````````````//<414>
int    afr.CreateText                     (                                                            //    2 //<415>
       string  aas.Name                   ,                                                                    //<416>
       int     aai.Color                  ,                                                                    //<417>
       int     aai.Size                   ,                                                                    //<418>
       int     aai.Time                   ,                                                                    //<419>
       double  aad.Price                  ,                                                                    //<420>
       string  aas.Text                   )                                                                    //<421>
{                                                                                                              //<422>
ObjectCreate ( aas.Name  , OBJ_TEXT   , 0 , aai.Time  , aad.Price                                          ) ; //<423>
ObjectSetText( aas.Name  , aas.Text       , aai.Size  , "Courier New" , aai.Color                          ) ; //<424>
}                                                                                                              //<425>
//</A.System.Indicator: Function  5 >``````````````````````````````````````````````````````````````````````````//<426>
                                                                                                               //<427>
//< A.System.Indicator: Function  6 >``````````````````````````````````````````````````````````````````````````//<428>
int    afr.ResetText                      (                                                            //    3 //<429>
       string  aas.Name                   ,                                                                    //<430>
       int     aai.Color                  ,                                                                    //<431>
       int     aai.Size                   ,                                                                    //<432>
       int     aai.Time                   ,                                                                    //<433>
       double  aad.Price                  ,                                                                    //<434>
       string  aas.Text                   )                                                                    //<435>
{                                                                                                              //<436>
ObjectSet    ( aas.Name  , OBJPROP_TIME1  , aai.Time                                                       ) ; //<437>
ObjectSet    ( aas.Name  , OBJPROP_PRICE1 , aad.Price                                                      ) ; //<438>
ObjectSetText( aas.Name  , aas.Text       , aai.Size  , "Courier New" , aai.Color                          ) ; //<439>
}                                                                                                              //<440>
//</A.System.Indicator: Function  6 >``````````````````````````````````````````````````````````````````````````//<441>
                                                                                                               //<442>
//< A.System.Indicator: Function  7 >``````````````````````````````````````````````````````````````````````````//<443>
int    afr.CreateLineT                    (                                                            //    5 //<444>
       string  aas.Name                   ,                                                                    //<445>
       int     aai.Color                  ,                                                                    //<446>
       int     aai.Width                  ,                                                                    //<447>
       int     aai.Style                  ,                                                                    //<448>
       int     aai.Ray                    ,                                                                    //<449>
       int     aai.Time1                  ,                                                                    //<450>
       double  aad.Price1                 ,                                                                    //<451>
       int     aai.Time2                  ,                                                                    //<452>
       double  aad.Price2                 )                                                                    //<453>
{                                                                                                              //<454>
ObjectCreate ( aas.Name  , OBJ_TREND  , 0 , aai.Time1 , aad.Price1 , aai.Time2  , aad.Price2               ) ; //<455>
ObjectSet    ( aas.Name  , OBJPROP_COLOR  , aai.Color                                                      ) ; //<456>
ObjectSet    ( aas.Name  , OBJPROP_WIDTH  , aai.Width                                                      ) ; //<457>
ObjectSet    ( aas.Name  , OBJPROP_STYLE  , aai.Style                                                      ) ; //<458>
ObjectSet    ( aas.Name  , OBJPROP_RAY    , aai.Ray                                                        ) ; //<459>
}                                                                                                              //<460>
//</A.System.Indicator: Function  7 >``````````````````````````````````````````````````````````````````````````//<461>
                                                                                                               //<462>
//< A.System.Indicator: Function  8 >``````````````````````````````````````````````````````````````````````````//<463>
int    afr.ResetLineT                     (                                                            //    5 //<464>
       string  aas.Name                   ,                                                                    //<465>
       int     aai.Color                  ,                                                                    //<466>
       int     aai.Time1                  ,                                                                    //<467>
       double  aad.Price1                 ,                                                                    //<468>
       int     aai.Time2                  ,                                                                    //<469>
       double  aad.Price2                 )                                                                    //<470>
{                                                                                                              //<471>
ObjectSet    ( aas.Name  , OBJPROP_COLOR  , aai.Color                                                      ) ; //<472>
ObjectSet    ( aas.Name  , OBJPROP_TIME1  , aai.Time1                                                      ) ; //<473>
ObjectSet    ( aas.Name  , OBJPROP_PRICE1 , aad.Price1                                                     ) ; //<474>
ObjectSet    ( aas.Name  , OBJPROP_TIME2  , aai.Time2                                                      ) ; //<475>
ObjectSet    ( aas.Name  , OBJPROP_PRICE2 , aad.Price2                                                     ) ; //<476>
}                                                                                                              //<477>
//</A.System.Indicator: Function  8 >``````````````````````````````````````````````````````````````````````````//<478>
                                                                                                               //<479>
//< A.System.Indicator: Function  9 >``````````````````````````````````````````````````````````````````````````//<480>
int    afr.CreateLineV                    (                                                            //    4 //<481>
       string  aas.Name                   ,                                                                    //<482>
       int     aai.Color                  ,                                                                    //<483>
       int     aai.Width                  ,                                                                    //<484>
       int     aai.Style                  ,                                                                    //<485>
       int     aai.Time                   )                                                                    //<486>
{                                                                                                              //<487>
ObjectCreate ( aas.Name  , OBJ_VLINE  , 0 , aai.Time  , 0                                                  ) ; //<488>
ObjectSet    ( aas.Name  , OBJPROP_COLOR  , aai.Color                                                      ) ; //<489>
ObjectSet    ( aas.Name  , OBJPROP_WIDTH  , aai.Width                                                      ) ; //<490>
ObjectSet    ( aas.Name  , OBJPROP_STYLE  , aai.Style                                                      ) ; //<491>
}                                                                                                              //<492>
//</A.System.Indicator: Function  9 >``````````````````````````````````````````````````````````````````````````//<493>
                                                                                                               //<494>
//< A.System.Indicator: Function 10 >``````````````````````````````````````````````````````````````````````````//<495>
 int    afr.ResetLineV                     (                                                            //   1 //<496>
       string  aas.Name                   ,                                                                    //<497>
       int     aai.Time                   )                                                                    //<498>
{                                                                                                              //<499>
ObjectSet    ( aas.Name  , OBJPROP_TIME1  , aai.Time                                                       ) ; //<500>
}                                                                                                              //<501>
//</A.System.Indicator: Function 10 >``````````````````````````````````````````````````````````````````````````//<502>
                                                                                                               //<503>
//< A.System.Indicator: Function 11 >``````````````````````````````````````````````````````````````````````````//<504>
int    afr.CreateLineH                    (                                                            //    4 //<505>
       string  aas.Name                   ,                                                                    //<506>
       int     aai.Color                  ,                                                                    //<507>
       int     aai.Width                  ,                                                                    //<508>
       int     aai.Style                  ,                                                                    //<509>
       double  aad.Price                  )                                                                    //<510>
{                                                                                                              //<511>
ObjectCreate ( aas.Name  , OBJ_HLINE  , 0 , 0 , aad.Price                                                  ) ; //<512>
ObjectSet    ( aas.Name  , OBJPROP_COLOR  , aai.Color                                                      ) ; //<513>
ObjectSet    ( aas.Name  , OBJPROP_WIDTH  , aai.Width                                                      ) ; //<514>
ObjectSet    ( aas.Name  , OBJPROP_STYLE  , aai.Style                                                      ) ; //<515>
}                                                                                                              //<516>
//</A.System.Indicator: Function 11 >``````````````````````````````````````````````````````````````````````````//<517>
                                                                                                               //<518>
//< A.System.Indicator: Function 12 >``````````````````````````````````````````````````````````````````````````//<519>
int    afr.ResetLineH                     (                                                            //    1 //<520>
       string  aas.Name                   ,                                                                    //<521>
       double  aad.Price                  )                                                                    //<522>
{                                                                                                              //<523>
ObjectSet    ( aas.Name  , OBJPROP_PRICE1 , aad.Price                                                      ) ; //<524>
}                                                                                                              //<525>
//</A.System.Indicator: Function 12 >``````````````````````````````````````````````````````````````````````````//<526>
                                                                                                               //<527>
//< A.System.Indicator: Function 13 >``````````````````````````````````````````````````````````````````````````//<528>
//</A.System.Indicator: Function 13 >``````````````````````````````````````````````````````````````````````````//<529>
                                                                                                               //<530>
//< A.System.Indicator: Function 14 >``````````````````````````````````````````````````````````````````````````//<531>
int    afr.CreateFrame                    (                                                            //    3 //<532>
       string  aas.Name                   ,                                                                    //<533>
       int     aai.Color                  ,                                                                    //<534>
       int     aai.BackGround             ,                                                                    //<535>
       int     aai.Time1                  ,                                                                    //<536>
       double  aad.Price1                 ,                                                                    //<537>
       int     aai.Time2                  ,                                                                    //<538>
       double  aad.Price2                 )                                                                    //<539>
{                                                                                                              //<540>
ObjectCreate ( aas.Name  , OBJ_RECTANGLE  , 0 , aai.Time1 , aad.Price1 , aai.Time2 , aad.Price2            ) ; //<541>
ObjectSet    ( aas.Name  , OBJPROP_COLOR  , aai.Color                                                      ) ; //<542>
ObjectSet    ( aas.Name  , OBJPROP_BACK   , aai.BackGround                                                 ) ; //<543>
}                                                                                                              //<544>
//</A.System.Indicator: Function 14 >``````````````````````````````````````````````````````````````````````````//<545>
                                                                                                               //<546>
//< A.System.Indicator: Function 15 >``````````````````````````````````````````````````````````````````````````//<547>
int    afr.ResetFrame                     (                                                            //    4 //<548>
       string  aas.Name                   ,                                                                    //<549>
       int     aai.Time1                  ,                                                                    //<550>
       double  aad.Price1                 ,                                                                    //<551>
       int     aai.Time2                  ,                                                                    //<552>
       double  aad.Price2                 )                                                                    //<553>
{                                                                                                              //<554>
ObjectSet    ( aas.Name  , OBJPROP_TIME1  , aai.Time1                                                      ) ; //<555>
ObjectSet    ( aas.Name  , OBJPROP_PRICE1 , aad.Price1                                                     ) ; //<556>
ObjectSet    ( aas.Name  , OBJPROP_TIME2  , aai.Time2                                                      ) ; //<557>
ObjectSet    ( aas.Name  , OBJPROP_PRICE2 , aad.Price2                                                     ) ; //<558>
}                                                                                                              //<559>
//</A.System.Indicator: Function 15 >``````````````````````````````````````````````````````````````````````````//<560>
                                                                                                               //<561>
//< A.System.Indicator: Function 16 >``````````````````````````````````````````````````````````````````````````//<562>
int    afr.DeleteMetrics                  ()                                                           //   27 //<563>
{                                                                                                              //<564>
ObjectDelete ( avs.Ask                                                                                     ) ; //<565>
ObjectDelete ( avs.Bid                                                                                     ) ; //<566>
ObjectDelete ( avs.Price                                                                                   ) ; //<567>
ObjectDelete ( avs.Spread                                                                                  ) ; //<568>
ObjectDelete ( avs.MarginHigh                                                                              ) ; //<569>
ObjectDelete ( avs.MarginLow                                                                               ) ; //<570>
ObjectDelete ( avs.StopsHigh                                                                               ) ; //<571>
ObjectDelete ( avs.StopsLow                                                                                ) ; //<572>
ObjectDelete ( avs.BeginTime                                                                               ) ; //<573>
ObjectDelete ( avs.EndTime                                                                                 ) ; //<574>
ObjectDelete ( avs.SuperTrend                                                                              ) ; //<575>
ObjectDelete ( avs.SuperLabel                                                                              ) ; //<576>
ObjectDelete ( avs.MaxMinTrend                                                                             ) ; //<577>
ObjectDelete ( avs.MaxMinLabel                                                                             ) ; //<578>
ObjectDelete ( avs.ZeroTrend                                                                               ) ; //<579>
ObjectDelete ( avs.ZeroMaxTrend                                                                            ) ; //<580>
ObjectDelete ( avs.ZeroMaxLevel                                                                            ) ; //<581>
ObjectDelete ( avs.ZeroMinTrend                                                                            ) ; //<582>
ObjectDelete ( avs.ZeroMinLevel                                                                            ) ; //<583>
ObjectDelete ( avs.MaxPrice                                                                                ) ; //<584>
ObjectDelete ( avs.MinPrice                                                                                ) ; //<585>
ObjectDelete ( avs.MaxTime                                                                                 ) ; //<586>
ObjectDelete ( avs.MinTime                                                                                 ) ; //<587>
ObjectDelete ( avs.MaxPeak                                                                                 ) ; //<588>
ObjectDelete ( avs.MinPeak                                                                                 ) ; //<589>
ObjectDelete ( avs.MaxInterval                                                                             ) ; //<590>
ObjectDelete ( avs.MinInterval                                                                             ) ; //<591>
}                                                                                                              //<592>
//</A.System.Indicator: Function 16 >``````````````````````````````````````````````````````````````````````````//<593>
                                                                                                               //<594>
//< A.System.Indicator: Function 17 >``````````````````````````````````````````````````````````````````````````//<595>
int    afr.DeleteChartFrames              ()                                                           //   12 //<596>
{                                                                                                              //<597>
int    i , N ; N = ArraySize (  avd.Overlap          )                                                       ; //<598>
for (  i = 0 ; i < N     ; i ++                      )                                                         //<599>
    {  ObjectDelete      ( avs.PrefixAskBars     + i )                                                       ; //<600>
       ObjectDelete      ( avs.PrefixBidBars     + i )                                                       ; //<601>
       ObjectDelete      ( avs.PrefixOverlap     + i )                                                     ; } //<602>
if  (  N != 0 )                                                                                                //<603>
    {  ObjectDelete      ( avs.OverlapMaximum        )                                                       ; //<604>
       ObjectDelete      ( avs.OverlapAverage        )                                                       ; //<605>
       ObjectDelete      ( avs.VolatilityMaximum     )                                                       ; //<606>
       ObjectDelete      ( avs.VolatilityAverage     )                                                     ; } //<607>
                                                                                                               //<608>
ArrayResize              ( avd.Overlap , 0           )                                                       ; //<609>
}                                                                                                              //<610>
//</A.System.Indicator: Function 17 >``````````````````````````````````````````````````````````````````````````//<611>
                                                                                                               //<612>
//< A.System.Indicator: Function 18 >``````````````````````````````````````````````````````````````````````````//<613>
int    afr.DeleteSynthFrames              ()                                                           //    8 //<614>
{                                                                                                              //<615>
int    i , N ; N = avi.Synths                                                                                ; //<616>
for (  i = 0 ; i < N     ; i ++                      )                                                         //<617>
    {  ObjectDelete      ( avs.PrefixSynthBars   + i )                                                       ; //<618>
       ObjectDelete      ( avs.PrefixSynthMean   + i )                                                       ; //<619>
       ObjectDelete      ( avs.PrefixSynthSlopeA + i )                                                       ; //<620>
       ObjectDelete      ( avs.PrefixSynthSlopeB + i )                                                     ; } //<621>
                                                                                                               //<622>
avi.Synths = 0                                                                                               ; //<623>
}                                                                                                              //<624>
//</A.System.Indicator: Function 18 >``````````````````````````````````````````````````````````````````````````//<625>
                                                                                                               //<626>
//< A.System.Indicator: Function 19 >``````````````````````````````````````````````````````````````````````````//<627>
int    afr.DeleteOrderLevels              ()                                                           //      //<628>
{                                                                                                              //<629>
}                                                                                                              //<630>
//</A.System.Indicator: Function 19 >``````````````````````````````````````````````````````````````````````````//<631>
                                                                                                               //<632>
//< A.System.Indicator: Function 20 >``````````````````````````````````````````````````````````````````````````//<633>
                                                                                                               //<634>
int    afr.PlotMetrics                    ()                                                           //  183 //<635>
{                                                                                                              //<636>
double ald.Spread        = Ask  - Bid                                                                        ; //<637>
double ald.Bid           = iClose     ( avs.Symbol , avi.Period         , 0 )                                ; //<638>
double ald.Ask           = ald.Bid    + ald.Spread                                                           ; //<639>
int    ali.Digits        = MarketInfo ( avs.Symbol , MODE_DIGITS            )                                ; //<640>
double ald.NominalMargin = MarketInfo ( avs.Symbol , MODE_MARGINREQUIRED    )                                ; //<641>
double ald.NominalTick   = MarketInfo ( avs.Symbol , MODE_TICKVALUE         )                                ; //<642>
double ald.QuoteTick     = MarketInfo ( avs.Symbol , MODE_TICKSIZE          )                                ; //<643>
double ald.QuotePoint    = MarketInfo ( avs.Symbol , MODE_POINT             )                                ; //<644>
int    ali.StopLevel     = MarketInfo ( avs.Symbol , MODE_STOPLEVEL         )                                ; //<645>
                                                                                                               //<646>
double ald.NominalPoint  =   ald.NominalTick       * ald.QuotePoint         / ald.QuoteTick                  ; //<647>
int    ali.Margin        =   MathRound             ( ald.NominalMargin      / ald.NominalPoint             ) ; //<648>
double ald.QuoteMargin   =   ali.Margin            * ald.QuotePoint                                          ; //<649>
double ald.QuoteStops    =   ali.StopLevel         * ald.QuotePoint                                          ; //<650>
double ald.HalfMargin    =   ald.QuoteMargin       / 2                                                       ; //<651>
double ald.AveragePrice  = ( ald.Ask  + ald.Bid )  / 2                                                       ; //<652>
                                                                                                               //<653>
int    ali.MaxIndex      = iHighest   ( avs.Symbol , avi.Period , MODE_HIGH , arv.Chart [ ari.TotalBars ]  ,   //<654>
                                                                              arv.Chart [ ari.FirstBar  ]  ) ; //<655>
int    ali.MinIndex      = iLowest    ( avs.Symbol , avi.Period , MODE_LOW  , arv.Chart [ ari.TotalBars ]  ,   //<656>
                                                                              arv.Chart [ ari.FirstBar  ]  ) ; //<657>
double ald.MaxPrice      = iHigh      ( avs.Symbol , avi.Period , ali.MaxIndex )        + ald.Spread         ; //<658>
double ald.MinPrice      = iLow       ( avs.Symbol , avi.Period , ali.MinIndex )                             ; //<659>
int    ali.MaxTime       = iTime      ( avs.Symbol , avi.Period , ali.MaxIndex )                             ; //<660>
int    ali.MinTime       = iTime      ( avs.Symbol , avi.Period , ali.MinIndex )                             ; //<661>
int    ali.BeginTime     = iTime      ( avs.Symbol , avi.Period ,             arv.Chart [ ari.FirstBar  ]  ) ; //<662>
int    ali.EndTime       = iTime      ( avs.Symbol , avi.Period ,             arv.Chart [ ari.LastBar   ]  ) ; //<663>
                                                                                                               //<664>
int    ali.LastColor                                                                                         ; //<665>
int    ali.ZeroColor                                                                                         ; //<666>
double ald.NearestPrice                                                                                      ; //<667>
double ald.FarestPrice                                                                                       ; //<668>
int    ali.NearestTime                                                                                       ; //<669>
int    ali.FarestTime                                                                                        ; //<670>
int    ali.MaxMinTime                                                                                        ; //<671>
int    ali.ZeroMaxIndex                                                                                      ; //<672>
int    ali.ZeroMinIndex                                                                                      ; //<673>
                                                                                                               //<674>
if   ( ali.MaxTime       > ali.MinTime    )                                                                    //<675>
     { ali.LastColor     = Aqua                                                                              ; //<676>
       ali.ZeroColor     = Orange                                                                            ; //<677>
       ald.NearestPrice  = ald.MaxPrice                                                                      ; //<678>
       ald.FarestPrice   = ald.MinPrice                                                                      ; //<679>
       ali.NearestTime   = ali.MaxTime                                                                       ; //<680>
       ali.FarestTime    = ali.MinTime                                                                       ; //<681>
       ali.MaxMinTime    = ali.MaxTime    - ali.MinTime                                                      ; //<682>
       ali.ZeroMinIndex  = iLowest        ( avs.Symbol , avi.Period , MODE_LOW  , ali.MaxIndex             ,   //<683>
                                                                      arv.Chart [ ari.FirstBar           ] ) ; //<684>
       ali.ZeroMaxIndex  = iHighest       ( avs.Symbol , avi.Period , MODE_HIGH , ali.ZeroMinIndex         ,   //<685>
                                                                      arv.Chart [ ari.FirstBar           ] ) ; //<686>
     }                                                                                                         //<687>
else { ali.LastColor     = Orange                                                                            ; //<688>
       ali.ZeroColor     = Aqua                                                                              ; //<689>
       ald.NearestPrice  = ald.MinPrice                                                                      ; //<690>
       ald.FarestPrice   = ald.MaxPrice                                                                      ; //<691>
       ali.NearestTime   = ali.MinTime                                                                       ; //<692>
       ali.FarestTime    = ali.MaxTime                                                                       ; //<693>
       ali.MaxMinTime    = ali.MinTime    - ali.MaxTime                                                      ; //<694>
       ali.ZeroMaxIndex  = iHighest       ( avs.Symbol , avi.Period , MODE_HIGH , ali.MinIndex             ,   //<695>
                                                                      arv.Chart [ ari.FirstBar           ] ) ; //<696>
       ali.ZeroMinIndex  = iLowest        ( avs.Symbol , avi.Period , MODE_LOW  , ali.ZeroMaxIndex         ,   //<697>
                                                                      arv.Chart [ ari.FirstBar           ] ) ; //<698>
     }                                                                                                         //<699>
                                                                                                               //<700>
int    ali.ZeroMaxTime   = iTime          ( avs.Symbol , avi.Period , ali.ZeroMaxIndex        )              ; //<701>
int    ali.ZeroMinTime   = iTime          ( avs.Symbol , avi.Period , ali.ZeroMinIndex        )              ; //<702>
double ald.ZeroMaxPrice  = iHigh          ( avs.Symbol , avi.Period , ali.ZeroMaxIndex        ) + ald.Spread ; //<703>
double ald.ZeroMinPrice  = iLow           ( avs.Symbol , avi.Period , ali.ZeroMinIndex        )              ; //<704>
double ald.ZeroAverage   =                ( ald.ZeroMaxPrice        + ald.ZeroMinPrice        ) / 2.0        ; //<705>
                                                                                                               //<706>
string als.MaxInterval   = DoubleToStr  ( ( ald.MaxPrice    - ald.Ask       ) / ald.QuotePoint , 0 )  + "/" +  //<707>
                           afs.Interval   ( arv.Chart       [ ari.ZeroTime  ] - ali.MaxTime                ) ; //<708>
string als.MinInterval   = DoubleToStr  ( ( ald.Bid         - ald.MinPrice  ) / ald.QuotePoint , 0 )  + "/" +  //<709>
                           afs.Interval   ( arv.Chart       [ ari.ZeroTime  ] - ali.MinTime                ) ; //<710>
string als.MaxMinLabel   = DoubleToStr  ( ( ald.MaxPrice    - ald.MinPrice  ) / ald.QuotePoint , 0 )  + "/" +  //<711>
                           afs.Interval   ( ali.MaxMinTime                                                 ) ; //<712>
                                                                                                               //<713>
string als.SuperLabel    = A.System.Series                  + A.System.Modification                  + " "   + //<714>
                           A.System.Program                                                          + ": "  + //<715>
                           DoubleToStr  ( ( arv.Chart       [ ari.PriceMax  ] -                                //<716>
                                            arv.Chart       [ ari.PriceMin  ] ) / ald.QuotePoint , 0 ) + "/" + //<717>
                           afs.Interval   ( ali.BeginTime   - ali.EndTime     )                        + "=" + //<718>
                           DoubleToStr    ( arv.Chart       [ ari.TotalBars ] , 0 ) + "x" + avi.Period + "=" + //<719>
                                            avi.Synths                              + "x" + avi.Synth        ; //<720>
                                                                                                               //<721>
int    ali.LabelIndex    = arv.Chart      [ ari.LastBar ]   - arv.Chart      [ ari.Resolution.H ]      / 2   ; //<722>
int    ali.LabelTime     = iTime          ( avs.Symbol      , avi.Period     , ali.LabelIndex   )            ; //<723>
                                                                                                               //<724>
string als.Price         = DoubleToStr    ( Ask , Digits )  + "/"            + DoubleToStr ( Bid , Digits )  ; //<725>
                                                                                                               //<726>
string als.Spread        = DoubleToStr    ( ald.Spread      / ald.QuotePoint , 0 ) +                           //<727>
                          "/"             + ali.StopLevel  +  "/"                  +                           //<728>
                           DoubleToStr    ( ald.QuoteMargin / ald.QuotePoint , 0 )                           ; //<729>
                                                                                                               //<730>
int    ali.TextTime      = arv.Chart      [ ari.ZeroTime  ] +                                                  //<731>
                           arv.Chart      [ ari.ShiftBars ] * avi.Period     * 60   /  2                     ; //<732>
                                                                                                               //<733>
if   ( avi.FlagMetricsCreate == 1         )                                                                    //<734>
     { avi.FlagMetricsCreate  = 0                                                                            ; //<735>
                                                                                                               //<736>
       afr.CreateLineT ( avs.SuperTrend   , ali.LastColor             , 1 , STYLE_DOT   , 1 ,                  //<737>
                         ali.FarestTime   , ald.FarestPrice           , ali.BeginTime   , ald.AveragePrice ) ; //<738>
       afr.CreateLineT ( avs.MaxMinTrend  , ali.LastColor             , 1 , STYLE_DOT   , 0 ,                  //<739>
                         ali.NearestTime  , ald.NearestPrice          , ali.FarestTime  , ald.FarestPrice  ) ; //<740>
       afr.CreateLineT ( avs.ZeroTrend    , ali.ZeroColor             , 1 , STYLE_DOT   , 1 ,                  //<741>
                         ali.NearestTime  , ald.NearestPrice          , ali.BeginTime   , ald.AveragePrice ) ; //<742>
       afr.CreateLineT ( avs.ZeroMaxTrend , ali.ZeroColor             , 1 , STYLE_DOT   , 0 ,                  //<743>
                         ali.NearestTime  , ald.NearestPrice          , ali.ZeroMaxTime , ald.ZeroMaxPrice ) ; //<744>
       afr.CreateLineT ( avs.ZeroMinTrend , ali.ZeroColor             , 1 , STYLE_DOT   , 0 ,                  //<745>
                         ali.NearestTime  , ald.NearestPrice          , ali.ZeroMinTime , ald.ZeroMinPrice ) ; //<746>
       afr.CreateLineT ( avs.ZeroMaxLevel , ali.ZeroColor             , 1 , STYLE_DOT   , 1 ,                  //<747>
                         ali.ZeroMaxTime  , ald.ZeroMaxPrice          , ali.BeginTime   , ald.ZeroMaxPrice ) ; //<748>
       afr.CreateLineT ( avs.ZeroMinLevel , ali.ZeroColor             , 1 , STYLE_DOT   , 1 ,                  //<749>
                         ali.ZeroMinTime  , ald.ZeroMinPrice          , ali.BeginTime   , ald.ZeroMinPrice ) ; //<750>
                                                                                                               //<751>
       afr.CreateLineV ( avs.BeginTime    , Green   , 1 , STYLE_DOT   , ali.BeginTime                      ) ; //<752>
       afr.CreateLineV ( avs.EndTime      , Green   , 1 , STYLE_DOT   , ali.EndTime                        ) ; //<753>
       afr.CreateLineV ( avs.MaxTime      , Aqua    , 1 , STYLE_DOT   , ali.MaxTime                        ) ; //<754>
       afr.CreateLineV ( avs.MinTime      , Orange  , 1 , STYLE_DOT   , ali.MinTime                        ) ; //<755>
       afr.CreateLineH ( avs.MaxPrice     , Aqua    , 1 , STYLE_DOT   , ald.MaxPrice                       ) ; //<756>
       afr.CreateLineH ( avs.MinPrice     , Orange  , 1 , STYLE_DOT   , ald.MinPrice                       ) ; //<757>
       afr.CreateLineH ( avs.Ask          , Blue    , 1 , STYLE_SOLID , ald.Ask                            ) ; //<758>
       afr.CreateLineH ( avs.Bid          , Red     , 1 , STYLE_SOLID , ald.Bid                            ) ; //<759>
       afr.CreateLineH ( avs.StopsHigh    , Green   , 1 , STYLE_SOLID , ald.Ask          + ald.QuoteStops  ) ; //<760>
       afr.CreateLineH ( avs.StopsLow     , Green   , 1 , STYLE_SOLID , ald.Bid          - ald.QuoteStops  ) ; //<761>
       afr.CreateLineH ( avs.MarginHigh   , Green   , 2 , STYLE_SOLID , ald.AveragePrice + ald.HalfMargin  ) ; //<762>
       afr.CreateLineH ( avs.MarginLow    , Green   , 2 , STYLE_SOLID , ald.AveragePrice - ald.HalfMargin  ) ; //<763>
       afr.CreateArrow ( avs.MaxPeak      , Aqua    , 2 , 6           , ali.MaxTime      , ald.MaxPrice    ) ; //<764>
       afr.CreateArrow ( avs.MinPeak      , Orange  , 2 , 6           , ali.MinTime      , ald.MinPrice    ) ; //<765>
                                                                                                               //<766>
       afr.CreateText  ( avs.SuperLabel   , White                     , 10 ,                                   //<767>
                         ali.LabelTime    , arv.Chart [ ari.PriceMax  ]                  , als.SuperLabel  ) ; //<768>
       afr.CreateText  ( avs.MaxMinLabel  , ali.LastColor             , 10 ,                                   //<769>
                         ali.NearestTime  , ald.FarestPrice                              , als.MaxMinLabel ) ; //<770>
       afr.CreateText  ( avs.MaxInterval  , Orange                    , 10 ,                                   //<771>
                         ali.TextTime     , ald.MaxPrice                                 , als.MaxInterval ) ; //<772>
       afr.CreateText  ( avs.MinInterval  , Aqua                      , 10 ,                                   //<773>
                         ali.TextTime     , ald.MinPrice                                 , als.MinInterval ) ; //<774>
       afr.CreateText  ( avs.Price        , Yellow                    , 10 ,                                   //<775>
                         ali.TextTime     , ald.Bid                                      , als.Price       ) ; //<776>
       afr.CreateText  ( avs.Spread       , Yellow                    , 10 ,                                   //<777>
                         ali.TextTime     , ald.AveragePrice          - ald.HalfMargin   , als.Spread      ) ; //<778>
     } // if                                                                                                   //<779>
else { afr.ResetLineT  ( avs.SuperTrend   , ali.LastColor             ,                                        //<780>
                         ali.FarestTime   , ald.FarestPrice           , ali.BeginTime   , ald.AveragePrice ) ; //<781>
       afr.ResetLineT  ( avs.MaxMinTrend  , ali.LastColor             ,                                        //<782>
                         ali.NearestTime  , ald.NearestPrice          , ali.FarestTime  , ald.FarestPrice  ) ; //<783>
       afr.ResetLineT  ( avs.ZeroTrend    , ali.ZeroColor             ,                                        //<784>
                         ali.NearestTime  , ald.NearestPrice          , ali.BeginTime   , ald.AveragePrice ) ; //<785>
       afr.ResetLineT  ( avs.ZeroMaxTrend , ali.ZeroColor             ,                                        //<786>
                         ali.NearestTime  , ald.NearestPrice          , ali.ZeroMaxTime , ald.ZeroMaxPrice ) ; //<787>
       afr.ResetLineT  ( avs.ZeroMinTrend , ali.ZeroColor             ,                                        //<788>
                         ali.NearestTime  , ald.NearestPrice          , ali.ZeroMinTime , ald.ZeroMinPrice ) ; //<789>
       afr.ResetLineT  ( avs.ZeroMaxLevel , ali.ZeroColor             ,                                        //<790>
                         ali.ZeroMaxTime  , ald.ZeroMaxPrice          , ali.BeginTime   , ald.ZeroMaxPrice ) ; //<791>
       afr.ResetLineT  ( avs.ZeroMinLevel , ali.ZeroColor             ,                                        //<792>
                         ali.ZeroMinTime  , ald.ZeroMinPrice          , ali.BeginTime   , ald.ZeroMinPrice ) ; //<793>
                                                                                                               //<794>
       afr.ResetLineV  ( avs.BeginTime                                , ali.BeginTime                      ) ; //<795>
       afr.ResetLineV  ( avs.EndTime                                  , ali.EndTime                        ) ; //<796>
       afr.ResetLineV  ( avs.MaxTime                                  , ali.MaxTime                        ) ; //<797>
       afr.ResetLineV  ( avs.MinTime                                  , ali.MinTime                        ) ; //<798>
       afr.ResetLineH  ( avs.MaxPrice                                 , ald.MaxPrice                       ) ; //<799>
       afr.ResetLineH  ( avs.MinPrice                                 , ald.MinPrice                       ) ; //<800>
       afr.ResetLineH  ( avs.Ask                                      , ald.Ask                            ) ; //<801>
       afr.ResetLineH  ( avs.Bid                                      , ald.Bid                            ) ; //<802>
       afr.ResetLineH  ( avs.StopsHigh                                , ald.Ask          + ald.QuoteStops  ) ; //<803>
       afr.ResetLineH  ( avs.StopsLow                                 , ald.Bid          - ald.QuoteStops  ) ; //<804>
       afr.ResetLineH  ( avs.MarginHigh                               , ald.AveragePrice + ald.HalfMargin  ) ; //<805>
       afr.ResetLineH  ( avs.MarginLow                                , ald.AveragePrice - ald.HalfMargin  ) ; //<806>
       afr.ResetArrow  ( avs.MaxPeak                                  , ali.MaxTime      , ald.MaxPrice    ) ; //<807>
       afr.ResetArrow  ( avs.MinPeak                                  , ali.MinTime      , ald.MinPrice    ) ; //<808>
                                                                                                               //<809>
       afr.ResetText   ( avs.SuperLabel   , White                     , 10 ,                                   //<810>
                         ali.LabelTime    , arv.Chart [ ari.PriceMax  ]                  , als.SuperLabel  ) ; //<811>
       afr.ResetText   ( avs.MaxMinLabel  , ali.LastColor             , 10 ,                                   //<812>
                         ali.NearestTime  , ald.FarestPrice                              , als.MaxMinLabel ) ; //<813>
       afr.ResetText   ( avs.MaxInterval  , Orange                    , 10 ,                                   //<814>
                         ali.TextTime     , ald.MaxPrice                                 , als.MaxInterval ) ; //<815>
       afr.ResetText   ( avs.MinInterval  , Aqua                      , 10 ,                                   //<816>
                         ali.TextTime     , ald.MinPrice                                 , als.MinInterval ) ; //<817>
       afr.ResetText   ( avs.Price        , Yellow                    , 10 ,                                   //<818>
                         ali.TextTime     , ald.Bid                                      , als.Price       ) ; //<819>
       afr.ResetText   ( avs.Spread       , Yellow                    , 10 ,                                   //<820>
                         ali.TextTime     , ald.AveragePrice          - ald.HalfMargin   , als.Spread      ) ; //<821>
     } // else                                                                                                 //<822>
}                                                                                                              //<823>
//</A.System.Indicator: Function 20 >``````````````````````````````````````````````````````````````````````````//<824>
                                                                                                               //<825>
//< A.System.Indicator: Function 21 >``````````````````````````````````````````````````````````````````````````//<826>
int    afr.PlotOrderLevels                ()                                                           //    0 //<827>
{                                                                                                              //<828>
if   ( avi.FlagOrderLevelsCreate == 1      )                                                                   //<829>
     { avi.FlagOrderLevelsCreate  = 0                                                                        ; //<830>
                                                                                                               //<831>
     } // if                                                                                                   //<832>
else {                                                                                                         //<833>
     } // else                                                                                                 //<834>
}                                                                                                              //<835>
//</A.System.Indicator: Function 21 >``````````````````````````````````````````````````````````````````````````//<836>
                                                                                                               //<837>
//< A.System.Indicator: Function 22 >``````````````````````````````````````````````````````````````````````````//<838>
int    afr.PlotChartFrames                ()                                                           //   71 //<839>
{                                                                                                              //<840>
if   ( avi.FlagChartFramesCreate == 1      )                                                                   //<841>
     { avi.FlagChartFramesCreate  = 0                                                                        ; //<842>
                                                                                                               //<843>
       if ( ArraySize   ( avd.Overlap )  != arv.Chart [ ari.TotalBars   ]                )                     //<844>
            ArrayResize ( avd.Overlap ,     arv.Chart [ ari.TotalBars   ]                )                   ; //<845>
                                                                                                               //<846>
       int   ali.Suffix = 0                                                                                  ; //<847>
       int   i , N ; N  = arv.Chart       [ ari.LastBar  ] + 1                                               ; //<848>
       for ( i          = arv.Chart       [ ari.FirstBar ]          ; i < N      ; i ++  )                     //<849>
           { if (    i == 0 )                                                                                  //<850>
               int        ali.Time1       = iTime     ( avs.Symbol  , avi.Period , i     ) + avi.Period * 60 ; //<851>
             else         ali.Time1       = iTime     ( avs.Symbol  , avi.Period , i - 1 )                   ; //<852>
             int          ali.Time2       = iTime     ( avs.Symbol  , avi.Period , i     )                   ; //<853>
             double       ald.AskHigh     = iHigh     ( avs.Symbol  , avi.Period , i     ) + Ask - Bid       ; //<854>
             double       ald.AskLow      = iLow      ( avs.Symbol  , avi.Period , i     ) + Ask - Bid       ; //<855>
             double       ald.BidHigh     = iHigh     ( avs.Symbol  , avi.Period , i     )                   ; //<856>
             double       ald.BidLow      = iLow      ( avs.Symbol  , avi.Period , i     )                   ; //<857>
                                                                                                               //<858>
             int           ali.Index   = i                          - arv.Chart   [ ari.FirstBar           ] ; //<859>
             avd.Overlap [ ali.Index ] = ald.BidHigh                - ald.AskLow                             ; //<860>
             double ald.OverlapBound   = arv.Chart [ ari.PriceMax ] - avd.Overlap [ ali.Index              ] ; //<861>
                                                                                                               //<862>
             afr.CreateFrame ( avs.PrefixAskBars + ali.Suffix , Green   , 1 , ali.Time1 ,                      //<863>
                               ald.AskHigh                                  , ali.Time2 , ald.AskLow       ) ; //<864>
             afr.CreateFrame ( avs.PrefixBidBars + ali.Suffix , Orange  , 1 , ali.Time1 ,                      //<865>
                               ald.BidHigh                                  , ali.Time2 , ald.BidLow       ) ; //<866>
             afr.CreateFrame ( avs.PrefixOverlap + ali.Suffix , Gray    , 1 , ali.Time1 ,                      //<867>
                               arv.Chart         [ ari.PriceMax ]           , ali.Time2 , ald.OverlapBound ) ; //<868>
             ali.Suffix ++                                                                                 ; } //<869>
                                                                                                               //<870>
             int    ali.OverlapMaxIndex   = ArrayMaximum ( avd.Overlap , arv.Chart [ ari.TotalBars ]   , 0 ) ; //<871>
             double ald.OverlapMaximum    = avd.Overlap  [ ali.OverlapMaxIndex ]                             ; //<872>
                                                                                                               //<873>
             double ald.OverlapAverage    = 0                                                                ; //<874>
             for  ( i  = 0 ;         i    < arv.Chart    [ ari.TotalBars ]    ; i ++ )                         //<875>
                    ald.OverlapAverage    = ald.OverlapAverage + avd.Overlap  [ i    ]                       ; //<876>
             ald.OverlapAverage           = ald.OverlapAverage                / arv.Chart [ ari.TotalBars  ] ; //<877>
                                                                                                               //<878>
             int    ali.OverlapMaximum    = MathRound    ( ald.OverlapMaximum / Point                      ) ; //<879>
             int    ali.OverlapAverage    = MathRound    ( ald.OverlapAverage / Point                      ) ; //<880>
             double ald.MaximumLevel      = arv.Chart    [ ari.PriceMax  ]    - ald.OverlapMaximum           ; //<881>
             double ald.AverageLevel      = arv.Chart    [ ari.PriceMax  ]    - ald.OverlapAverage           ; //<882>
                                                                                                               //<883>
             int    ali.TextTime          = arv.Chart    [ ari.ZeroTime  ]    +                                //<884>
                                            arv.Chart    [ ari.ShiftBars ]    * avi.Period * 60 / 2          ; //<885>
                                                                                                               //<886>
             afr.CreateLineH ( avs.OverlapMaximum      , White , 1  , STYLE_DOT    , ald.MaximumLevel      ) ; //<887>
             afr.CreateLineH ( avs.OverlapAverage      , White , 1  , STYLE_SOLID  , ald.AverageLevel      ) ; //<888>
                                                                                                               //<889>
             afr.CreateText  ( avs.VolatilityMaximum   , White , 10 , ali.TextTime , ald.MaximumLevel      ,   //<890>
                                                                                     ali.OverlapMaximum    ) ; //<891>
             afr.CreateText  ( avs.VolatilityAverage   , White , 10 , ali.TextTime , ald.AverageLevel      ,   //<892>
                                                                                     ali.OverlapAverage    ) ; //<893>
     } // if                                                                                                   //<894>
else {                    ali.Time1       = iTime     ( avs.Symbol  , avi.Period , 0     )                   ; //<895>
                          ali.Time2       = iTime     ( avs.Symbol  , avi.Period , 0     ) + avi.Period * 60 ; //<896>
                          ald.AskHigh     = iHigh     ( avs.Symbol  , avi.Period , 0     ) + Ask - Bid       ; //<897>
                          ald.AskLow      = iLow      ( avs.Symbol  , avi.Period , 0     ) + Ask - Bid       ; //<898>
                          ald.BidHigh     = iHigh     ( avs.Symbol  , avi.Period , 0     )                   ; //<899>
                          ald.BidLow      = iLow      ( avs.Symbol  , avi.Period , 0     )                   ; //<900>
                                                                                                               //<901>
             avd.Overlap [ 0 ]            = ald.BidHigh                           - ald.AskLow               ; //<902>
             ald.OverlapBound             = arv.Chart [ ari.PriceMax ]            - avd.Overlap [ 0 ]        ; //<903>
                                                                                                               //<904>
             afr.ResetFrame ( avs.PrefixAskBars   + 0 , ali.Time1   , ald.AskHigh                          ,   //<905>
                                                        ali.Time2   , ald.AskLow                           ) ; //<906>
             afr.ResetFrame ( avs.PrefixBidBars   + 0 , ali.Time1   , ald.BidHigh                          ,   //<907>
                                                        ali.Time2   , ald.BidLow                           ) ; //<908>
             afr.ResetFrame ( avs.PrefixOverlap   + 0 , ali.Time1   , arv.Chart   [ ari.PriceMax    ]      ,   //<909>
                                                        ali.Time2   , ald.OverlapBound                     ) ; //<910>
     } // else                                                                                                 //<911>
}                                                                                                              //<912>
//</A.System.Indicator: Function 22 >``````````````````````````````````````````````````````````````````````````//<913>
                                                                                                               //<914>
//< A.System.Indicator: Function 23 >``````````````````````````````````````````````````````````````````````````//<915>
int    afr.PlotSynthFrames                ()                                                           //   46 //<916>
{                                                                                                              //<917>
if   ( iBars ( avs.Symbol , avi.Synth )  < 2      )                                                   return ; //<918>
                                                                                                               //<919>
if   ( avi.FlagSynthFramesCreate    == 1          )                                                            //<920>
     { avi.FlagSynthFramesCreate     = 0                                                                     ; //<921>
                                                                                                               //<922>
       if ( avi.Period              <= avi.Synth  )                                                            //<923>
          {                                                                                                    //<924>
            int  ali.TimeChartBegin  = iTime      ( avs.Symbol  , avi.Period  , arv.Chart [ ari.FirstBar ] ) ; //<925>
            int  ali.TimeChartEnd    = iTime      ( avs.Symbol  , avi.Period  , arv.Chart [ ari.LastBar  ] ) ; //<926>
                                                                                                               //<927>
            if ( ali.TimeChartBegin  < iTime      ( avs.Symbol  , avi.Synth   , 0 ) )                          //<928>
             int ali.IndexSynthBegin = iBarShift  ( avs.Symbol  , avi.Synth   , ali.TimeChartBegin         ) ; //<929>
            else ali.IndexSynthBegin = 0                                                                     ; //<930>
                                                                                                               //<931>
            if ( ali.TimeChartEnd    < iTime      ( avs.Symbol  , avi.Synth   , 0 ) )                          //<932>
             int ali.IndexSynthEnd   = iBarShift  ( avs.Symbol  , avi.Synth   , ali.TimeChartEnd           ) ; //<933>
            else ali.IndexSynthEnd   = 0                                                                     ; //<934>
                                                                                                               //<935>
            if ( ali.IndexSynthEnd  == ali.IndexSynthBegin      ) ali.IndexSynthEnd      ++                  ; //<936>
                                                                                                               //<937>
            avi.Synths              =  ali.IndexSynthEnd        - ali.IndexSynthBegin    + 1                 ; //<938>
                                                                                                               //<939>
            int ali.Suffix   = 0                                                                             ; //<940>
            int i , N   ; N  = ali.IndexSynthEnd      + 1                                                    ; //<941>
            for (         i  = ali.IndexSynthBegin    ; i < N       ; i ++               )                     //<942>
                { if    ( i == 0 )                                                                             //<943>
                    int   ali.Time1       = iTime     ( avs.Symbol  , avi.Synth  , i     ) + avi.Synth  * 60 ; //<944>
                  else    ali.Time1       = iTime     ( avs.Symbol  , avi.Synth  , i - 1 )                   ; //<945>
                  int     ali.Time2       = iTime     ( avs.Symbol  , avi.Synth  , i     )                   ; //<946>
                  double  ald.Spread      = Ask       - Bid                                                  ; //<947>
                  double  ald.AskHigh     = iHigh     ( avs.Symbol  , avi.Synth  , i     ) + ald.Spread      ; //<948>
                  double  ald.BidLow      = iLow      ( avs.Symbol  , avi.Synth  , i     )                   ; //<949>
                  double  ald.Average     =           ( ald.AskHigh + ald.BidLow         ) / 2               ; //<950>
                  double  ald.Open        = iOpen     ( avs.Symbol  , avi.Synth  , i     )                   ; //<951>
                  double  ald.Close       = iClose    ( avs.Symbol  , avi.Synth  , i     )                   ; //<952>
                                                                                                               //<953>
                  afr.CreateFrame ( avs.PrefixSynthBars   + ali.Suffix , White     , 0   ,                     //<954>
                                    ali.Time1 , ald.AskHigh            , ali.Time2 , ald.BidLow            ) ; //<955>
                  afr.CreateLineT ( avs.PrefixSynthMean   + ali.Suffix , White     , 1   , STYLE_DOT  , 0  ,   //<956>
                                    ali.Time1 , ald.Average            , ali.Time2 , ald.Average           ) ; //<957>
                  afr.CreateLineT ( avs.PrefixSynthSlopeA + ali.Suffix , White     , 1   , STYLE_DASH , 0  ,   //<958>
                                    ali.Time1 , ald.Close + ald.Spread , ali.Time2 , ald.Open + ald.Spread ) ; //<959>
                  afr.CreateLineT ( avs.PrefixSynthSlopeB + ali.Suffix , White     , 1   , STYLE_DASH , 0  ,   //<960>
                                    ali.Time1 , ald.Close              , ali.Time2 , ald.Open              ) ; //<961>
                  ali.Suffix ++                                                                          ; } } //<962>
     } // if                                                                                                   //<963>
}                                                                                                              //<964>
//</A.System.Indicator: Function 23 >``````````````````````````````````````````````````````````````````````````//<965>
                                                                                                               //<966>
//</2.3. Common  Functions >-----------------------------------------------------------------------------------//<967>
                                                                                                               //<968>
//</2. Program  >==============================================================================================//<969>