% �������߼�
clc
clear all
% ��������ļ�������Ľ���ļ�
trace_filename='.\test_trace\syn4';%���������trace�ļ�
output_filename='.\result\CASA_cluster\trace_syn4_cluster_CASA_RW19_buf1000_var.mat';%���������ָ���ļ�
global ReqSec;
[ReqSec.arrive,ReqSec.device_num,ReqSec.start,ReqSec.size,ReqSec.type]=textread(trace_filename,'%f%d%d%d%d');
% %��ȡtrace�ļ��е�������������󵽴�ʱ�䣬�豸�ţ�������������ʼλ�ã�����������С������������ͣ�

% �ؼ���ȫ�ֱ�������
global LPNInfo;
global Stat;
global CLRU;
global DLRU;
global buf_size;
buf_size=1000;
% tau��Ŀ��ɾ�ҳCLRU���еĳ���
tau=buf_size/2;
DLRU_Initalize();
CLRU_Initialize();
Stat_Initalize();

%�������������н��д���ͳ��,�ж����о����ж��ٴ�����
all_req_sec_num=length(ReqSec.start);
%��ʼ�������󣬽���ѭ��
for req_index=1:all_req_sec_num
    %request_index��ʾ��ǰ�����������������еĴ���
    %����������ҳ����
    [ReqLPN]=PageAlignment(req_index);
    Stat.all_page_req_num=Stat.all_page_req_num+ReqLPN.size;%ͳ�����е�ҳ�������
    while(ReqLPN.size>0)
        % ���һ��LPN���ȱ������������鿴�Ƿ����LPN
        % IsLPNInCLRU,�鿴���ص�LPNIfno��Ϣ��
        InCLRU=0;
        InDLRU=0;
        LPNInfo_Initialize();
        IsLPNInCLRU(ReqLPN.start);
        if LPNInfo.LPN_index~=0
            InCLRU=1;
            Stat.hit_count=Stat.hit_count+1;
    %       ͬʱ�ж�CLRU���еĲ������ͣ������в�����д���в���
    %       ���ú���HitCLRU(LPN_index,LPN,req_type)
            HitCLRU(LPNInfo.LPN_index,ReqLPN.type);
        end    
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         
    %   ���CLRU�в����ڸ�LPN������ű���DLRU
        if InCLRU==0
            IsLPNInDLRU(ReqLPN.start);
        end
    %   �������DLRU��
        if (LPNInfo.LPN_index~=0&&InCLRU==0)
            InDLRU=1;
            Stat.hit_count=Stat.hit_count+1;
    %       ͬʱ�ж�DLRU���еĲ������ͣ������в�����д���в���
    %       ���ú���HitDLRU(LPNInfo,LPN,ReqLPN.type)  
            HitDLRU(LPNInfo,ReqLPN.type,ReqLPN.start);
        end
    %   flag1��ʾ����DLRU������10��ʾ����CLRU��0��ʾû��û�����л�����
        flag=InCLRU*10+InDLRU;
        [tau]=UpdateTau2(tau,flag);
        InBuf=InCLRU+InDLRU;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         
    %   ���û�����л�����
        if InBuf==0
            Stat.miss_count=Stat.miss_count+1;
    %       �жϻ�������û����
            if DLRU.LPN_size+CLRU.LPN_list_size>=buf_size;
    %          ������������ˣ������޳�����
               if CLRU.LPN_list_size<tau
    %               �����޳�DLRU
                    DelLPNInDLRU();
               else
    %              �����޳�CLRU
                   DelLPNInCLRU();
               end
            end
    %       ���������޳�������ɣ����߻�����û����������buf��
            if ReqLPN.type~=0
    %             ��������ص�CLRU
                  Stat.read_miss_count=Stat.read_miss_count+1;
                  AddLPNtoCLRU(ReqLPN.start);
                  Stat.physical_read_count=Stat.physical_read_count+1;
            else
                Stat.write_miss_count=Stat.write_miss_count+1;
    %             д������ص�DLRU
                AddLPNtoDLRU(ReqLPN.start);
                Stat.physical_read_count=Stat.physical_read_count+1;
            end
        end%-------   ���û�����л�����
        ReqLPN.size=ReqLPN.size-1;%����ҳ���һ�Σ���С��һ
        ReqLPN.start=ReqLPN.start+1;
    end
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% ���ݴ�����
%����������
hit_rate=double((Stat.all_page_req_num-Stat.miss_count))/Stat.all_page_req_num;
%����д������
write_hit_rate=double(Stat.write_hit_count)/(Stat.write_hit_count+Stat.write_miss_count);
%�����������
read_hit_rate=double(Stat.read_hit_count)/(Stat.read_hit_count+Stat.read_miss_count);

%�������
fprintf('the all_page_req_num is %d\n',Stat.all_page_req_num);
fprintf('the hit rate is %10.8f\n',hit_rate);
fprintf('the  all_write_count is %d\n', Stat.write_miss_count+Stat.write_hit_count);
fprintf('the  write_hit_count is %d\n', Stat.write_hit_count);
fprintf('the write_hit_rate is %10.8f\n',write_hit_rate);
fprintf('the  all_read_count is %d\n', Stat.read_miss_count+Stat.read_hit_count);
fprintf('the read_hit_count is %d\n',Stat.read_hit_count);
fprintf('the read_hit_rate is %10.8f\n',read_hit_rate);
% �޳������ͻ�д��������
% fprintf('the evict number is %d\n',evict_count);
fprintf('the write_back_count is %d\n',Stat.write_back_count);
fprintf('the Stat.physical_read_count is %d\n',Stat.physical_read_count);
fprintf('the Stat.physical_write_count is %d\n',Stat.physical_write_count);
%��������ָ���ļ�
% �޳�һЩ����Ҫ���м����ݣ���ʡ����
clear ReqSec;
clear CLRU DLRU;
save(output_filename);