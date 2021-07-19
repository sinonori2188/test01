//
// "00-TickSound_v102.mq4" -- 
// 
//    Ver. 1.00  2009/01/02(Fri)  initial version
//    Ver. 1.01  2009/02/06(Fri)  added soundMode, "Allow DLL" is required for SOUND_ACTIVE/INACTIVE
//    Ver. 1.02  2009/02/07(Sat)  changed soundMode to soundState, added soundWindow
// 
// 
#property  copyright "00 - 00mql4@gmail.com"
#property  link      "http://www.mql4.com/"

#include <WinUser32.mqh>

//---- indicator settings
#property  indicator_chart_window

#property  indicator_buffers  0

#import "user32.dll"
int GetForegroundWindow();
#import

//---- defines
#define SOUND_STATE_ALWAYS    0  // sound always
#define SOUND_STATE_ACTIVE    1  // sound when MT4 is foreground
#define SOUND_STATE_INACTIVE  2  // sound when MT4 is not foreground
#define SOUND_WINDOW_ALL      0  // sound 
#define SOUND_WINDOW_FOCUSED  1  // sound when fx pair window is selected

//---- indicator parameters
extern double pipsPerTone       = 1;                   // pips per one tone
extern int    nSkipTicks        = 0;                   // number of skip ticks, for frequently update server
extern bool   bSkipSameTone     = false;               // don't play continuous same tone
extern bool   bMonoTone         = false;               // mono tone or scale
extern bool   bDualTone         = false;               // dualTone, up and down
extern int    monoTone          = 7;                   // C5: 7
extern string sHelp_soundState  = "--- 0:Always  1:Active  2:Inactive";
extern int    soundState        = SOUND_STATE_ALWAYS;  // sound state
extern string sHelp_soundWindow = "--- 0:All Window  1:Focused Window";
extern int    soundWindow       = SOUND_WINDOW_ALL;    // sound window

//---- indicator buffers

//---- vars
string sIndicatorName = "00-TickSound_v102";
string sPrefix;
static string g_toneScale[] = {
    "tone_c4.wav",  // 0
    "tone_d4.wav",  // 1
    "tone_e4.wav",  // 2
    "tone_f4.wav",  // 3
    "tone_g4.wav",  // 4
    "tone_a4.wav",  // 5
    "tone_b4.wav",  // 6
    "tone_c5.wav",  // 7  center
    "tone_d5.wav",  // 8
    "tone_e5.wav",  // 9
    "tone_f5.wav",  // 10
    "tone_g5.wav",  // 11
    "tone_a5.wav",  // 12
    "tone_b5.wav",  // 13
    "tone_c6.wav"   // 14
};
static string g_toneDual[] = {
    "tone_f4.wav",  // 0
    "tone_f4.wav",  // 1
    "tone_f4.wav",  // 2
    "tone_f4.wav",  // 3
    "tone_f4.wav",  // 4
    "tone_f4.wav",  // 5
    "tone_f4.wav",  // 6
    "tone_c5.wav",  // 7  center
    "tone_f5.wav",  // 8
    "tone_f5.wav",  // 9
    "tone_f5.wav",  // 10
    "tone_f5.wav",  // 11
    "tone_f5.wav",  // 12
    "tone_f5.wav",  // 13
    "tone_f5.wav"   // 14
};
static string g_tone[];
int  itone    = 7;
int  itoneLast;
int  itoneMin = 0;
int  itoneMax = 14;

//----------------------------------------------------------------------
void init()
{
    sPrefix = sIndicatorName;
    
    IndicatorShortName(sIndicatorName);
    
    if (bMonoTone) {
	itone = MathMin(MathMax(monoTone, itoneMin), itoneMax);
    }
    pipsPerTone = MathMax(pipsPerTone, 0.01);
    
    ArrayResize(g_tone, ArraySize(g_toneScale));
    if (bDualTone) {
	ArrayCopy(g_tone, g_toneDual);
    } else {
	ArrayCopy(g_tone, g_toneScale);
    }
}

//----------------------------------------------------------------------
void start()
{
    // check sound mode
    if (soundState != SOUND_STATE_ALWAYS && soundWindow != SOUND_WINDOW_ALL) {
	static int s_lastFocusWindow = 0;
	int activeWindow = GetActiveWindow();
	int foregroundWindow = GetForegroundWindow();
	int focusWindow = GetFocus();
	
	if (activeWindow != 0) {
	    s_lastFocusWindow = focusWindow;
	}
	
	if ((soundState == SOUND_STATE_ACTIVE   && activeWindow != foregroundWindow) ||
	    (soundState == SOUND_STATE_INACTIVE && activeWindow == foregroundWindow) ||
	    (soundWindow == SOUND_WINDOW_FOCUSED && s_lastFocusWindow != WindowHandle(Symbol(), Period()))) {
	    // do not play
	    return;
	}
    }
    
    static int counter;
    static double vLast;
    double v = Close[0];
    
    if (vLast == 0) {
	vLast = v;
	counter = 0;
	
	return;
    }
    
    counter++;
    if (counter <= nSkipTicks) {
	
	return;
    }
    counter = 0;
    
    if (bMonoTone) {
	vLast = v;
    } else {
	int t = MathRound((v - vLast) / Point / pipsPerTone);
	if (t != 0) {
	    itone = MathMax(MathMin(itone + t, itoneMax), itoneMin);
	    vLast = v;
	}
    }
    
    if (!bSkipSameTone || itone != itoneLast) {
	string s = g_tone[itone];
	PlaySound(s);
	itoneLast = itone;
    }
}
