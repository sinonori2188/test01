//+------------------------------------------------------------------+
//|                                                   zyunbari02.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ands"
#property link      ""
#property version   "1.00"

#property strict                 //�������[�h
#property indicator_chart_window //�`���[�g�\��
#property indicator_buffers 4    //�o�b�t�@��4(�g�p������̐�)

#property indicator_width1 3
#property indicator_color1 Orange
#property indicator_width2 3
#property indicator_color2 Aqua
#property indicator_width3 3
#property indicator_color3 White
#property indicator_width4 3
#property indicator_color4 White

double buf0_SymbolArrowUp[];
double buf1_SymbolArrowDown[];
double buf2_SymbolArrow161[];
double buf3_SymbolStopSign[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function(���[�h�������̃C�x���g) |
//+------------------------------------------------------------------+
int OnInit()
{
  
   IndicatorBuffers(4);//�g�p������̐�
   
   SetIndexBuffer(0,buf0_SymbolArrowUp);  //�{���o���ド�C���^�b�`����RSI60�ȏ�
   SetIndexStyle(0,DRAW_ARROW);           //���`��
   SetIndexArrow(0,SYMBOL_ARROWUP);       //����(SYMBOL_ARROWUP(241):���A�b�v)
     
   SetIndexBuffer(1,buf1_SymbolArrowDown);//�{���o�������C���^�b�`����RSI40�ȉ�
   SetIndexStyle(1,DRAW_ARROW);           //���`��
   SetIndexArrow(1,SYMBOL_ARROWDOWN);     //�����(SYMBOL_ARROWDOWN(242):���_�E��)

   SetIndexBuffer(2,buf2_SymbolArrow161); //�����ŏ���������ɓ����Ă�����Z
   SetIndexStyle(2,DRAW_ARROW);           //���`��
   SetIndexArrow(2,161);                  //��(SYMBOL_MARU?(161):�ۃT�C��)�@
     
   SetIndexBuffer(3,buf3_SymbolStopSign); //�����Ŕ���������~
   SetIndexStyle(3,DRAW_ARROW);           //����`��
   SetIndexArrow(3,SYMBOL_STOPSIGN);      //�o�c(SYMBOL_STOPSIGN(251):�X�g�b�v�T�C��)

   return(INIT_SUCCEEDED);

}

//�u�p�����[�^�[�̓��́v�ŊO������ύX�������p�����[�^�[
extern int     extLabelSize = 10;         //�������x���傫��
extern int     extOutcomeBars = 1;        //����{��
extern double  extSignDispPips = 2;       //�T�C���\���ʒu����
extern int     extMaxCalcBars = 500000;   //�Ώۖ{���͈�

extern string  Note1="";                  //�C���W�P�[�^�[�ݒ�
extern int     extBandPeriod = 20;        //�{���o������
extern double  extBandSigma = 2.0;        //��
extern int     extUpperLimit60 = 60;      //�ド�C��
extern int     extUpperLimit70 = 70;      //�n�C�G���g���[�I�����C��
extern int     extLowerLimit40 = 40;      //�����C��
extern int     extLowerLimit30 = 30;      //���[�G���g���[�I�����C��
extern int     extRsiPeriod = 9;          //RSI����

int cntHighSignal, cntLowSignal, cntHighOutcome, cntLowOutcome, tmpOutcomeBars = 0;
bool flgHighSignal, flgLowSignal, flgHighEntry, flgLowEntry = false;
double priceHighEntry, priceLowEntry;  //�n�C�G���g���[�A���[�G���g���[���̉��i�ۑ�
double qtyWinDealings, qtyLoseDealings, qtyTotalDealings, perWin; //�������x���\���p


//+------------------------------------------------------------------+
//| Custom indicator iteration function(tick��M�C�x���g)             |
//+------------------------------------------------------------------+
int OnCalculate(const int        rates_total,      //���͂��ꂽ���n��̃o�[��
                const int        prev_calculated,  //�v�Z�ς�(�O��Ăяo����)�̃o�[��
                const datetime   &time[],          //����
                const double     &open[],          //�n�l
                const double     &high[],          //���l
                const double     &low[],           //���l
                const double     &close[],         //�I�l
                const long       &tick_volume[],   //Tick�o����
                const long       &volume[],        //Real�o����
                const int        &spread[])        //�X�v���b�h
{

   //�S�o�[�{������A�m�肵���o�[�̂����v�Z�ς݃o�[�̑��������������āA�ŐV�o�[(�J�����g�o�[)����������
   int qtyLimit = Bars - IndicatorCounted()-1;
   qtyLimit = MathMin(qtyLimit, extMaxCalcBars);


   //�yTick�C�x���g��For���[�v�z�m��o�[�̂������v�Z�o�[�����@�ˁ@����N�������V�K�m��o�[���o���������ɏ���
   for(int i = qtyLimit; i > 0; i--){

      /*-----------------------------------------*/
      // ���s���聃2���(��������)�ȍ~��For���[�v�ŏ�����
      /*-----------------------------------------*/
      //����̏��s����
      if(flgHighEntry == TRUE){
         if(cntHighSignal <= 1){
            tmpOutcomeBars = extOutcomeBars-1;
         }else{
            tmpOutcomeBars = extOutcomeBars;
         }
         if(cntHighOutcome == tmpOutcomeBars){
            if(priceHighEntry < iClose(NULL,0,i)){
               buf2_SymbolArrow161[i] = iLow(NULL,0,i)-5*Point;   //���s�������ߏ���(��)��\��
               flgHighEntry = FALSE;
               qtyWinDealings++;
            }else{
               buf3_SymbolStopSign[i] = iLow(NULL,0,i)-5*Point;   //�t�s�������ߕ���(�~)��\��
               flgHighEntry = FALSE;
               qtyLoseDealings++;
            }
            cntHighOutcome = 0;
         }
         cntHighOutcome++;
      }

      //�����̏��s����
      if(flgLowEntry == TRUE){
         if(cntLowSignal <= 1){
            tmpOutcomeBars = extOutcomeBars-1;
         }else{
            tmpOutcomeBars = extOutcomeBars;
         }
         if(cntLowOutcome == tmpOutcomeBars){        
            if(priceLowEntry > iClose(NULL,0,i)){
               buf2_SymbolArrow161[i] = iHigh(NULL,0,i)+5*Point;   //���s�������ߏ���(��)��\��
               flgLowEntry = FALSE;
               qtyWinDealings++;
            }else{
               buf3_SymbolStopSign[i] = iHigh(NULL,0,i)+5*Point;   //�t�s�������ߕ���(�~)��\��
               flgLowEntry = FALSE;
               qtyLoseDealings++;
            }
            cntLowOutcome = 0;
         }
         cntLowOutcome++;
      }


      /*-----------------------------*/
      // iCustum�֐�
      /*-----------------------------*/
      //�ŐV��RSI�l
      double rsiShift0=iRSI(NULL,                  //�ʉ݃y�A(NULL(0):���݂̒ʉ݂؃A)
                            PERIOD_CURRENT,        //���Ԏ�(PERIOD_CURRENT(0):���݃`���[�g�̎��Ԏ�)
                            extRsiPeriod,          //���ϊ���(extRsiPeriod(9):�O���ϐ�)
                            PRICE_CLOSE,           //�K�p���i(PRICE_CLOSE(0):�I�l)
                            i);                    //�V�t�g(���݃o�[����ɂ��āA�w�肵�����Ԏ��̃o�[�������ߋ������փV�t�g)
      
      //1�{�O��RSI�l
      double rsiShift1=iRSI(NULL,                   //�ʉ݃y�A(NULL(0):���݂̒ʉ݂؃A)
                            PERIOD_CURRENT,         //���Ԏ�(PERIOD_CURRENT(0):���݃`���[�g�̎��Ԏ�)
                            extRsiPeriod,           //���ϊ���(extRsiPeriod(9):�O���ϐ�)
                            PRICE_CLOSE,            //�K�p���i(PRICE_CLOSE(0):�I�l)
                            i+1);                   //�V�t�g(���݃o�[����ɂ��āA�w�肵�����Ԏ��̃o�[�������ߋ������փV�t�g)
      
      //��o���h
      double bandsUpperLine = iBands(NULL,          //�ʉ݃y�A(NULL(0):���݂̒ʉ݂؃A)
                                     PERIOD_CURRENT,//���Ԏ�(PERIOD_CURRENT(0):���݃`���[�g�̎��Ԏ�)
                                     extBandPeriod, //���ϊ���(extBandPeriod(20):�O���ϐ�)
                                     extBandSigma,  //�W���΍�(extBandSigma(2.0��):�O���ϐ�)
                                     0,             //�o���h�V�t�g
                                     PRICE_CLOSE,   //�K�p���i(PRICE_CLOSE(0):�I�l)
                                     MODE_UPPER,    //���C���C���f�b�N�X(MODE_UPPER(1):��̃��C��)
                                     i);            //�V�t�g(���݃o�[����ɂ��āA�w�肵�����Ԏ��̃o�[�������ߋ������փV�t�g)
      //���o���h
      double bandsLowerLine = iBands(NULL,          //�ʉ݃y�A(NULL(0):���݂̒ʉ݂؃A)
                                     PERIOD_CURRENT,//���Ԏ�(PERIOD_CURRENT(0):���݃`���[�g�̎��Ԏ�)
                                     extBandPeriod, //���ϊ���(extBandPeriod(20):�O���ϐ�)
                                     extBandSigma,  //�W���΍�(extBandSigma(2.0��):�O���ϐ�)
                                     0,             //�o���h�V�t�g
                                     PRICE_CLOSE,   //�K�p���i(PRICE_CLOSE(0):�I�l)
                                     MODE_LOWER,    //���C���C���f�b�N�X(MODE_UPPER(2):���̃��C��
                                     i);            //�V�t�g(���݃o�[����ɂ��āA�w�肵�����Ԏ��̃o�[�������ߋ������փV�t�g)


      /*----------------*/
      // ����̏�������
      /*----------------*/
      //RSI60������false
      if(rsiShift0<extUpperLimit60) flgHighSignal=FALSE;
      
      //�{���o����^�b�`����RSI60�ȏ��true
      if(bandsUpperLine<=iHigh(NULL,PERIOD_CURRENT,i) &&
         rsiShift0>=extUpperLimit60) flgHighSignal=TRUE;

      //RSI��70���߂���70�ȉ��ɂȂ�����false
      if(rsiShift1>extUpperLimit70 &&
         rsiShift0<=extUpperLimit70) flgHighSignal=FALSE;

      //flgHighSignal��true�̎�
      if(flgHighSignal==TRUE ){
         buf0_SymbolArrowUp[i] = iLow(NULL,0,i)-5*extSignDispPips*Point;   //��������l�̉��ɏo��
         flgHighEntry = TRUE;                //�G���g���[����flag��true�ɂ��A����R�[�h��ʂ�悤�ɂ���
         priceHighEntry = iClose(NULL,0,i);  //�G���g���[���̉��i�𔻒�p�ɕۑ�(���ʉ݁A�����ԑ��A�V�t�g0)
         cntHighSignal++;                    //�T�C�����o�������J�E���g
      }

      /*----------------*/
      // �����̏�������
      /*----------------*/
      //RSI40�𒴉߂�����false��
      if(rsiShift0>extLowerLimit40) flgLowSignal=FALSE;
      
      //�{���o�����^�b�`����RSI40�ȉ���true
      if(bandsLowerLine>=iLow(NULL,PERIOD_CURRENT,i) &&
         rsiShift0<=extLowerLimit40) flgLowSignal=TRUE;
      
      //RSI��30��������30�ȏ�ɂȂ�����false
      if(rsiShift1<extLowerLimit30 && 
         rsiShift0>=extLowerLimit30) flgLowSignal=FALSE;

      //flgLowSignal��true�̎�
      if(flgLowSignal==TRUE){
         buf1_SymbolArrowDown[i] = iHigh(NULL,0,i)+10*extSignDispPips*Point; //���������l�̏�ɏo��
         flgLowEntry = TRUE;                 //�G���g���[����flag��true�ɂ��A����R�[�h��ʂ�悤�ɂ���
         priceLowEntry = iClose(NULL,0,i);   //�G���g���[���̉��i�𔻒�p�ɕۑ�(���ʉ݁A�����ԑ��A�V�t�g0
         cntLowSignal++;                     //�T�C�����o�������J�E���g
      }


      /*-----------------------------------------*/
      // ���x��(�����񐔁A�����񐔁A����)��\��
      /*-----------------------------------------*/
      //�e�L�X�g���x���I�u�W�F�N�g����
      ObjectCreate("counttotal", //�I�u�W�F�N�g��
                   OBJ_LABEL,    //�I�u�W�F�N�g�^�C�v
                   0,            //�`���[�g�T�u�E�C���h�E�̔ԍ�(0�̓��C���`���[�g�E�C���h�E)
                   0,            //1�Ԗڂ̎��Ԃ̃A���J�[�|�C���g
                   0);           //1�Ԗڂ̉��i�̃A���J�[�|�C���g

      //�{�^���z�u�̋N�_(�`���[�g�̍�������W�̒��S�ɂ���)
      ObjectSet("counttotal",OBJPROP_CORNER,CORNER_LEFT_UPPER);
      // �e�L�X�g���x���I�u�W�F�N�gX���ʒu�ݒ�
      ObjectSet("counttotal",OBJPROP_XDISTANCE,5);
      // �e�L�X�g���x���I�u�W�F�N�gY���ʒu�ݒ�
      ObjectSet("counttotal",OBJPROP_YDISTANCE,15);

      //����񐔂��v�Z
      qtyTotalDealings = qtyWinDealings + qtyLoseDealings;
      //�������l�̌ܓ��Ŋۂ߂ĎZ�o
      if(qtyWinDealings > 0){
         perWin = MathRound((qtyWinDealings / qtyTotalDealings)*100);
       }else{
         perWin = 0;
       }
       
      //�e�L�X�g���x���ɁA�����񐔁E�����񐔁E������\��
      ObjectSetText("counttotal", "Win"+qtyWinDealings+"��"+" Lose: "+qtyLoseDealings+"��"+" ����: "+perWin+"%", extLabelSize, "MS �S�V�b�N",White);


   }
   
   //--- return value of prev_calculated for next call
   return(rates_total);

}

//+------------------------------------------------------------------+
//| expert deinitialization function(�A�����[�h�������̃C�x���g)     |
//+------------------------------------------------------------------+
 int deinit(){

   //�I�u�W�F�N�g�폜
   for(int i = ObjectsTotal()-1; 0 <= i; i--) {
      string ObjName=ObjectName(i);
      if(StringFind(ObjName, "counttotal") >= 0) ObjectDelete(ObjName);
   }

   Comment("");

   return(0);

}
