% CASA算法实现
%该算法是将缓冲区分为CLRU（干净页队列）和DLRU(脏页队列)
% 各队列的剔除操作是LRU机制，根据命中队列更改干净页队列目标队列长度τ
%缓冲区满的时候，根据比较CRLU的队列长度和目标长度τ选择剔除的队列。CLRU长度比τ小的时候，选择DLRU剔除。

clc
clear all;
trace_filename='.\test_trace\sys1';%配置输入的trace文件
output_filename='.\result\CASA\trace_sys1_CASA_RW19_buf4000_var.mat';%设置输出的指定文件
[req_arrive,device_num,req_sec_start,req_sec_size,req_type]=textread(trace_filename,'%f%d%d%d%d');
% %读取trace文件中的五个参数（请求到达时间，设备号，请求扇区号起始位置，请求扇区大小，请求操作类型）


%设置缓冲区的大小，这里采取的页大小是2k，缓冲区的大小2M（1024页），10M（5120）
buf_size=4000;
% % 缓冲区存的数为-1表示该位置是空闲的，buf的第二行是存请求的读写位，存的是-1表示未使用
% buf=-ones(2,buf_size);
%输出参量的初始化
miss_count=0;
evict_count=0;
hit_rate=0;
write_hit_count=0;%写请求命中次数
read_hit_count=0;%读请求命中次数
write_miss_count=0;
read_miss_count=0;
write_back_count=0;
hit_count=0;
all_page_req_num=0;%统计所有的页请求次数
physical_read_count=0;
physical_write_count=0;

% CASA算法定义的相关变量
%一开始的目标队列初始化为缓冲区的一半
tau=buf_size/2;
%干净页队列相关参数,第一行存LPN，第二行表示脏页(0)还是干净页(1)，存-1表示均未使用。
CLRU=[-1,-1]';
CLRU_length=1;
%脏页队列相关参数
DLRU=[-1,-1]';
DLRU_length=1;
%关于读写代价Cr，Cw,这里考虑读写延迟比例
Cr_tmp=1;
Cw_tmp=9;
%根据比例归一化，Cr+Cw=1
Cr=Cr_tmp/(Cr_tmp+Cw_tmp);
Cw=Cw_tmp/(Cr_tmp+Cw_tmp);


%对请求扇区序列进行次数统计,有多少行就是有多少次请求
all_req_sec_num=length(req_sec_start);

%关于页对齐的参数
SECT_NUM_PER_PAGE=4; %每个页包含多少个扇区
req_LPN_start=0;%req_LPN_start=req_sec_start/SECT_NUM_PER_PAGE
req_page_size=0;%请求的页大小,req_page_size=(req_sec_start+req_sec_size-1)/SECT_NUM_PER_PAGE-req_sec_start/SECT_NUM_PER_PAGE+1


%开始处理请求，进行循环
for req_index=1:all_req_sec_num
    %request_index表示当前请求在总请求序列中的次序
    %对扇区请求页对齐
    req_LPN_start=fix(req_sec_start(req_index)/SECT_NUM_PER_PAGE);
    req_page_size=fix((req_sec_start(req_index)+req_sec_size(req_index)-1)/SECT_NUM_PER_PAGE)-fix(req_sec_start(req_index)/SECT_NUM_PER_PAGE)+1;
    req_LPN_type=req_type(req_index);%当前的读写请求类型
    all_page_req_num=all_page_req_num+req_page_size;%统计所有的页请求次数
    while(req_page_size>0)
        %先遍历缓冲区，查看是否存在对应的LPN（命中没有）,命中buf_flag=1，没有命中buf_flag=0
        buf_flag=0;
        %遍历CLRU
        for index=1:CLRU_length
%             匹配该请求的LPN和CLRU的中的LPN
           if CLRU(1,index)==req_LPN_start
               %命中CLRU，增加目标队列长度tau
               hit_count=hit_count+1;
               tau_increment=round((DLRU_length/CLRU_length)*Cr);%采用四舍五入取整
               tau=tau+tau_increment;
%                7-22修改，考虑tau的边界溢出,防止DLRU出现极限为空的情况
               if tau>=buf_size
                   tau=buf_size-1;
               end
               %依据命中请求操作，如果读请求，将命中项移到CLRU的MRU位置，否则数据迁移到DLRU的MRU位置
               if req_LPN_type==0
                   %表示为写请求
                   write_hit_count=write_hit_count+1;
                   buf_tmp=[req_LPN_start,0]';
                   %CFLRU迁出数据的时候，代码运行时为防止CFLRU_length为0现bug                   
                   if (CLRU_length==1)
                       if(CLRU_length+DLRU_length<buf_size)
                       %表示此时缓冲区没有满，代码运行会出现CFLRU为1被迁移数据的极端情况,则预留一个数据页大小给CLRU队列
                           CLRU=[-1,-1]';
                           CLRU_length=1;
                       else
                       %缓冲区满了，则剔除DLRU尾部的位置，为CLRU预留一个空位置
                           DLRU_length=DLRU_length-1;
                           DLRU=DLRU(:,1:end-1);
                           %记录一次剔除操作和回写操作
                           write_back_count=write_hit_count+1;
                           physical_write_count=physical_write_count+1;
                           evict_count=evict_count+1;
                           CLRU=[-1,-1]';
                           CLRU_length=1;
                       end
                   else
                       %从CLRU队列中剔除该数据项，长度减1
                       CLRU=[CLRU(:,1:index-1),CLRU(:,index+1:end)];
