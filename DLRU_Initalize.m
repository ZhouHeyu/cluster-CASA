function DLRU_Initalize()
% DLRU��һ��ȫ�ֱ����ڣ�������main.m��Ҳ��Ҫ����global DLRU
global DLRU;
% LVBN_list��һ�д����LVBN�ţ��ڶ��д���Ǹ�LVBN�صĴ�С
DLRU.LVBN_list=[];
DLRU.LVBN_size=0;
% LPN_list�����LPN��
DLRU.LPN_list=[];
DLRU.LPN_size=0;
% MaxSize�Ƕ������Ĵش�С
DLRU.LVBN_MaxSize=8;
% ��ŵ���LVBN�е�ǰ���Ĵ�
DLRU.LVBN_CurrMaxSize=0;
% ��ŵ���LVBN�����Ĵ���LVBN_list��λ��
DLRU.LVBN_MaxIndex=0;
% ���������LVBN_list�е�����