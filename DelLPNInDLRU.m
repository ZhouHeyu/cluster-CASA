function DelLPNInDLRU()
% �ú���������Ҫ��DLRU�����ݽ��а���ɾ��ʱ���ã�ͬʱ����LVBN_list������
global DLRU;
global Stat;
% Stat�Ǹ�ͳ����Ϣ�ṹ�壬������д��Ϣwrite_back_count
% �����д����physical_write_count,physical_read_count
% ��д���д���,write_hit_count,read_hit_count
% �ú���Ѱ�ҵ�ǰ����LRUλ�õ����ؽ���ɾ��------XXXXXXXX������
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % �����Ƚ�LVBN_list���������ҵ���λ��i��ʵ�ʵ�ɾ��λ��index=LVBN_list_size-i+1
% temp_list=fliplr(DLRU.LVBN_list);
% [MaxSize,Max_index]=max(temp_list(2,:));
% Max_index=DLRU.LVBN_size-Max_index+1;
% % ��λDLRUɾ����St
% St=sum(DLRU.LVBN_list(2,1:Max_index-1))+1;
% % ȷ��ɾ����ҳ��С����ΪMaxSize
% Et=St+MaxSize-1;
% ��ɾ��DLRU��LPN����,ɾ����ҳ�������ǴصĴ�С
% DLRU.LPN_list=[DLRU.LPN_list(1:St-1),DLRU.LPN_list(Et+1:end)];
% DLRU.LPN_size=DLRU.LPN_size-MaxSize;
% % ����ͳ����Ϣ
% Stat.write_back_count=Stat.write_back_count+MaxSize;
% Stat.physical_write_count=Stat.physical_write_count+MaxSize;
% % ͬʱɾ��LVBN_list�е���Ϣ
% DLRU.LVBN_list=[DLRU.LVBN_list(:,1:Max_index-1),DLRU.LVBN_list(:,Max_index+1:end)];
% DLRU.LVBN_size=DLRU.LVBN_size-1;
% ���ߵ���UpdateLVBN_list����ɾ����Ϣ
% UpdateLVBN_list(LVBN,LVBN_index,4)��
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

%8-19�޸� 
% �㷨�޸ģ�ֱ�ӽ�DLRUβ�������ݾ۴�ɾ������
% ͨ��LVBN_list��λɾ����β��LPN�Ŀ�ʼλ��
St=sum(DLRU.LVBN_list(2,1:end-1))+1;
% ��ɾ��DLRU��LPN���У�ɾ����ҳ��������LVBN_listβ���Ĵش�С
DLRU.LPN_list=[DLRU.LPN_list(1:St-1)];
DLRU.LPN_size=DLRU.LPN_size-DLRU.LVBN_list(2,end);
% ����ͳ����Ϣ
Stat.write_back_count=Stat.write_back_count+DLRU.LVBN_list(2,end);
Stat.physical_write_count=Stat.physical_write_count+DLRU.LVBN_list(2,end);
% ͬʱɾ��LVBN_list�е���Ϣ
DLRU.LVBN_list=[DLRU.LVBN_list(:,1:end-1)];
DLRU.LVBN_size=DLRU.LVBN_size-1;





