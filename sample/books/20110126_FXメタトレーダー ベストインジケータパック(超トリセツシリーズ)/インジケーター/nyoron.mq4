//+------------------------------------------------------------------+
//|                                                       nyoron.mq4 |
//|                           Copyright (c) 2010, Fai Software Corp. |
//|                                    http://d.hatena.ne.jp/fai_fx/ |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2010, Fai Software Corp."
#property link      "http://d.hatena.ne.jp/fai_fx/"

#property indicator_chart_window
// http://useyan.x0.com/s/html/mono-font.htm �����t�H���g�̗�
extern string FontName = "�l�r �o�S�V�b�N";  //"�l�r �S�V�b�N"�@"�l�r ����" "HG�s����" "GungsuhChe"
extern color  FontColor = White; 
extern int    FontSize = 12;   
extern int    LineSpace = 4;//�s��

extern int    XShift = 350;//�I�u�W�F�N�g�Q�̍����X�y�[�X
extern int    YShift = 10;//�I�u�W�F�N�g�Q�̏㑤�X�y�[�X

extern int    BlockShift = 0;// 60�������̃u���b�N�̔z�u�Y�������p

// OS �ɂ����60�����u���b�N�̃T�C�Y���Ⴄ�̂ŗv���ӁB
// �t�H���g�T�C�Y 7�`18 ��z��B

// for Vista
//int BlockSize[] = {0,1,2,3,4,5,6,360,420,480,480,540,600,660,720,780,780,840,900};

// for WindowsXP
int BlockSize[] = {0,1,2,3,4,5,6,300/*7*/,300,300,420/*10*/,420,480,540,540/*14*/,600,660,660,720/*18*/};

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   if(FontSize > 18 ) FontSize = 18;
   if(FontSize <  7 ) FontSize =  7;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   DelObj();
   Comment("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
string msg = 
"�@�@�@�@�@�@�@�@�@�@ �@ -�] '�L�P�P�M�R�"+"\n"+
"�@�@ �@ �@ �@ �@ �@ �^�@�^\" �M�R �R�@�@�_"+"\n"+
"�@�@�@�@�@�@�@�@�@//, '/�@�@�@�@ �R� �@��@�R"+"\n"+
"�@�@�@�@�@�@�@�@ �V {_{�@�@�@ �@�@�@�| ��.�� i| �@��"+"\n"+
"�@�@�@�@�@�@�@�@ �!�����m�@�@�@ �M�R ���@|�Ai|�@�@��"+"\n"+
"�@�@�@�@�@�@�@ �@ �R|l�@���@�@�@���@ |�@.|Ʉ��@ ��"+"\n"+
"�@ �@ �@ �@�@�@�@�@ |́� �_,�_,����j �@|�@, |.�@�@l"+"\n"+
"�@�@�@�@�@�@�@�@�@�@|�@/��l,� __,�@�C�@�g |/ |�@ ��"+"\n"+
".�@�@�@�@�@�@�@�@�@ | /�@ /::|�O/::/�^�@ �R |"+"\n"+
"�@�@�@�@�@�@�@�@�@ | |�@�@l �S��:::/ �q::::�c, |";

CommentOBJ(msg);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
// ���s�ŋ�؂��ď�������B
string CommentOBJ(string msg){
   DelObj();
   int start = 0;
   int i = 0;
   msg = msg + "\n";
   string msg_unit;
   while(i<500){  // 500�s�ȉ���z��
      int n = StringFind(msg,"\n",start);
      if(n!=-1){
         if(n-start > 0){
            msg_unit = StringSubstr(msg,start, n-start);
         }else{
            msg_unit =" ";
         }
         start = n+1;
         //Print(start," ",n," ",msg_unit);
         DrawTXTLine("TXT-"+i,msg_unit,XShift,YShift+i*FontSize+i*LineSpace);
      }else{
         break;
      }
      i++;
   }
}
//+------------------------------------------------------------------+
// TXT- �Ŏn�܂�I�u�W�F�N�g��S�폜����
void DelObj(){
   string objname;
   for(int i=ObjectsTotal();i>=0;i--){
      objname = ObjectName(i);
      if( StringFind(objname,"TXT-")>=0) ObjectDelete(objname);
   }
}
//+------------------------------------------------------------------+
// 60�������ɋ�؂��ă��x���I�u�W�F�N�g���쐬����B
void DrawTXTLine(string objname, string msg, int X, int Y)   
{   
   int len = StringLen(msg);
   for(int i=0;i*60<len;i++){
      string submsg = StringSubstr(msg,60*i,60);
      ObjectCreate(objname+i,OBJ_LABEL,0,0,0);   
      ObjectSet(objname+i,OBJPROP_XDISTANCE, X+(BlockSize[FontSize]+BlockShift)*i);   
      ObjectSet(objname+i,OBJPROP_YDISTANCE, Y);  
      ObjectSetText(objname+i,submsg,FontSize,FontName,FontColor);   
   }
}  
//+------------------------------------------------------------------+

