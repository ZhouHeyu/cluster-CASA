function DelLPNInDLRU()
% 该函数当操作要对DLRU的数据进行按簇删除时调用，同时更新LVBN_list的数据
global DLRU;
global Stat;
% Stat是个统计信息结构体，包含回写信息write_back_count
% 物理读写次数physical_write_count,physical_read_count
% 读写命中次数,write_hit_count,read_hit_count
% 该函数寻找当前靠近LRU位置的最大簇进行删除------XXXXXXXX不可行
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % 所以先将LVBN_list倒过来，找到该位置i，实际的删除位置index=LVBN_list_size-i+1
% temp_list=fliplr(DLRU.LVBN_list);
% [MaxSize,Max_index]=max(temp_list(2,:));
% Max_index=DLRU.LVBN_size-Max_index+1;
% % 定位DLRU删除点St
% St=sum(DLRU.LVBN_list(2,1:Max_index-1))+1;
% % 确定删除的页大小，即为MaxSize
% Et=St+MaxSize-1;
% 先删除DLRU的LPN队列,删除的页个数就是簇的大小
% DLRU.LPN_list=[DLRU.LPN_list(1:St-1),DLRU.LPN_list(Et+1:end)];
% DLRU.LPN_size=DLRU.LPN_size-MaxSize;
% % 更新统计信息
% Stat.write_back_count=Stat.write_back_count+MaxSize;
% Stat.physical_write_count=Stat.physical_write_count+MaxSize;
% % 同时删除LVBN_list中的信息
% DLRU.LVBN_list=[DLRU.LVBN_list(:,1:Max_index-1),DLRU.LVBN_list(:,Max_index+1:end)];
% DLRU.LVBN_size=DLRU.LVBN_size-1;
% 或者调用UpdateLVBN_list函数删除信息
% UpdateLVBN_list(LVBN,LVBN_index,4)；
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

%8-19修改 
% 算法修改，直接将DLRU尾部的数据聚簇删除即可
% 通过LVBN_list定位删除的尾部LPN的开始位置
St=sum(DLRU.LVBN_list(2,1:end-1))+1;
% 先删除DLRU的LPN队列，删除的页个数就是LVBN_list尾部的簇大小
DLRU.LPN_list=[DLRU.LPN_list(1:St-1)];
DLRU.LPN_size=DLRU.LPN_size-DLRU.LVBN_list(2,end);
% 更新统计信息
Stat.write_back_count=Stat.write_back_count+DLRU.LVBN_list(2,end);
Stat.physical_write_count=Stat.physical_write_count+DLRU.LVBN_list(2,end);
% 同时删除LVBN_list中的信息
DLRU.LVBN_list=[DLRU.LVBN_list(:,1:end-1)];
DLRU.LVBN_size=DLRU.LVBN_size-1;





