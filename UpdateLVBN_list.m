function UpdateLVBN_list(LVBN,LVBN_index,operation)
% operation=1：LVBN是新加载的簇号，更新簇队列的位置，LVBN_index=0
% operation=2：LVBN是命中簇，更新簇队列的位置
% operation=3：LVBN是未命中，加载簇中的LPN，并更新簇队列的位置,加载数据到DLRU现有的簇
% operation=4：伴随DLRU删除该簇，从簇LRU队列中删除该簇相关信息
global DLRU;
if operation==1
    temp=[LVBN,1]';
    DLRU.LVBN_list=[temp,DLRU.LVBN_list];
    DLRU.LVBN_size=DLRU.LVBN_size+1;
elseif operation==2
    DLRU.LVBN_list=[DLRU.LVBN_list(:,LVBN_index),DLRU.LVBN_list(:,1:LVBN_index-1),DLRU.LVBN_list(:,LVBN_index+1:end)];
elseif operation==3
    DLRU.LVBN_list(2,LVBN_index)=DLRU.LVBN_list(2,LVBN_index)+1;
    DLRU.LVBN_list=[DLRU.LVBN_list(:,LVBN_index),DLRU.LVBN_list(:,1:LVBN_index-1),DLRU.LVBN_list(:,LVBN_index+1:end)];
elseif operation==4
    DLRU.LVBN_list=[DLRU.LVBN_list(:,1:LVBN_index-1),DLRU.LVBN_list(:,LVBN_index+1:end)];
    DLRU.LVBN_size=DLRU.LVBN_size-1;
end