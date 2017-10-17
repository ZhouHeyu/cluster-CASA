function AddLPNtoDLRU(LPN)
% ���øú���ǰ�������жϻ������Ƿ������Ƿ�ɾ��DLRU�����е�����
% ��ɾ��DLRU���������ݣ��������DelLPNInDLRU����
% �ú�����ɽ�������LPN���뵽DLRU�е�MRUλ�ã�ͬʱ����LVBN_list
global DLRU;
% �Ƚ���LPNת��ΪLVBN���Ȳ鿴�ôغ��Ƿ���ڣ�����������½�LVBN����
[LVBN,offset]=LPNtoLVBN(LPN,DLRU.LVBN_MaxSize);
% ���ú���IsLVBNInList
global LPNInfo;
% [LPNInfo]=IsLVBNInList(LVBN,LPNInfo);
IsLVBNInList(LVBN);
% ��������ڸ�LVBN
if LPNInfo.LVBN_index==0
%    ����Ӹ�LVBN��LVBN_list��ͷ��,�ش�СΪ1�����ʾDLRU��LPN������û����صĴ�LPN��ֱ�ӽ���LPN�ƶ���MRUλ�ü���
    DLRU.LPN_list=[LPN,DLRU.LPN_list(:,:)];
    DLRU.LPN_size=DLRU.LPN_size+1;
    operation=1;
else
% ���������еĴصĴ�С��ͬʱ���ô��Ƶ����е�ͷ��
% LPN�����еĴ����ҳҲһ�������ƶ���LPN�Ķ��е�ͷ��
    St=LPNInfo.DLRU_start_index;
    Et=LPNInfo.DLRU_start_index+LPNInfo.cluster_size-1;
    DLRU.LPN_list=[LPN,DLRU.LPN_list(St:Et),DLRU.LPN_list(1:St-1),DLRU.LPN_list(Et+1:end)];
    DLRU.LPN_size=DLRU.LPN_size+1;
    operation=3;
end
% ����UpdateLVBN_list����������LVBN_list
UpdateLVBN_list(LVBN,LPNInfo.LVBN_index,operation);