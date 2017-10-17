function IsLPNInDLRU(LPN)
% 该函数对输入的LPN检索DLRU中的LPN_list是否存在该LPN，如果存在返回该LPN在LPN_list中的索引
% 同时返回该LPN对应的LVBN在LVBN_list的簇索引位置，簇的大小,该簇的LPN在LPN_list中的开始位置
% 可以用一个结构体LPNInfo表示,包含信息：
% LPN_index,LVBN_index,cluster_size,DLRU_start_index
global DLRU;
global LPNInfo;
% 该函数调用函数:
% ---------->LPNtoLVBN
% ---------->IsLVBNInList
% 该函数完成遍历寻找该LPN是否存在DLRU中，若存在则返回该LPN在DLRU中的index
% 返回参数说明：（1）LVBN_index=0,说明该簇不在缓冲区且该LPN也不在缓冲区(LPN_index=0)
% (2)LVBN_index!=0,LPN_index=0,说明该簇的相关LPN存在DLRU中，但该LPN不在DLRU中
LPNInfo.LPN_index=0;
LPNInfo.LVBN_index=0;
LPNInfo.cluster_size=0;
LPNInfo.DLRU_start_index=0;
% 先看判断DLRU的LPN_list是否为空，为空直接返回
if DLRU.LPN_size==0
    return;
end
[LVBN,offset]=LPNtoLVBN(LPN,DLRU.LVBN_MaxSize);
% 判断是否存在该簇号，如果不存在，可直接判断该LPN不存在DLRU中,直接返回
IsLVBNInList(LVBN);
if LPNInfo.LVBN_index==0
    return;
end
% 如果LVBN_index不为0，表示存在该簇，利用cluster_size和start_index快速定位LPN
St=LPNInfo.DLRU_start_index;
Et=LPNInfo.DLRU_start_index+LPNInfo.cluster_size-1;
In_flag=0;
for index=St:Et
    if DLRU.LPN_list(index)==LPN
        LPNInfo.LPN_index=index;
        In_flag=1;
        break;
    end
end

if In_flag==0
%   表示没有找到该LPN，则返回0
    LPNInfo.LPN_index=0;
    return;
else
    return ;
end
