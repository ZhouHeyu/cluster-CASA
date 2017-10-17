% CASA�㷨ʵ��
%���㷨�ǽ���������ΪCLRU���ɾ�ҳ���У���DLRU(��ҳ����)
% �����е��޳�������LRU���ƣ��������ж��и��ĸɾ�ҳ����Ŀ����г��Ȧ�
%����������ʱ�򣬸��ݱȽ�CRLU�Ķ��г��Ⱥ�Ŀ�곤�Ȧ�ѡ���޳��Ķ��С�CLRU���ȱȦ�С��ʱ��ѡ��DLRU�޳���

clc
clear all;
trace_filename='.\test_trace\sys1';%���������trace�ļ�
output_filename='.\result\CASA\trace_sys1_CASA_RW19_buf4000_var.mat';%���������ָ���ļ�
[req_arrive,device_num,req_sec_start,req_sec_size,req_type]=textread(trace_filename,'%f%d%d%d%d');
% %��ȡtrace�ļ��е�������������󵽴�ʱ�䣬�豸�ţ�������������ʼλ�ã�����������С������������ͣ�


%���û������Ĵ�С�������ȡ��ҳ��С��2k���������Ĵ�С2M��1024ҳ����10M��5120��
buf_size=4000;
% % �����������Ϊ-1��ʾ��λ���ǿ��еģ�buf�ĵڶ����Ǵ�����Ķ�дλ�������-1��ʾδʹ��
% buf=-ones(2,buf_size);
%��������ĳ�ʼ��
miss_count=0;
evict_count=0;
hit_rate=0;
write_hit_count=0;%д�������д���
read_hit_count=0;%���������д���
write_miss_count=0;
read_miss_count=0;
write_back_count=0;
hit_count=0;
all_page_req_num=0;%ͳ�����е�ҳ�������
physical_read_count=0;
physical_write_count=0;

% CASA�㷨�������ر���
%һ��ʼ��Ŀ����г�ʼ��Ϊ��������һ��
tau=buf_size/2;
%�ɾ�ҳ������ز���,��һ�д�LPN���ڶ��б�ʾ��ҳ(0)���Ǹɾ�ҳ(1)����-1��ʾ��δʹ�á�
CLRU=[-1,-1]';
CLRU_length=1;
%��ҳ������ز���
DLRU=[-1,-1]';
DLRU_length=1;
%���ڶ�д����Cr��Cw,���￼�Ƕ�д�ӳٱ���
Cr_tmp=1;
Cw_tmp=9;
%���ݱ�����һ����Cr+Cw=1
Cr=Cr_tmp/(Cr_tmp+Cw_tmp);
Cw=Cw_tmp/(Cr_tmp+Cw_tmp);


%�������������н��д���ͳ��,�ж����о����ж��ٴ�����
all_req_sec_num=length(req_sec_start);

%����ҳ����Ĳ���
SECT_NUM_PER_PAGE=4; %ÿ��ҳ�������ٸ�����
req_LPN_start=0;%req_LPN_start=req_sec_start/SECT_NUM_PER_PAGE
req_page_size=0;%�����ҳ��С,req_page_size=(req_sec_start+req_sec_size-1)/SECT_NUM_PER_PAGE-req_sec_start/SECT_NUM_PER_PAGE+1


%��ʼ�������󣬽���ѭ��
for req_index=1:all_req_sec_num
    %request_index��ʾ��ǰ�����������������еĴ���
    %����������ҳ����
    req_LPN_start=fix(req_sec_start(req_index)/SECT_NUM_PER_PAGE);
    req_page_size=fix((req_sec_start(req_index)+req_sec_size(req_index)-1)/SECT_NUM_PER_PAGE)-fix(req_sec_start(req_index)/SECT_NUM_PER_PAGE)+1;
    req_LPN_type=req_type(req_index);%��ǰ�Ķ�д��������
    all_page_req_num=all_page_req_num+req_page_size;%ͳ�����е�ҳ�������
    while(req_page_size>0)
        %�ȱ������������鿴�Ƿ���ڶ�Ӧ��LPN������û�У�,����buf_flag=1��û������buf_flag=0
        buf_flag=0;
        %����CLRU
        for index=1:CLRU_length
