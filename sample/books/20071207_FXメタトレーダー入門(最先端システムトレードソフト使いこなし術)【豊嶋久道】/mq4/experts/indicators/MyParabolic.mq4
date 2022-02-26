//+------------------------------------------------------------------+
//|                                                  MyParabolic.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Blue

//�w�W�o�b�t�@
double BufSAR[];

//�p�����[�^�[
extern double Step = 0.02;
extern double Maximum = 0.2;

//+------------------------------------------------------------------+
//| �������֐�                                                       |
//+------------------------------------------------------------------+
int init()
{
   //�w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0,BufSAR);

   //�w�W���x���̐ݒ�
   SetIndexLabel(0, "SAR("+DoubleToStr(Step,2)+","+DoubleToStr(Maximum,1)+")");

   //�w�W�X�^�C���̐ݒ�
   SetIndexStyle(0,DRAW_ARROW,STYLE_SOLID,1,Blue);
   SetIndexArrow(0,159);

   return(0);
}
//+------------------------------------------------------------------+
//| �w�W�����֐�                                                     |
//+------------------------------------------------------------------+
int start()
{
   int last_period=1;    //�ō��l�E�ň��l�����߂����
   bool dir_long = true; //���[�h
   double step=Step;     //�X�e�b�v��
   double Ep0;           //���݂̍ō��l�E�ň��l     
   double Ep1;           //1�o�[�O�̍ō��l�E�ň��l     

   int limit=Bars;
   BufSAR[limit-1] = Low[limit-1];

   for(int i=limit-2; i>=0; i--)
   {
      if(dir_long == true) //�㏸���[�h
      {
         Ep1 = High[iHighest(NULL,0,MODE_HIGH,last_period,i+1)]; //1�o�[�O�̍ō��l
         BufSAR[i] = BufSAR[i+1]+step*(Ep1-BufSAR[i+1]); //SAR�̌v�Z��
         Ep0 = MathMax(Ep1, High[i]);  //���݂̍ō��l
         if(Ep0 > Ep1 && step+Step <= Maximum) step += Step; //�X�e�b�v���̍X�V
         if(BufSAR[i] > Low[i]) //���[�h�̐؂�ւ�
         {
            dir_long = false;
            BufSAR[i] = Ep0;
            last_period=1;
            step=Step;
            continue;
         }
      }
      else //���~���[�h
      {
         Ep1 = Low[iLowest(NULL,0,MODE_LOW,last_period,i+1)]; //1�o�[�O�̍ň��l
         BufSAR[i] = BufSAR[i+1]+step*(Ep1-BufSAR[i+1]); //SAR�̌v�Z��
         Ep0 = MathMin(Ep1, Low[i]); //���݂̍ň��l
         if(Ep0 < Ep1 && step+Step <= Maximum) step += Step; //�X�e�b�v���̍X�V
         if(BufSAR[i] < High[i]) //���[�h�̐؂�ւ�
         {
            dir_long = true;
            BufSAR[i] = Ep0;
            last_period=1;
            step=Step;
            continue;
         }
      }
      last_period++;      
   }

   return(0);
}
//+------------------------------------------------------------------+