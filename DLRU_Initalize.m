function DLRU_Initalize()
% DLRU是一个全局变量在，主函数main.m中也需要定义global DLRU
global DLRU;
% LVBN_list第一行存的是LVBN号，第二行存的是该LVBN簇的大小
DLRU.LVBN_list=[];
DLRU.LVBN_size=0;
% LPN_list存的是LPN号
DLRU.LPN_list=[];
DLRU.LPN_size=0;
% MaxSize是定义最大的簇大小
DLRU.LVBN_MaxSize=8;
% 存放的是LVBN中当前最大的簇
DLRU.LVBN_CurrMaxSize=0;
% 存放的是LVBN中最大的簇在LVBN_list的位置
DLRU.LVBN_MaxIndex=0;
% 存放最大簇在LVBN_list中的索引