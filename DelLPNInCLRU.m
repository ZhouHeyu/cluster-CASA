function DelLPNInCLRU()
% 该函数删除CLRU中的LRU位置的数据
global CLRU;
% 直接删除CLRU尾部的数据
% 后续可以根据访问位循环遍历Count来寻找替换项
% while(1)
%     CLRU.LPN_list(2,end)=CLRU.LPN_list(2,end)-1;
%     if CLRU.LPN_list(2,end)==0
%         break;
%     end
%     CLRU.LPN_list=[CLRU.LPN_list(:,end),CLRU.LPN_list(:,1:end-1)];
% end
CLRU.LPN_list=[CLRU.LPN_list(:,1:end-1)];
CLRU.LPN_list_size=CLRU.LPN_list_size-1;