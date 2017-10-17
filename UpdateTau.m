function [tau]=UpdateTau(tau,flag)
% flag=CLRU|DLRU=CLRU*10+DLRU
%���ڶ�д����Cr��Cw,���￼�Ƕ�д�ӳٱ���
global DLRU;
global CLRU;
global buf_size;
CLRU_length=CLRU.LPN_list_size;
DLRU_length=DLRU.LPN_size;
Cr_tmp=1;
Cw_tmp=9;
%���ݱ�����һ����Cr+Cw=1
Cr=Cr_tmp/(Cr_tmp+Cw_tmp);
Cw=Cw_tmp/(Cr_tmp+Cw_tmp);

% ����CLRU��DLRUȫû���У����޳�
if flag==0;
    return;
end

if flag==10
%     ����CLRU������tau��ֵ
      tau_increment=round((DLRU_length/CLRU_length)*Cr);%������������ȡ��
      tau=tau+tau_increment;
% ����tau�ı߽����,��ֹDLRU���ּ���Ϊ�յ����
       if tau>=buf_size
           tau=buf_size-1;
       end
else  %flag=1��ʾ����DLRU
%     ����DLRU����Сtau��ֵ
%     ����DLRU����ʾ��ǰ��д����Ϊ������Ҫ���ӵ�ֵ
       tau_decrease=round((CLRU_length/DLRU_length)*Cw);
       tau=tau-tau_decrease;
% ������޸�,��ֹ���ָɾ�ҳ���г���Ϊ�յļ������
       if tau<=0
           tau=1;
       end
end