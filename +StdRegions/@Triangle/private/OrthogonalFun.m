function [ fval ] = OrthogonalFun( r,s,order,ind )
%ORTHOGONALFUN ����������
%   �������������������꣨r,s��������ֵ

% ����ͶӰ������
[a,b] = rstoab(r,s);

% ���������ת��Ϊ�����ں�����ţ�i��j��
[i, j] = TransInd(order,ind);
fval = Simplex2DP(a,b,i,j);
end