%             ƥ��������LPN��CLRU���е�LPN
           if CLRU(1,index)==req_LPN_start
               %����CLRU������Ŀ����г���tau
               hit_count=hit_count+1;
               tau_increment=round((DLRU_length/CLRU_length)*Cr);%������������ȡ��
               tau=tau+tau_increment;
%                7-22�޸ģ�����tau�ı߽����,��ֹDLRU���ּ���Ϊ�յ����
               if tau>=buf_size
                   tau=buf_size-1;
               end
               %�������������������������󣬽��������Ƶ�CLRU��MRUλ�ã���������Ǩ�Ƶ�DLRU��MRUλ��
               if req_LPN_type==0
                   %��ʾΪд����
                   write_hit_count=write_hit_count+1;
                   buf_tmp=[req_LPN_start,0]';
                   %CFLRUǨ�����ݵ�ʱ�򣬴�������ʱΪ��ֹCFLRU_lengthΪ0��bug                   
                   if (CLRU_length==1)
                       if(CLRU_length+DLRU_length<buf_size)
                       %��ʾ��ʱ������û�������������л����CFLRUΪ1��Ǩ�����ݵļ������,��Ԥ��һ������ҳ��С��CLRU����
                           CLRU=[-1,-1]';
                           CLRU_length=1;
                       else
                       %���������ˣ����޳�DLRUβ����λ�ã�ΪCLRUԤ��һ����λ��
                           DLRU_length=DLRU_length-1;
                           DLRU=DLRU(:,1:end-1);
                           %��¼һ���޳������ͻ�д����
                           write_back_count=write_hit_count+1;
                           physical_write_count=physical_write_count+1;
                           evict_count=evict_count+1;
                           CLRU=[-1,-1]';
                           CLRU_length=1;
                       end
                   else
                       %��CLRU�������޳�����������ȼ�1
                       CLRU=[CLRU(:,1:index-1),CLRU(:,index+1:end)];
%                       ��¼һ���޳�����
                       evict_count=evict_count+1;
                       CLRU_length=CLRU_length-1;
                   end
                   %�����������ƶ���DLRU��MRUλ��,DLRU�ĳ��ȼ�1
                   DLRU=[buf_tmp,DLRU(:,1:end)];
                   DLRU_length=DLRU_length+1;                   
               else%��ʾΪ��������
                   read_hit_count=read_hit_count+1;
%                  �򵥵ؽ��������ƶ���CLRUλ�õ�MRUλ��
                   CLRU=[CLRU(:,index),CLRU(:,1:index-1),CLRU(:,index+1:end)];
               end
               buf_flag=1;
               break;
           end
%          ����CLRU����
        end
        %��ʼ����DLRU
        if buf_flag==0
            %ǰ���CLRUû���ҵ���Ӧ��LPN
            for index=1:DLRU_length
                if DLRU(1,index)==req_LPN_start
%                     ����DLRU
%                  ���д�����1
                   hit_count=hit_count+1;
%                    ����DLRU����ʾ��ǰ��д����Ϊ������Ҫ���ӵ�ֵ
                   tau_decrease=round((CLRU_length/DLRU_length)*Cw);
                   tau=tau-tau_decrease;
%                  7-22������޸�,��ֹ���ָɾ�ҳ���г���Ϊ�յļ������
                   if tau<=0
                       tau=1;
                   end
%                  �������е��������Ͳ������ﲻ��Ҫ��DLRU�������ƶ���CLRU��
                   if req_LPN_type==0
                       write_hit_count=write_hit_count+1;
                   else
                       read_hit_count=read_hit_count+1;
                   end
                   DLRU=[DLRU(:,index),DLRU(:,1:index-1),DLRU(:,index+1:end)];
                   buf_flag=1;
                   break; 
                end
            end          
        end%����DLRU���� 
