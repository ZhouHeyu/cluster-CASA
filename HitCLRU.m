function HitCLRU(LPN_index,req_type)
% 该函数完成对CLRU命中的操作，根据不同的读写命中请求进行不同的操作
% req_type==0表示写请求命中，req_type!=0读请求命中
global CLRU;
global Stat;
% 读请求命中只是将LPN移动到MRU位置即可
if req_type~=0
%   后续也可以添加增大命中频次C
%     CLRU.LPN_list(2,LPN_index)=CLRU.LPN_list(2,LPN_index)+1;
    CLRU.LPN_list=[CLRU.LPN_list(:,LPN_index),CLRU.LPN_list(:,1:LPN_index-1),CLRU.LPN_list(:,LPN_index+1:end)];
    Stat.read_hit_count=Stat.read_hit_count+1;
% 写命中则需从CLRU中移除该LPN，同时调用AddLPNtoDLRU
else
    Stat.write_hit_count=Stat.write_hit_count+1;
    temp_LPN=CLRU.LPN_list(1,LPN_index);
    CLRU.LPN_list=[CLRU.LPN_list(:,1:LPN_index-1),CLRU.LPN_list(:,LPN_index+1:end)];
    CLRU.LPN_list_size=CLRU.LPN_list_size-1;
    AddLPNtoDLRU(temp_LPN);
end