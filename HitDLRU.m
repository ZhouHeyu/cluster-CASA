function HitDLRU(LPNInfo,req_type,LPN)  
% ��ɶ�DLRU�����ݸ���
global DLRU;
global Stat;
% ���ݶ�д������ͬ������ͬͳ����Ϣ����
if req_type~=0
    Stat.read_hit_count=Stat.read_hit_count+1;
else
    Stat.write_hit_count=Stat.write_hit_count+1;
end
% LPN�����еĴ����ҳҲһ�������ƶ���LPN�Ķ��е�ͷ��
St=LPNInfo.DLRU_start_index;
Et=LPNInfo.DLRU_start_index+LPNInfo.cluster_size-1;
DLRU.LPN_list=[DLRU.LPN_list(St:Et),DLRU.LPN_list(1:St-1),DLRU.LPN_list(Et+1:end)];
operation=2;
% ����UpdateLVBN_list����������LVBN_list
[LVBN,offset]=LPNtoLVBN(LPN,DLRU.LVBN_MaxSize);
UpdateLVBN_list(LVBN,LPNInfo.LVBN_index,operation);