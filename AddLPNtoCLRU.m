function addLPNtoCLRU(LPN)
% �ú�����ɰ��µĶ������LPN���ص�CLRU
global CLRU;
% ��ʼ���ص�LPN���ڶ��У�����Ƶ�Σ�Ϊ1
buf_temp=[LPN,1]';
CLRU.LPN_list=[buf_temp,CLRU.LPN_list(:,:)];
CLRU.LPN_list_size=CLRU.LPN_list_size+1;