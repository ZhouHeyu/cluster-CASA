function [LVBN,offset]=LPNtoLVBN(LPN,N)
% 该函数依据设置的簇大小N，求解LPN对应的簇号LVBN，及偏移量offset
% matlab中为了避免索引为0的情况，在结果上统一加1
LVBN=fix(LPN/N)+1;
offset=mod(LPN,N)+1;