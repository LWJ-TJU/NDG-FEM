function [ fval ] = orthogonal_func(obj, N, ind, r, s, t)
%ORTHOGONAL_FUNC �����ı����������������ڽڵ㴦����ֵ
%   �ı���������������ͨ��һά��������չ������

% ת�����Ϊ��i,j����ʽ
[ i,j ] = trans_ind(N, ind);
% ������������������ֵ
fval = Polylib.JacobiP(r(:), 0, 0, i).*Polylib.JacobiP(s(:), 0, 0, j);

end

