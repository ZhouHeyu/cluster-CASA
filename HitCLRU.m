function HitCLRU(LPN_index,req_type)
% �ú�����ɶ�CLRU���еĲ��������ݲ�ͬ�Ķ�д����������в�ͬ�Ĳ���
% req_type==0��ʾд�������У�req_type!=0����������
global CLRU;
global Stat;
% ����������ֻ�ǽ�LPN�ƶ���MRUλ�ü���
if req_type~=0
%   ����Ҳ���������������Ƶ��C
%     CLRU.LPN_list(2,LPN_index)=CLRU.LPN_list(2,LPN_index)+1;
    CLRU.LPN_list=[CLRU.LPN_list(:,LPN_index),CLRU.LPN_list(:,1:LPN_index-1),CLRU.LPN_list(:,LPN_index+1:end)];
    Stat.read_hit_count=Stat.read_hit_count+1;
% д���������CLRU���Ƴ���LPN��ͬʱ����AddLPNtoDLRU
else
    Stat.write_hit_count=Stat.write_hit_count+1;
    temp_LPN=CLRU.LPN_list(1,LPN_index);
    CLRU.LPN_list=[CLRU.LPN_list(:,1:LPN_index-1),CLRU.LPN_list(:,LPN_index+1:end)];
    CLRU.LPN_list_size=CLRU.LPN_list_size-1;
    AddLPNtoDLRU(temp_LPN);
end