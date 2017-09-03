function [ obcfile ] = make_obc_file( obj, casename )
%MAKE_OBC_FILE Summary of this function goes here
%   Detailed explanation goes here

% ��ȡ�߽�ڵ���
vert = read_edge_file(casename); Nv = numel(vert); % �������
% ��ȡ���߽�ˮλ
obcfile = 'SWE2D/@swe2d_tsuami/mesh/Benchmark_2_input.txt';
[ time, eta ] = read_input(obcfile);
Nt = numel(time); % ���߽��ļ�ʱ�䲽��
Nfield = 3; % ���߽���������
f_Q = zeros(Nv, Nfield, Nt); % ���߽����ݳ�ʼ��
for t = 1:Nt
    f_Q(:,1,t) = eta(t);
end% for

% ���ɿ��߽��ļ�
obcfile = ndg_lib.phys.obc_file();
obcfile.make_obc_file([casename, '.nc'], time, vert, f_Q);
obcfile.set_file([casename, '.nc']);

end

function [ time, h ] = read_input(obcfile)
fp = fopen(obcfile);
fgetl(fp); % pass the rest of first line
data = fscanf(fp, '%f %f', [2, inf]);
fclose(fp);

time = data(1, :);
h = data(2, :);
end

function vert = read_edge_file(casename)
filename = [casename, '.edge'];
fp = fopen(filename);
% read total number of 
Nf = fscanf(fp, '%d', 1);
fgetl(fp); % pass the rest of first line

% read face to vertex list
data = fscanf(fp, '%d %d %d %d', [4, Nf]);
fclose(fp);

openbc = (data(4, :) == 6);
ind = data([2,3], openbc);
vert = unique( ind(:) );

end% func

