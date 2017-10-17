function [tau]=UpdateTau(tau,flag)
% flag=CLRU|DLRU=CLRU*10+DLRU
%关于读写代价Cr，Cw,这里考虑读写延迟比例
global DLRU;
global CLRU;
global buf_size;
CLRU_length=CLRU.LPN_list_size;
DLRU_length=DLRU.LPN_size;
Cr_tmp=1;
Cw_tmp=9;
%根据比例归一化，Cr+Cw=1
Cr=Cr_tmp/(Cr_tmp+Cw_tmp);
Cw=Cw_tmp/(Cr_tmp+Cw_tmp);

% 考虑CLRU和DLRU全没命中，则不剔除
if flag==0;
    return;
end

if flag==10
%     命中CLRU，增加tau的值
      tau_increment=round((DLRU_length/CLRU_length)*Cr);%采用四舍五入取整
      tau=tau+tau_increment;
% 考虑tau的边界溢出,防止DLRU出现极限为空的情况
       if tau>=buf_size
           tau=buf_size-1;
       end
else  %flag=1表示命中DLRU
%     命中DLRU，减小tau的值
%     命中DLRU，表示当前以写操作为主，需要减τ的值
       tau_decrease=round((CLRU_length/DLRU_length)*Cw);
       tau=tau-tau_decrease;
% 加入的修改,防止出现干净页队列出现为空的极端情况
       if tau<=0
           tau=1;
       end
end