%                       记录一次剔除操作
                       evict_count=evict_count+1;
                       CLRU_length=CLRU_length-1;
                   end
                   %将该数据项移动到DLRU的MRU位置,DLRU的长度加1
                   DLRU=[buf_tmp,DLRU(:,1:end)];
                   DLRU_length=DLRU_length+1;                   
               else%表示为读请求处理
                   read_hit_count=read_hit_count+1;
%                  简单地将命中项移动到CLRU位置的MRU位置
                   CLRU=[CLRU(:,index),CLRU(:,1:index-1),CLRU(:,index+1:end)];
               end
               buf_flag=1;
               break;
           end
%          遍历CLRU结束
        end
        %开始遍历DLRU
        if buf_flag==0
            %前面的CLRU没有找到对应的LPN
            for index=1:DLRU_length
                if DLRU(1,index)==req_LPN_start
%                     命中DLRU
%                  命中次数加1
                   hit_count=hit_count+1;
%                    命中DLRU，表示当前以写操作为主，需要减τ的值
                   tau_decrease=round((CLRU_length/DLRU_length)*Cw);
                   tau=tau-tau_decrease;
%                  7-22加入的修改,防止出现干净页队列出现为空的极端情况
                   if tau<=0
                       tau=1;
                   end
%                  根据命中的请求类型操作这里不需要将DLRU的数据移动到CLRU上
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
        end%遍历DLRU结束 
%      根据上述的buf_flag判断是否命中缓冲区,=0,没有命中缓冲区
        if buf_flag==0
            miss_count=miss_count+1;
%           miss一次请求就要一次物理读操作
            physical_read_count=physical_read_count+1;
            buf_tmp=[req_LPN_start,req_LPN_type]';
%           区分两种一种缓冲区满的操作和缓冲区没有满
            if(CLRU_length+DLRU_length<buf_size)
%             缓冲区没有满
%             依据请求类型处理不同的操作
              if req_LPN_type==0
                  write_miss_count=write_miss_count+1;
%              将数据加载到DLRU的MRU位置
                   DLRU=[buf_tmp,DLRU(:,1:end)];
                   DLRU_length=DLRU_length+1;
              else
                  read_miss_count=read_miss_count+1;
%              将数据加载到CLRU的MRU位置                  
                   CLRU=[buf_tmp,CLRU(:,1:end)];
                   CLRU_length=CLRU_length+1;
              end
            else
%             缓冲区满了，根据比较目标队列τ，选择剔除队列
                evict_count=evict_count+1;
%              这里考虑会不会出现缓冲区为全是DLRU的极端情况处理？
                if CLRU_length<tau
%                选择脏页队列剔除
                  DLRU=DLRU(:,1:end-1);
                  DLRU_length=DLRU_length-1;
                  write_back_count=write_back_count+1;
                  physical_write_count=physical_write_count+1;
                else
%               选择干净页队列剔除
                  CLRU=CLRU(:,1:end-1);
                  CLRU_length=CLRU_length-1;
                end
%              剔除完毕加载数据 ，依据请求类型处理不同的操作
                  if req_LPN_type==0
                      write_miss_count=write_miss_count+1;
%                     将数据加载到DLRU的MRU位置
                       DLRU=[buf_tmp,DLRU(:,1:end)];
                       DLRU_length=DLRU_length+1;
                  else
                      read_miss_count=read_miss_count+1;
%                     将数据加载到CLRU的MRU位置                  
                       CLRU=[buf_tmp,CLRU(:,1:end)];
                       CLRU_length=CLRU_length+1;
                  end
%                数据加入缓冲区完毕
            end
%           缓冲区区分操作完成
        end
%       未命中缓冲区操作完成
        req_page_size=req_page_size-1;%请求页完成一次，大小减一
        req_LPN_start=req_LPN_start+1;
    end%一个req请求处理完成（while-end）    
end%总的req—for-end
% 数据处理部分
%计算命中率
hit_rate=double((all_page_req_num-miss_count))/all_page_req_num;
%计算写命中率
write_hit_rate=double(write_hit_count)/(write_hit_count+write_miss_count);
%计算读命中率
read_hit_rate=double(read_hit_count)/(read_hit_count+read_miss_count);
%输出参数
fprintf('the all_page_req_num is %d\n',all_page_req_num);
fprintf('the hit rate is %10.8f\n',hit_rate);
fprintf('the  all_write_count is %d\n', write_miss_count+write_hit_count);
fprintf('the  write_hit_count is %d\n', write_hit_count);
fprintf('the write_hit_rate is %10.8f\n',write_hit_rate);
fprintf('the  all_read_count is %d\n', read_miss_count+read_hit_count);
fprintf('the read_hit_count is %d\n',read_hit_count);
fprintf('the read_hit_rate is %10.8f\n',read_hit_rate);
% 剔除操作和回写操作次数
fprintf('the evict number is %d\n',evict_count);
fprintf('the write_back_count is %d\n',write_back_count);
%保存结果到指定文件
% 剔除一些不必要的中间数据，节省保存
clear req_arrive device_num req_sec_start req_sec_size req_type ;
clear CLRU DLRU buf_tmp index ;
save(output_filename);
