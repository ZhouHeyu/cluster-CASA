function Stat_Initalize()
% �ú�����ɶԳ�ʼͳ����Ϣ�ĳ�ʼ��
% Stat�Ǹ�ͳ����Ϣ�ṹ�壬������д��Ϣwrite_back_count
% �����д����physical_write_count,physical_read_count
% ��д���д���,write_hit_count,read_hit_count
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