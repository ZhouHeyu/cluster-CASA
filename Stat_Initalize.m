function Stat_Initalize()
% 该函数完成对初始统计信息的初始化
% Stat是个统计信息结构体，包含回写信息write_back_count
% 物理读写次数physical_write_count,physical_read_count
% 读写命中次数,write_hit_count,read_hit_count
global Stat;
Stat.physical_write_count=0;
Stat.physical_read_count=0;
Stat.write_back_count=0;
Stat.hit_count=0;
Stat.write_hit_count=0;
Stat.read_hit_count=0;
Stat.write_miss_count=0;
Stat.read_miss_count=0;
Stat.miss_count=0;
Stat.all_page_req_num=0;