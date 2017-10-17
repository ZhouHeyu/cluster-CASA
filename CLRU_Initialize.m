function CLRU_Initialize()
% 该函数完成对CLRU的初始化，其中CLRU在主函数中也是一全局变量
global CLRU;
% LPN_list第一行存的是LPN号，第二行存的是访问的频次
CLRU.LPN_list=[];
CLRU.LPN_list_size=0;
