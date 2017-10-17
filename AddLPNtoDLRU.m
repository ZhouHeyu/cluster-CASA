function AddLPNtoDLRU(LPN)
% 调用该函数前，需先判断缓冲区是否满，是否删除DLRU队列中的数据
% 如删除DLRU队列中数据，则需调用DelLPNInDLRU函数
% 该函数完成将新来的LPN加入到DLRU中的MRU位置，同时更新LVBN_list
global DLRU;
% 先将该LPN转换为LVBN，先查看该簇号是否存在，如果不存在新建LVBN插入
[LVBN,offset]=LPNtoLVBN(LPN,DLRU.LVBN_MaxSize);
% 调用函数IsLVBNInList
global LPNInfo;
% [LPNInfo]=IsLVBNInList(LVBN,LPNInfo);
IsLVBNInList(LVBN);
% 如果不存在该LVBN
if LPNInfo.LVBN_index==0
%    则添加该LVBN至LVBN_list的头部,簇大小为1，则表示DLRU的LPN队列中没有相关的簇LPN，直接将该LPN移动至MRU位置即可
    DLRU.LPN_list=[LPN,DLRU.LPN_list(:,:)];
    DLRU.LPN_size=DLRU.LPN_size+1;
    operation=1;
else
% 则增加现有的簇的大小，同时将该簇移到队列的头部
% LPN队列中的簇相关页也一起整体移动到LPN的队列的头部
    St=LPNInfo.DLRU_start_index;
    Et=LPNInfo.DLRU_start_index+LPNInfo.cluster_size-1;
    DLRU.LPN_list=[LPN,DLRU.LPN_list(St:Et),DLRU.LPN_list(1:St-1),DLRU.LPN_list(Et+1:end)];
    DLRU.LPN_size=DLRU.LPN_size+1;
    operation=3;
end
% 调用UpdateLVBN_list函数，更新LVBN_list
UpdateLVBN_list(LVBN,LPNInfo.LVBN_index,operation);