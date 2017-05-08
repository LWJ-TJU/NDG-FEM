function [dr, ds, dt] = derivative_orthogonal_func( obj, N, ind, r, s, t)
%GRADORTHOGONALFUN ��׼��������������������ֵ

% ����ͶӰ������
[a,b] = rstoab(r,s);

% ���������ת��Ϊ�����ں�����ţ�i��j��
[i, j] = TransInd(N,ind);

% ����ԣ�r,s������ĵ���
[dr, ds] = GradSimplex2DP(a,b,i,j);
dt = zeros(size(dr));
end