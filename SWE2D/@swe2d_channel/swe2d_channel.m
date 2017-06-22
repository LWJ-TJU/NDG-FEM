classdef swe2d_channel < swe2d
    %SWE2D_CHANNEL ģ�⳱���ں�����������
    %   ���Բ�ͬ�Ŀ��߽��������ֱ�Ϊ��
    %       1. ����0�ݶȣ�����ˮλָ���߽�������δ�����ⲿֵ�ı�����Ϊ0�ݶȱ߽���������
    %       2. ����0�ݶȣ����� clamped �߽�������
    %       3. ����ָ������������ɻ��ƹ̱ڣ�
    
    properties(Constant)
        hmin = 1e-2
    end
    
    properties(Hidden)
        EToB; % �߽���ţ�0-�ڲ���1-�ϲ��뱱�ࡢ2-���ࡢ3-���ࣻ
        obc_vert; % ���߽綥�����
    end
    
    properties
        casename;
        T = 360; % ���� 6 min
        H = 40; % ����ˮ��
        eta = 0.2; % �������
        obc_time_interval = 12; % ���߽�����Ƶ�� (s)
    end
    
    methods
        draw(obj, f_Q);
        set_west_wave_depth_obc1(obj, casename);
        set_west_wave_all_obc2(obj, casename);
        set_west_wave_flow_east_wall_obc3(obj, casename)
        set_east_spg_obc4(obj, casename);
        
        function obj = swe2d_channel(N, casename, type)
            [ mesh ] = read_mesh_file(N, casename, type);
            obj = obj@swe2d(mesh);
            obj.casename = casename;
            obj.ftime = 7200;
            obj.set_west_wave_depth_obc1(); % default obc 
        end% func
        
        function init(obj)
            obj.f_Q = zeros(obj.mesh.cell.Np, obj.mesh.K, obj.Nfield);
            obj.f_extQ = zeros(obj.mesh.cell.Np, obj.mesh.K, obj.Nfield);
            obj.bot = zeros(obj.mesh.cell.Np, obj.mesh.K);
        end% func
    end
    
    methods(Access=protected)
        [ rhs ] = rhs_term(obj, f_Q ) % �����Ҷ���
    end
end

