//
//  "00-SuccessTrade" -- show success trades
//
#property  copyright "00"
#property  link      "http://www.mql4.com/"

//---- indicator settings
#property  indicator_chart_window

#property indicator_buffers  8

#property  indicator_color1  0x997744
#property  indicator_color2  0xbb5533
#property  indicator_color3  0xdd3322
#property  indicator_color4  0xff1111
#property  indicator_color5  0x447799
#property  indicator_color6  0x3355bb
#property  indicator_color7  0x2233dd
#property  indicator_color8  0x1111ff

#property  indicator_width1  1
#property  indicator_width2  2
#property  indicator_width3  3
#property  indicator_width4  5
#property  indicator_width5  1
#property  indicator_width6  2
#property  indicator_width7  3
#property  indicator_width8  5

//---- defines

//---- indicator parameters
extern int nCheckBars    = 12;   // number of fore bars to check trade
extern int takePipsStart = 10;   // start of profit level in pips
extern int takePipsEnd   = 40;   // end of profit level in pips (should be (takePipsEnd - takePipsStart)/10 <= 4)
extern int lossPips      = -20;  // loss cut level in pips
extern int profitPips0   = 10;   // mark1 if profit greater than this value
extern int profitPips1   = 20;   // mark2 if profit greater than this value
extern int profitPips2   = 30;   // mark3 if profit greater than this value
extern int profitPips3   = 40;   // mark4 if profit greater than this value
extern double point      = 0;    // ex. 0.01 for USDJPY, 0 is auto(uses Point)
extern double spreadPips = 0;    // ex. 3 for USDJPY, 0 is auto(uses Ask-Bid)

//---- indicator buffers
double BufferLong0[];
double BufferLong1[];
double BufferLong2[];
double BufferLong3[];
double BufferShort0[];
double BufferShort1[];
double BufferShort2[];
double BufferShort3[];

//---- vars
int markLong   = 159;
int markShort  = 159;

//----------------------------------------------------------------------
int init()
{
    string name;
    
    IndicatorShortName("00-SuccessTrade");
    
    for (int i = 0; i < 8; i++) {
	SetIndexStyle(i, DRAW_ARROW);
	if (i < 4) {
	    name = "Long" + i;
	    SetIndexArrow(i, markLong);
	} else {
	    name = "Short" + (i - 4);
	    SetIndexArrow(i, markShort);
	}
	SetIndexLabel(i, name);
    }    
    
    SetIndexBuffer(0, BufferLong0);
    SetIndexBuffer(1, BufferLong1);
    SetIndexBuffer(2, BufferLong2);
    SetIndexBuffer(3, BufferLong3);
    SetIndexBuffer(4, BufferShort0);
    SetIndexBuffer(5, BufferShort1);
    SetIndexBuffer(6, BufferShort2);
    SetIndexBuffer(7, BufferShort3);
    
    if (point == 0) {
	point = Point;
    }
    if (spreadPips == 0) {
	spreadPips = (Ask - Bid) / point;
    }
    
    Print("point= ", point, ", spreadPips= ", spreadPips);
    
    return;
}

//----------------------------------------------------------------------
int start()
{
    int i;
    int limit = Bars - MathMax(IndicatorCounted() - 1, 0);
    if (limit < nCheckBars) {
	limit = nCheckBars;
    }
    if (limit > Bars) {
	return;
    }
    
    for (int iBar = limit - 1; iBar >= nCheckBars - 1; iBar--) {
	// clear
	BufferLong0[iBar]  = 0; BufferLong1[iBar]  = 0; BufferLong2[iBar]  = 0; BufferLong3[iBar]  = 0;
	BufferShort0[iBar] = 0; BufferShort1[iBar] = 0; BufferShort2[iBar] = 0; BufferShort3[iBar] = 0;
	
	double lo, hi, profitPips;
	int kaiTakeMax = 0;
	int uriTakeMax = 0;
	
	for (int take = takePipsStart; take <= takePipsEnd; take += 10) {
	    
	    // kai
	    double kaine = Open[iBar] + spreadPips * point;
	    for (i = 0; i < nCheckBars; i++) {
		hi = High[iBar - i];
		lo = Low[iBar - i];
		profitPips = (lo - kaine) / point;
		if (profitPips <= lossPips) {
		    // failed
		    break;
		}
		profitPips = (hi - kaine) / point;
		if (profitPips >= take) {
		    // succeeded
		    kaiTakeMax = take;
		    break;
		}
	    }
	    
	    // uri
	    double urine = Open[iBar] - spreadPips * point;
	    for (i = 0; i < nCheckBars; i++) {
		hi = High[iBar - i];
		lo = Low[iBar - i];
		profitPips = (urine - hi) / point;
		if (profitPips <= lossPips) {
		    // failed
		    break;
		}
		profitPips = (urine - lo) / point;
		if (profitPips >= take) {
		    // succeeded
		    uriTakeMax = take;
		    break;
		}
	    }
	}
	
	hi = High[iBar];
	lo = Low[iBar];
	
	if (kaiTakeMax >= profitPips0) BufferLong0[iBar] = lo - point * 2;
	if (kaiTakeMax >= profitPips1) BufferLong1[iBar] = lo - point * 3;
	if (kaiTakeMax >= profitPips2) BufferLong2[iBar] = lo - point * 4;
	if (kaiTakeMax >= profitPips3) BufferLong3[iBar] = lo - point * 5;
	
	if (uriTakeMax >= profitPips0) BufferShort0[iBar] = hi + point * 2;
	if (uriTakeMax >= profitPips1) BufferShort1[iBar] = hi + point * 3;
	if (uriTakeMax >= profitPips2) BufferShort2[iBar] = hi + point * 4;
	if (uriTakeMax >= profitPips3) BufferShort3[iBar] = hi + point * 5;
    }
    
    return;
}
