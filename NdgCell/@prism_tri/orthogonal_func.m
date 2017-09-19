function [ f ] = orthogonal_func( obj, N, ind, r, s, t )
%ORTHOGONAL_FUNC Get the value of the orthgonal basis
%   Detailed explanation goes here

% transform the index of the orthgonal basis
[ i, j, k ] = trans_ind( N,ind );

% ���������ת��Ϊ����������������ţ�i��j��
[ f_tri ] = tri_orthgonal_func( i, j, r, s );
[ f_lin ] = line_orthgonal_func( k, t );
f = f_tri .* f_lin;
end
