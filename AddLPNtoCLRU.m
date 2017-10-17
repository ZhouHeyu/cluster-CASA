function addLPNtoCLRU(LPN)
% 该函数完成把新的读请求的LPN加载到CLRU
global CLRU;
% 初始加载的LPN，第二行（访问频次）为1
buf_temp=[LPN,1]';
CLRU.LPN_list=[buf_temp,CLRU.LPN_list(:,:)];
CLRU.LPN_list_size=CLRU.LPN_list_size+1;