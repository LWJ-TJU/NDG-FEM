function [ fval ] = orthogonal_func(obj, N, ind, r, s, t)
%ORTHOGONALFUN ����������
%   �������������������꣨r,s��������ֵ

% ����ͶӰ������
[a,b] = rstoab(r,s);

% ���������ת��Ϊ����������������ţ�i��j��
[i, j] = TransInd(N,ind);
fval = Simplex2DP(a,b,i,j);

end

