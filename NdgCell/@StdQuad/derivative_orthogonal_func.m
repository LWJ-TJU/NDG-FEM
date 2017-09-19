function [ fdr, fds, fdt ] = derivative_orthogonal_func(obj, N, ind, r, s, t)
%GRADORTHOGONALFUN Summary of this function goes here
%   Detailed explanation goes here

% ת�����Ϊ��i,j����ʽ
[i,j] = trans_ind(N,ind);
% ������������������ֵ

fdr = Polylib.GradJacobiP(r(:), 0, 0, i).*Polylib.JacobiP(s(:), 0, 0, j);
fds = Polylib.JacobiP(r(:), 0, 0, i).*Polylib.GradJacobiP(s(:), 0, 0, j);
fdt = zeros(size(fdr));
end

