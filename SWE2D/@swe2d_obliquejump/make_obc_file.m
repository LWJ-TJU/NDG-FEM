function [ obcfile ] = make_obc_file( obj, casename )
%MAKE_OBC_FILE Summary of this function goes here
%   Detailed explanation goes here

% ���ɿ��߽�����
hin = obj.h0;
uin = obj.u0;
qxin = hin*uin;
% ��ȡ�߽�ڵ���
vert = read_edge_file(casename);
Nv = numel(vert); % �������
time = 0; % ���߽�����ʱ��
Nt = numel(time); % ���߽��ļ�ʱ�䲽��
Nfield = 3; % ���߽���������
f_Q = zeros(Nv, Nfield, Nt);
f_Q(:, 1) = hin;
f_Q(:, 2) = qxin;

% ���ɿ��߽��ļ�
obcfile = ndg_lib.phys.obc_file();
obcfile.make_obc_file([casename, '.nc'], time, vert, f_Q);
obcfile.set_file([casename, '.nc']);

end


function vert = read_edge_file(casename)
filename = [casename, '.edge'];
fp = fopen(filename);
% read total number of 
Nf = fscanf(fp, '%d', 1);
fgetl(fp); % pass the rest of first line

% read face to vertex list
data = fscanf(fp, '%d %d %d %d', [4, Nf]);
ind = data([2,3], :);
vert = unique( ind(:) );

fclose(fp);
end% func

