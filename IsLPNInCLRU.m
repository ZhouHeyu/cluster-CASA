function IsLPNInCLRU(LPN)
% 该函数完成遍历CLRU的第一行LPN号，查看是否存在该LPN，如果存在，则返回该LPN_index
% 如果不存在，则返回0；
global CLRU;
global LPNInfo;
LPNInfo.LPN_index=0;
% 如果CLRU为空直接返回
if CLRU.LPN_list_size==0
    LPNInfo.LPN_index=0;
    return ;
end
In_flag=0;
for index=1:CLRU.LPN_list_size
    if CLRU.LPN_list(1,index)==LPN
        LPNInfo.LPN_index=index;
        In_flag=1;
        break;
    end
end

if In_flag==0
    LPNInfo.LPN_index=0;
    return;
else
    return ;
end