%      ����������buf_flag�ж��Ƿ����л�����,=0,û�����л�����
        if buf_flag==0
            miss_count=miss_count+1;
%           missһ�������Ҫһ�����������
            physical_read_count=physical_read_count+1;
            buf_tmp=[req_LPN_start,req_LPN_type]';
%           ��������һ�ֻ��������Ĳ����ͻ�����û����
            if(CLRU_length+DLRU_length<buf_size)
%             ������û����
%             �����������ʹ���ͬ�Ĳ���
              if req_LPN_type==0
                  write_miss_count=write_miss_count+1;
%              �����ݼ��ص�DLRU��MRUλ��
                   DLRU=[buf_tmp,DLRU(:,1:end)];
                   DLRU_length=DLRU_length+1;
              else
                  read_miss_count=read_miss_count+1;
%              �����ݼ��ص�CLRU��MRUλ��                  
                   CLRU=[buf_tmp,CLRU(:,1:end)];
                   CLRU_length=CLRU_length+1;
              end
            else
%             ���������ˣ����ݱȽ�Ŀ����Цӣ�ѡ���޳�����
                evict_count=evict_count+1;
%              ���￼�ǻ᲻����ֻ�����Ϊȫ��DLRU�ļ����������
                if CLRU_length<tau
%                ѡ����ҳ�����޳�
                  DLRU=DLRU(:,1:end-1);
                  DLRU_length=DLRU_length-1;
                  write_back_count=write_back_count+1;
                  physical_write_count=physical_write_count+1;
                else
%               ѡ��ɾ�ҳ�����޳�
                  CLRU=CLRU(:,1:end-1);
                  CLRU_length=CLRU_length-1;
                end
%              �޳���ϼ������� �������������ʹ���ͬ�Ĳ���
                  if req_LPN_type==0
                      write_miss_count=write_miss_count+1;
%                     �����ݼ��ص�DLRU��MRUλ��
                       DLRU=[buf_tmp,DLRU(:,1:end)];
                       DLRU_length=DLRU_length+1;
                  else
                      read_miss_count=read_miss_count+1;
%                     �����ݼ��ص�CLRU��MRUλ��                  
                       CLRU=[buf_tmp,CLRU(:,1:end)];
                       CLRU_length=CLRU_length+1;
                  end
%                ���ݼ��뻺�������
            end
%           ���������ֲ������
        end
%       δ���л������������
        req_page_size=req_page_size-1;%����ҳ���һ�Σ���С��һ
        req_LPN_start=req_LPN_start+1;
    end%һ��req��������ɣ�while-end��    
end%�ܵ�req��for-end
% ���ݴ�����
%����������
hit_rate=double((all_page_req_num-miss_count))/all_page_req_num;
%����д������
write_hit_rate=double(write_hit_count)/(write_hit_count+write_miss_count);
%�����������
read_hit_rate=double(read_hit_count)/(read_hit_count+read_miss_count);
%�������
fprintf('the all_page_req_num is %d\n',all_page_req_num);
fprintf('the hit rate is %10.8f\n',hit_rate);
fprintf('the  all_write_count is %d\n', write_miss_count+write_hit_count);
fprintf('the  write_hit_count is %d\n', write_hit_count);
fprintf('the write_hit_rate is %10.8f\n',write_hit_rate);
fprintf('the  all_read_count is %d\n', read_miss_count+read_hit_count);
fprintf('the read_hit_count is %d\n',read_hit_count);
fprintf('the read_hit_rate is %10.8f\n',read_hit_rate);
% �޳������ͻ�д��������
fprintf('the evict number is %d\n',evict_count);
fprintf('the write_back_count is %d\n',write_back_count);
%��������ָ���ļ�
% �޳�һЩ����Ҫ���м����ݣ���ʡ����
clear req_arrive device_num req_sec_start req_sec_size req_type ;
clear CLRU DLRU buf_tmp index ;
save(output_filename);
