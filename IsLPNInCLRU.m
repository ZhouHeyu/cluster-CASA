function IsLPNInCLRU(LPN)
% �ú�����ɱ���CLRU�ĵ�һ��LPN�ţ��鿴�Ƿ���ڸ�LPN��������ڣ��򷵻ظ�LPN_index
% ��������ڣ��򷵻�0��
global CLRU;
global LPNInfo;
LPNInfo.LPN_index=0;
% ���CLRUΪ��ֱ�ӷ���
if CLRU.LPN_list_size==0
    LPNInfo.LPN_index=0;
    return ;
end
In_flag=0;
for index=1:CLRU.LPN_list_size
    if CLRU.LPN_list(1,index)==LPN
        LPNInfo.LPN_index=index;
        In_flag=1;
        break;
    end
end

if In_flag==0
    LPNInfo.LPN_index=0;
    return;
else
    return ;
end