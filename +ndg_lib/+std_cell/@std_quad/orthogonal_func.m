function [ fval ] = orthogonal_func(obj, N, ind, r, s, t)
%ORTHOGONALFUN �����ı����������������ڽڵ㴦����ֵ
%   �ı���������������ͨ��һά��������չ������

% ת�����Ϊ��i,j����ʽ
[i,j] = TransInd(N,ind);
% ������������������ֵ
fval = Polylib.JacobiP(r(:), 0, 0, i).*Polylib.JacobiP(s(:), 0, 0, j);

end

