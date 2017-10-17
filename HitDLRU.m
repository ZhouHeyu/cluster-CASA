function HitDLRU(LPNInfo,req_type,LPN)  
% 完成对DLRU的数据更新
global DLRU;
global Stat;
% 根据读写操作不同，做不同统计信息操作
if req_type~=0
    Stat.read_hit_count=Stat.read_hit_count+1;
else
    Stat.write_hit_count=Stat.write_hit_count+1;
end
% LPN队列中的簇相关页也一起整体移动到LPN的队列的头部
St=LPNInfo.DLRU_start_index;
Et=LPNInfo.DLRU_start_index+LPNInfo.cluster_size-1;
DLRU.LPN_list=[DLRU.LPN_list(St:Et),DLRU.LPN_list(1:St-1),DLRU.LPN_list(Et+1:end)];
operation=2;
% 调用UpdateLVBN_list函数，更新LVBN_list
[LVBN,offset]=LPNtoLVBN(LPN,DLRU.LVBN_MaxSize);
UpdateLVBN_list(LVBN,LPNInfo.LVBN_index,operation);