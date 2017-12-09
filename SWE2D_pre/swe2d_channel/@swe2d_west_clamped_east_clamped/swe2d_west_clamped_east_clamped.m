classdef swe2d_west_clamped_east_clamped < swe2d_channel
    %SWE2D_WEST_CLAMPED_EAST_CLAMPED Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = swe2d_west_clamped_east_clamped(N)
            casename = 'SWE2D/@swe2d_channel/mesh/quad';
            type = ndg_lib.std_cell_type.Quad;
            obj = obj@swe2d_channel(N, casename, type);
        end
        
        function set_bc(obj)            
            % �趨���߽����� EToBS
            EToBS = obj.mesh.EToBS;
            westid = (obj.EToB == 2); 
            EToBS(westid) = ndg_lib.bc_type.Clamped; % ����߽�����
            eastid = (obj.EToB == 3);
            EToBS(eastid) = ndg_lib.bc_type.Clamped; % ����߽�����
            % �������������
            obj.mesh = ndg_lib.mesh.mesh2d(obj.mesh.cell, ...
                obj.mesh.Nv, obj.mesh.vx, obj.mesh.vy, ...
                obj.mesh.K, obj.mesh.EToV, obj.mesh.EToR, EToBS);

            % �趨�߽���Ϣ
            Nv = numel(obj.obc_vert); % �������
            Nt = ceil(obj.ftime/obj.obc_time_interval);
            Nfield = 3; % ���߽���������
            vx = obj.mesh.vx(obj.obc_vert);
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
                f_Q(:, 2, t) = h.*u;
            end

            % ���ɿ��߽��ļ�
            obj.obc_file = ndg_lib.phys.obc_file();
            obj.obc_file.make_obc_file([obj.casename, '.nc'], ...
                time, obj.obc_vert, f_Q);
            obj.obc_file.set_file([obj.casename, '.nc']);

            % ���ó�ʼ����s
            obj.init();
        end
    end
    
end

