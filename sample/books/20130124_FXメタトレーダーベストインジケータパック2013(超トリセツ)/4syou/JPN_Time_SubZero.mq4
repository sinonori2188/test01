#property copyright "ver.2.4"
#property link "http://d.hatena.ne.jp/fai_fx/"
//�쐬��ʂƃo�b�t�@�̎w��
#property indicator_separate_window
#property indicator_minimum -1
#property indicator_maximum 2

//�����ݒ�ϐ�
// �����̃f�t�H���g�ݒ�ɍ��킹�ăJ�X�^�}�C�Y����̂��悢�B
extern int TimeInterval = 12;
extern bool UseLocalPCTime = true;
//UseLocalPCTime��true �̎��́A����Time_difference�@���g��Ȃ��̂Œ��� 
extern int Time_difference = 9;
extern bool Grid   = true;
extern bool YEAR   = false;
extern bool MONTH  = false;
extern bool DAY    = false;
extern bool HOUR   = true;
extern bool Zero_H = false;
extern bool MINUTE = false;
extern bool SECOND = false;
extern bool ARROW  = false;
extern bool NewLine= false;
extern color GridColor = LightSlateGray;//C'32,32,32';
extern int FontSize = 8;
extern color TextColor = White;
extern bool UseColorGrid= false;
extern bool Use12Hour= false;
string  WinName="  ";//�X�y�[�X2����
int DefPeri;

//������
int init(){
   IndicatorShortName(WinName);
   IndicatorDigits(0);
   SetIndexLabel(0,NULL);
   if(DefPeri != Period()){
      DefPeri = Period();
      DeleteTimeObject();
   }
   if(!YEAR && !MONTH && !DAY) NewLine = false;
   return(0);
}


//�I�����@���ԕ\�����폜
int deinit(){
   DeleteTimeObject();
   return(0);
}


int start(){

   if(Bars < 50 ) return(0);
   if(Volume[0] < 2 ) return(0);
   int limit=Bars-IndicatorCounted()-1;
   if(limit < WindowBarsPerChart() ) limit = WindowBarsPerChart();
   static datetime PreBarsTime  = 0;
   static datetime StandardTime = 0;    
   
   //���[�J�����Ԍ��o  
   if(UseLocalPCTime){
      int Time_difference0 = (TimeLocal()-TimeCurrent()+15*60)/3600;
      if(Time_difference != Time_difference0){
         PreBarsTime = Time[Bars-1];
         DeleteTimeObject();
         StandardTime = 0;
      }      
      if(Time_difference0 > 10){
         static int checkcount = 0;
         checkcount++;
         if(checkcount>10){
           UseLocalPCTime = false;
           Alert(Symbol(),Period()," Can't detect LocalTime difference\n Now use Time_difference = ",Time_difference);
         }
      }else{
         Time_difference = Time_difference0;
         //Print("Time_difference =",Time_difference);
      } 
   }
        

   //�X�N���[���o�b�N������A��蒼��
   if(PreBarsTime != Time[Bars-1]){
      PreBarsTime = Time[Bars-1];
      DeleteTimeObject();
      StandardTime = 0;
   }
   
   //����Ԃ̊J�n���������߂�   
   if(StandardTime == 0){
      for(int j=Bars-1; j>=0; j--){
         if(TimeMinute(Time[j])==0 && TimeHour(Time[j]+Time_difference * 3600)==0){
            StandardTime = Time[j]-24*60*60;//�J�n�����́A�P���O����B
            break;
         }
      }
   }
   datetime Period_Interval = DefPeri * 60 * TimeInterval;
   
   //Chart repaint �ɔ�����10�{�O�����蒼����悤�ɁB
   StandardTime = StandardTime - 10 * Period_Interval;
   
   for(int i=limit; i>=0; i--){
      //����ԂɈ�v������쐬
      if(StandardTime == Time[i]  ){
         SetTimeText(Time[i],Time_difference);
      }
      //���̊���Ԃ�ݒ肷��
      while(StandardTime <= Time[i]) StandardTime = StandardTime + Period_Interval;      
   }
   return(0);
}

