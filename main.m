% 主函数逻辑
clc
clear all
% 输入测试文件和输出的结果文件
trace_filename='.\test_trace\syn4';%配置输入的trace文件
output_filename='.\result\CASA_cluster\trace_syn4_cluster_CASA_RW19_buf1000_var.mat';%设置输出的指定文件
global ReqSec;
[ReqSec.arrive,ReqSec.device_num,ReqSec.start,ReqSec.size,ReqSec.type]=textread(trace_filename,'%f%d%d%d%d');
% %读取trace文件中的五个参数（请求到达时间，设备号，请求扇区号起始位置，请求扇区大小，请求操作类型）

% 关键的全局变量定义
global LPNInfo;
global Stat;
global CLRU;
global DLRU;
global buf_size;
buf_size=1000;
% tau是目标干净页CLRU队列的长度
tau=buf_size/2;
DLRU_Initalize();
CLRU_Initialize();
Stat_Initalize();

%对请求扇区序列进行次数统计,有多少行就是有多少次请求
all_req_sec_num=length(ReqSec.start);
%开始处理请求，进行循环
for req_index=1:all_req_sec_num
    %request_index表示当前请求在总请求序列中的次序
    %对扇区请求页对齐
    [ReqLPN]=PageAlignment(req_index);
    Stat.all_page_req_num=Stat.all_page_req_num+ReqLPN.size;%统计所有的页请求次数
    while(ReqLPN.size>0)
        % 针对一个LPN，先遍历缓冲区，查看是否存在LPN
        % IsLPNInCLRU,查看返回的LPNIfno信息，
        InCLRU=0;
        InDLRU=0;
        LPNInfo_Initialize();
        IsLPNInCLRU(ReqLPN.start);
        if LPNInfo.LPN_index~=0
            InCLRU=1;
            Stat.hit_count=Stat.hit_count+1;
    %       同时判断CLRU命中的操作类型，读命中操作和写命中操作
    %       调用函数HitCLRU(LPN_index,LPN,req_type)
            HitCLRU(LPNInfo.LPN_index,ReqLPN.type);
        end    
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         
    %   如果CLRU中不存在该LPN，则接着遍历DLRU
        if InCLRU==0
            IsLPNInDLRU(ReqLPN.start);
        end
    %   如果存在DLRU中
        if (LPNInfo.LPN_index~=0&&InCLRU==0)
            InDLRU=1;
            Stat.hit_count=Stat.hit_count+1;
    %       同时判断DLRU命中的操作类型，读命中操作和写命中操作
    %       调用函数HitDLRU(LPNInfo,LPN,ReqLPN.type)  
            HitDLRU(LPNInfo,ReqLPN.type,ReqLPN.start);
        end
    %   flag1表示命中DLRU，等于10表示命中CLRU，0表示没有没有命中缓冲区
        flag=InCLRU*10+InDLRU;
        [tau]=UpdateTau2(tau,flag);
        InBuf=InCLRU+InDLRU;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         
    %   如果没有命中缓冲区
        if InBuf==0
            Stat.miss_count=Stat.miss_count+1;
    %       判断缓冲区有没有满
            if DLRU.LPN_size+CLRU.LPN_list_size>=buf_size;
    %          如果缓冲区满了，则考虑剔除策略
               if CLRU.LPN_list_size<tau
    %               考虑剔除DLRU
                    DelLPNInDLRU();
               else
    %              考虑剔除CLRU
                   DelLPNInCLRU();
               end
            end
    %       缓冲区满剔除操作完成，或者缓冲区没有满，加入buf中
            if ReqLPN.type~=0
    %             读请求加载到CLRU
                  Stat.read_miss_count=Stat.read_miss_count+1;
                  AddLPNtoCLRU(ReqLPN.start);
                  Stat.physical_read_count=Stat.physical_read_count+1;
            else
                Stat.write_miss_count=Stat.write_miss_count+1;
    %             写请求加载到DLRU
                AddLPNtoDLRU(ReqLPN.start);
                Stat.physical_read_count=Stat.physical_read_count+1;
            end
        end%-------   如果没有命中缓冲区
        ReqLPN.size=ReqLPN.size-1;%请求页完成一次，大小减一
        ReqLPN.start=ReqLPN.start+1;
    end
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% 数据处理部分
%计算命中率
hit_rate=double((Stat.all_page_req_num-Stat.miss_count))/Stat.all_page_req_num;
%计算写命中率
write_hit_rate=double(Stat.write_hit_count)/(Stat.write_hit_count+Stat.write_miss_count);
%计算读命中率
read_hit_rate=double(Stat.read_hit_count)/(Stat.read_hit_count+Stat.read_miss_count);

%输出参数
fprintf('the all_page_req_num is %d\n',Stat.all_page_req_num);
fprintf('the hit rate is %10.8f\n',hit_rate);
fprintf('the  all_write_count is %d\n', Stat.write_miss_count+Stat.write_hit_count);
fprintf('the  write_hit_count is %d\n', Stat.write_hit_count);
fprintf('the write_hit_rate is %10.8f\n',write_hit_rate);
fprintf('the  all_read_count is %d\n', Stat.read_miss_count+Stat.read_hit_count);
fprintf('the read_hit_count is %d\n',Stat.read_hit_count);
fprintf('the read_hit_rate is %10.8f\n',read_hit_rate);
% 剔除操作和回写操作次数
% fprintf('the evict number is %d\n',evict_count);
fprintf('the write_back_count is %d\n',Stat.write_back_count);
fprintf('the Stat.physical_read_count is %d\n',Stat.physical_read_count);
fprintf('the Stat.physical_write_count is %d\n',Stat.physical_write_count);
%保存结果到指定文件
% 剔除一些不必要的中间数据，节省保存
clear ReqSec;
clear CLRU DLRU;
save(output_filename);