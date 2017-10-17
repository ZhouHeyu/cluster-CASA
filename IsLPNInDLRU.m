function IsLPNInDLRU(LPN)
% �ú����������LPN����DLRU�е�LPN_list�Ƿ���ڸ�LPN��������ڷ��ظ�LPN��LPN_list�е�����
% ͬʱ���ظ�LPN��Ӧ��LVBN��LVBN_list�Ĵ�����λ�ã��صĴ�С,�ôص�LPN��LPN_list�еĿ�ʼλ��
% ������һ���ṹ��LPNInfo��ʾ,������Ϣ��
% LPN_index,LVBN_index,cluster_size,DLRU_start_index
global DLRU;
global LPNInfo;
% �ú������ú���:
% ---------->LPNtoLVBN
% ---------->IsLVBNInList
% �ú�����ɱ���Ѱ�Ҹ�LPN�Ƿ����DLRU�У��������򷵻ظ�LPN��DLRU�е�index
% ���ز���˵������1��LVBN_index=0,˵���ôز��ڻ������Ҹ�LPNҲ���ڻ�����(LPN_index=0)
% (2)LVBN_index!=0,LPN_index=0,˵���ôص����LPN����DLRU�У�����LPN����DLRU��
LPNInfo.LPN_index=0;
LPNInfo.LVBN_index=0;
LPNInfo.cluster_size=0;
LPNInfo.DLRU_start_index=0;
% �ȿ��ж�DLRU��LPN_list�Ƿ�Ϊ�գ�Ϊ��ֱ�ӷ���
if DLRU.LPN_size==0
    return;
end
[LVBN,offset]=LPNtoLVBN(LPN,DLRU.LVBN_MaxSize);
% �ж��Ƿ���ڸôغţ���������ڣ���ֱ���жϸ�LPN������DLRU��,ֱ�ӷ���
IsLVBNInList(LVBN);
if LPNInfo.LVBN_index==0
    return;
end
% ���LVBN_index��Ϊ0����ʾ���ڸôأ�����cluster_size��start_index���ٶ�λLPN
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
%   ��ʾû���ҵ���LPN���򷵻�0
    LPNInfo.LPN_index=0;
    return;
else
    return ;
end
