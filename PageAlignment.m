function [ReqLPN]=PageAlignment(req_index)
% �ú������ҳ����,������ǹ���������������Ϣ�ṹ�壬���ת��ΪLPN�Ľṹ�壨��ʼLPN��ַ��ҳ�����С���������ͣ�
global ReqSec;
SECT_NUM_PER_PAGE=4; %ÿ��ҳ�������ٸ�����
ReqLPN.start=fix(ReqSec.start(req_index)/SECT_NUM_PER_PAGE);
ReqLPN.size=fix((ReqSec.start(req_index)+ReqSec.size(req_index)-1)/SECT_NUM_PER_PAGE)-fix(ReqSec.start(req_index)/SECT_NUM_PER_PAGE)+1;
ReqLPN.type=ReqSec.type(req_index);%��ǰ�Ķ�д��������