void SetTimeText(datetime settime,int Time_difference){
   //���{���Ԃ̐���
   datetime JPNT = settime + Time_difference * 3600;
   //���t������̍쐬
   string Y="";
   string M="";
   string D="";
   string JPND,JPNM;
  
   JPND = StringSubstr(TimeToStr(JPNT, TIME_DATE),2);
  
   if(YEAR){
      Y=StringSubstr(JPND,0,2);
   }
   if(MONTH){
      if(YEAR){
         Y=StringConcatenate(Y,".");
      }
      M=StringSubstr(JPND,3,2);
   }
   if(DAY){
      if(YEAR || MONTH){
         M=StringConcatenate(M,".");
      }
      D=StringSubstr(JPND,6,2);
   }
   JPND=StringConcatenate(Y,M,D);
 

   //���ԕ�����̍쐬
   string h="";
   string m="";
   string s="";

   JPNM = TimeToStr(JPNT, TIME_SECONDS);
   if(HOUR){
      h=StringSubstr(JPNM,0,2);
      if(!Zero_H) h=TimeHour(JPNT);
   }
   if(MINUTE){
      if(HOUR){
         h=StringConcatenate(h,":");
      }
      m=StringSubstr(JPNM,3,2);
   }
   if(SECOND){
      if(HOUR || MINUTE){
         m=StringConcatenate(m,":");
      }
      s=StringSubstr(JPNM,6,2);
   }
   JPNM=StringConcatenate(h,m,s);
   string tm = TimeToStr(settime,TIME_DATE|TIME_SECONDS);
   //�����I�u�W�F�N�g�����݂��Ȃ���΍쐬
   if(ObjectFind(StringConcatenate("JPNTZ_",tm)) == -1){
      MakeTimeObject(StringConcatenate("JPNTZ_Arrow",tm),
      StringConcatenate("JPNTZ_",tm),
      StringConcatenate("JPNTZ_Text",tm,"_2"),StringConcatenate("JPNTZ_Grid_",tm),JPND,JPNM,settime);
   }
}

void MakeTimeObject(string ArrowName,string TimeTextName1,string TimeTextName2,string GridName,string DATE,string TIME,datetime settime){
   int DefWin=WindowFind(WinName);
   int Pos=2;

   //���̍쐬
   if(ARROW){
      ObjectCreate(ArrowName, OBJ_ARROW,DefWin,settime, Pos);
      Pos--;
      ObjectSet(ArrowName,OBJPROP_ARROWCODE,241);
      ObjectSet(ArrowName,OBJPROP_COLOR,TextColor);
   }
   
   if(NewLine){
      //2�s�ŕ\��
      //���t�̍쐬
      ObjectCreate(TimeTextName1, OBJ_TEXT,DefWin,settime, Pos);
      Pos--;
      ObjectSetText(TimeTextName1, DATE, FontSize, "Arial", TextColor);

      //���Ԃ̍쐬
      ObjectCreate(TimeTextName2, OBJ_TEXT,DefWin,settime, Pos);
      //Pos--;
      ObjectSetText(TimeTextName2, TIME, FontSize, "Arial", TextColor);

   }else{
      //1�s�ŕ\��
      if(!ObjectCreate(TimeTextName1, OBJ_TEXT,DefWin,settime, Pos))
      {
         Print("error: can't create OBJ_TEXT! code #",GetLastError());
         return(0);
      }
      //Pos--;
      if(YEAR || MONTH || DAY){
         if(HOUR || MINUTE || SECOND){
            ObjectSetText(TimeTextName1, StringConcatenate(DATE,"_",TIME), FontSize, "Arial", TextColor);
         }else{
            ObjectSetText(TimeTextName1, DATE, FontSize, "Arial", TextColor);
         }
      }else if(HOUR || MINUTE || SECOND){
            //ObjectSetText(TimeTextName1, TIME, FontSize, "Arial", TextColor);
            color MyTextColor = TextColor;
            if(StrToInteger(TIME)>12 && Use12Hour){
               MyTextColor = DeepSkyBlue;
               TIME = StrToInteger(TIME)-12;
            }
            ObjectSetText(TimeTextName1, TIME, FontSize, "Arial", MyTextColor);
      }
   }
   //�O���b�h�̍쐬
   if(Grid){
      int hr = TimeHour(settime+Time_difference * 3600);
      color MyGridColor = GridColor;
      // ���莞���̃��C���ɐF�Â�����Ȃ�ȉ���K���ɏ���������
      if(UseColorGrid){
         if(hr == 16) MyGridColor = IndianRed;
         if(hr == 21 || hr == 0 || hr == 4) MyGridColor = SteelBlue;
      }
      ObjectCreate(GridName,OBJ_TREND, 0, settime,0,settime,0.1);
      ObjectSet(GridName,OBJPROP_COLOR,MyGridColor);
      ObjectSet(GridName, OBJPROP_STYLE, STYLE_DOT);
      ObjectSet(GridName, OBJPROP_BACK,true);
   }
   WindowRedraw();
}

void DeleteTimeObject(){
   //���\�b�h���炷�ׂẴI�u�W�F�N�g���擾���č폜
   for(int i=ObjectsTotal();i>=0;i--){
      string ObjName=ObjectName(i);
      if(StringSubstr(ObjName,0,5) == "JPNTZ"){
         ObjectDelete(ObjName);
      }
   }
}