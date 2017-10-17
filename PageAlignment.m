function [ReqLPN]=PageAlignment(req_index)
% 该函数完成页对齐,输入的是关于扇区的请求信息结构体，输出转化为LPN的结构体（开始LPN地址，页请求大小，请求类型）
global ReqSec;
SECT_NUM_PER_PAGE=4; %每个页包含多少个扇区
ReqLPN.start=fix(ReqSec.start(req_index)/SECT_NUM_PER_PAGE);
ReqLPN.size=fix((ReqSec.start(req_index)+ReqSec.size(req_index)-1)/SECT_NUM_PER_PAGE)-fix(ReqSec.start(req_index)/SECT_NUM_PER_PAGE)+1;
ReqLPN.type=ReqSec.type(req_index);%当前的读写请求类型