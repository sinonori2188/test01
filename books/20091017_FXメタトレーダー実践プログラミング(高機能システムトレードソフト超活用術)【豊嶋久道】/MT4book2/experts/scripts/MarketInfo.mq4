//+------------------------------------------------------------------+
//|                                                   MarketInfo.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �X�^�[�g�֐�
int start()
{
   Print("MODE_MAXLOT : �ő働�b�g�� = "+MarketInfo(Symbol(), MODE_MAXLOT));
   Print("MODE_LOTSTEP : ���b�g�̍ŏ��ω��� = "+MarketInfo(Symbol(), MODE_LOTSTEP));
   Print("MODE_MINLOT : �ŏ����b�g�� = "+MarketInfo(Symbol(), MODE_MINLOT));
   Print("MODE_SWAPSHORT : 1���b�g������̔���|�W�V�����̃X���b�v�l(�����ʉ�) = "+MarketInfo(Symbol(), MODE_SWAPSHORT));
   Print("MODE_SWAPLONG : 1���b�g������̔����|�W�V�����̃X���b�v�l(�����ʉ�) = "+MarketInfo(Symbol(), MODE_SWAPLONG));
   Print("MODE_TICKVALUE : 1���b�g�������1pip�̉��i(�����ʉ�) = "+MarketInfo(Symbol(), MODE_TICKVALUE));
   Print("MODE_LOTSIZE : 1���b�g�̃T�C�Y(�ʉݒP��) = "+MarketInfo(Symbol(), MODE_LOTSIZE));
   Print("MODE_STOPLEVEL : �w�l�E�t�w�l�̒l��(pips) = "+MarketInfo(Symbol(), MODE_STOPLEVEL));
   Print("MODE_SPREAD : �X�v���b�h(pips) = "+MarketInfo(Symbol(), MODE_SPREAD));
   Print("MODE_TIME : �ŐV��tick���� = "+TimeToStr(MarketInfo(Symbol(), MODE_TIME), TIME_DATE|TIME_SECONDS));
   Print("MODE_HIGH : �����̍��l = "+MarketInfo(Symbol(), MODE_HIGH));
   Print("MODE_LOW : �����̈��l = "+MarketInfo(Symbol(), MODE_LOW));

   return(0);
}

