function UpdateLVBN_list(LVBN,LVBN_index,operation)
% operation=1��LVBN���¼��صĴغţ����´ض��е�λ�ã�LVBN_index=0
% operation=2��LVBN�����дأ����´ض��е�λ��
% operation=3��LVBN��δ���У����ش��е�LPN�������´ض��е�λ��,�������ݵ�DLRU���еĴ�
% operation=4������DLRUɾ���ôأ��Ӵ�LRU������ɾ���ô������Ϣ
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