function IsLVBNInList(LVBN)
% 该函数完成对DLRU中的LVBN_list的检索，
% LPNInfo是一个结构体，包含LVBN的相关信息：
% LVBN_index
% cluster_size
% DLRU_start_index
% 返回该LPVBN在LVBN_list中的索引Index,该簇的大小，该簇在DLRU的LPN_list中开始的位置start_index
global DLRU;
global LPNInfo;
% 不存在则返回LVBN_index=0,否则返回该LVBN在LRU队列中的索引位置,和当前该簇的大小
% 该函数为了下一步快速定位LPN在DLRU中的位置，返回该簇的LPN在DLRU中的起始
% LVBN_list第一行存的是LVBN号，第二行存的是该簇的大小
LPNInfo.LVBN_index=0;
LPNInfo.cluster_size=0;
LPNInfo.DLRU_start_index=0;
Count=1;
% 如果该DLRU中的LVBN_list为空，直接返回
if DLRU.LVBN_size==0
    return ;
end

for index=1:DLRU.LVBN_size
    if DLRU.LVBN_list(1,index)==LVBN
        LPNInfo.LVBN_index=index;
        LPNInfo.cluster_size=DLRU.LVBN_list(2,index);
        LPNInfo.DLRU_start_index=Count;
%         test
%         pause;
        break;
    end
    Count=DLRU.LVBN_list(2,index)+Count;
end

