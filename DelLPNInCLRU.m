function DelLPNInCLRU()
% �ú���ɾ��CLRU�е�LRUλ�õ�����
global CLRU;
% ֱ��ɾ��CLRUβ��������
% �������Ը��ݷ���λѭ������Count��Ѱ���滻��
% while(1)
%     CLRU.LPN_list(2,end)=CLRU.LPN_list(2,end)-1;
%     if CLRU.LPN_list(2,end)==0
%         break;
%     end
%     CLRU.LPN_list=[CLRU.LPN_list(:,end),CLRU.LPN_list(:,1:end-1)];
% end
CLRU.LPN_list=[CLRU.LPN_list(:,1:end-1)];
CLRU.LPN_list_size=CLRU.LPN_list_size-1;