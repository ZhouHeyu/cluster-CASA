function [LVBN,offset]=LPNtoLVBN(LPN,N)
% �ú����������õĴش�СN�����LPN��Ӧ�Ĵغ�LVBN����ƫ����offset
% matlab��Ϊ�˱�������Ϊ0��������ڽ����ͳһ��1
LVBN=fix(LPN/N)+1;
offset=mod(LPN,N)+1;