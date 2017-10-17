function IsLVBNInList(LVBN)
% �ú�����ɶ�DLRU�е�LVBN_list�ļ�����
% LPNInfo��һ���ṹ�壬����LVBN�������Ϣ��
% LVBN_index
% cluster_size
% DLRU_start_index
% ���ظ�LPVBN��LVBN_list�е�����Index,�ôصĴ�С���ô���DLRU��LPN_list�п�ʼ��λ��start_index
global DLRU;
global LPNInfo;
% �������򷵻�LVBN_index=0,���򷵻ظ�LVBN��LRU�����е�����λ��,�͵�ǰ�ôصĴ�С
% �ú���Ϊ����һ�����ٶ�λLPN��DLRU�е�λ�ã����ظôص�LPN��DLRU�е���ʼ
% LVBN_list��һ�д����LVBN�ţ��ڶ��д���ǸôصĴ�С
LPNInfo.LVBN_index=0;
LPNInfo.cluster_size=0;
LPNInfo.DLRU_start_index=0;
Count=1;
% �����DLRU�е�LVBN_listΪ�գ�ֱ�ӷ���
if DLRU.LVBN_size==0
    return ;
end

for index=1:DLRU.LVBN_size
    if DLRU.LVBN_list(1,index)==LVBN
        LPNInfo.LVBN_index=index;
        LPNInfo.cluster_size=DLRU.LVBN_list(2,index);
        LPNInfo.DLRU_start_index=Count;
%         test
%         pause;
        break;
    end
    Count=DLRU.LVBN_list(2,index)+Count;
end

