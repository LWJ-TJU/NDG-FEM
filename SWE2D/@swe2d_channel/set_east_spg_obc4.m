function set_east_spg_obc4( obj )
%SET_EAST_SPG_OBC4 Summary of this function goes here
%   Detailed explanation goes here

casename = 'SWE2D/@swe2d_channel/mesh/quad_sponge';
[ obj.mesh ] = read_mesh_file(obj.mesh.cell.N, casename, ...
    ndg_lib.std_cell_type.Quad);
obj.EToB = get_bc_id(obj); % ��ȡ���߽�����
obj.obc_vert = get_obc_vert(casename); % ��ȡ���߽綥����
% �趨���߽����� EToBS
westid = (obj.EToB == 2);
obj.mesh.EToBS(westid) = ndg_lib.bc_type.Clamped; % ����߽�����
eastid = (obj.EToB == 3);
obj.mesh.EToBS(eastid) = ndg_lib.bc_type.ZeroGrad; % ����߽�����
% �������������
obj.mesh = ndg_lib.mesh.mesh2d(obj.mesh.cell, ...
    obj.mesh.Nv, obj.mesh.vx, obj.mesh.vy, ...
    obj.mesh.K, obj.mesh.EToV, obj.mesh.EToR, obj.mesh.EToBS);

obj.init(); % ������ʼ��

% ��Ӻ����
obj.mesh = obj.mesh.add_sponge(obj.obc_vert);

% �趨�߽���Ϣ
Nt = ceil(obj.ftime/obj.obc_time_interval);
Nfield = 3; % ���߽���������
spg_vert = unique(  ... % ������ڽڵ�
    obj.mesh.EToV(:, obj.mesh.EToR == ndg_lib.mesh_type.Sponge) ); 
vert = unique([spg_vert; obj.obc_vert]); % ȫ���߽�ڵ�
Nv = numel(vert); % �������
vx = obj.mesh.vx(vert);
time = linspace(0, obj.ftime, Nt); % ���߽�����ʱ��
f_Q = zeros(Nv, Nfield, Nt);

% ���߽�����
w = 2*pi/obj.T;
c = sqrt(obj.gra*obj.H);
k = w/c;
for t = 1:Nt
    tloc = time(t);
    temp = cos(k.*vx - w*tloc);
    h = obj.eta*temp + obj.H;
    u = obj.eta*sqrt(obj.gra/obj.H)*temp;
    f_Q(:, 1, t) = h;
%     f_Q(:, 1, t) = 0;
    f_Q(:, 2, t) = h.*u;
end

% ���ɿ��߽��ļ�
obj.obc_file = ndg_lib.phys.obc_file();
obj.obc_file.make_obc_file([casename, '.nc'], time, ...
    vert, f_Q);
obj.obc_file.set_file([casename, '.nc']);

% �趨��ʼ����
h = obj.eta*cos(k.*obj.mesh.x)+obj.H;
u = obj.eta*sqrt(obj.gra/obj.H)*cos(k.*obj.mesh.x);

obj.f_Q = zeros(obj.mesh.cell.Np, obj.mesh.K, obj.Nfield);
obj.f_Q(:, :, 1) = h;
obj.f_Q(:, :, 2) = h.*u;
% obj.f_Q(:, :, 2) = obj.eta*sqrt(obj.gra/obj.H);
end

