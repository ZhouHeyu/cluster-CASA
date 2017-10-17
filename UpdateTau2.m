function [tau]=UpdateTau2(CLRU_Hit,DLRU_Hit,old)
% flag=CLRU|DLRU=CLRU*10+DLRU
%���ڶ�д����Cr��Cw,���￼�Ƕ�д�ӳٱ���
global DLRU;
global CLRU;
global buf_size;
global FlashParameter;
CLRU_length=CLRU.LPN_list_size;
DLRU_length=DLRU.LPN_size;
Cr_tmp=FlashParameter.rCost;
Cw_tmp=FlashParameter.wCost*FlashParameter.wAmp;

B_CLRU = CLRU_Hit*Cr_tmp/old;
B_DLRU = DLRU_Hit*Cw_tmp/(buf_size-old);

tau = min(max(round(B_CLRU/(B_CLRU+B_DLRU)*buf_size),0.1*buf_size),0.9*buf_size);
% fprintf('B_CLRU=%8.4f,B_DLRU=%8.4f,tau=%d\n',B_CLRU,B_DLRU,tau);
%���ݱ�����һ����Cr+Cw=1
