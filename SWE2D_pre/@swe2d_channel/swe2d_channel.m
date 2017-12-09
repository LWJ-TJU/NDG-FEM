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
    
    properties(SetAccess=private)
        detector
    end
    
    properties
        casename;
        T = 360; % ���� 6 min
        H = 40; % ����ˮ��
        eta = 0.2; % �������
        obc_time_interval = 12; % ���߽�����Ƶ�� (s)
    end
    
    methods(Abstract)
        set_bc(obj) % set boundary condition
    end
    
    methods
        draw(obj, f_Q);
        
        function obj = swe2d_channel(N, casename, type)
            [ mesh ] = read_mesh_file(N, casename, type);
            obj = obj@swe2d(mesh);
            obj.casename = casename;
            obj.ftime = 7200;
            
            % set detector
            xd = [0, 5e3, 10e3, 20e3];
            yd = [0, 0, 0, 0];
            obj.detector = ndg_utility.detector.detector2d(mesh, ...
                xd, yd, obj.T/24, obj.ftime, obj.Nfield);
            
            obj.EToB = get_bc_id(obj); % ��ȡ���߽�����
            obj.obc_vert = get_obc_vert(casename); % ��ȡ���߽綥����
            
            obj.set_bc(); % ���ÿ��߽�����
        end% func
        
        function init(obj)
            obj.f_Q = zeros(obj.mesh.cell.Np, obj.mesh.K, obj.Nfield);
            obj.f_extQ = zeros(obj.mesh.cell.Np, obj.mesh.K, obj.Nfield);
            obj.bot = zeros(obj.mesh.cell.Np, obj.mesh.K);
            % �趨��ʼ����
            w = 2*pi/obj.T;
            c = sqrt(obj.gra*obj.H);
            k = w/c;
            
            h = obj.eta*cos(k.*obj.mesh.x)+obj.H;
            u = obj.eta*sqrt(obj.gra/obj.H)*cos(k.*obj.mesh.x);

            obj.f_Q = zeros(obj.mesh.cell.Np, obj.mesh.K, obj.Nfield);
            obj.f_Q(:, :, 1) = h;
            obj.f_Q(:, :, 2) = h.*u;
        end
    end
    
    methods(Access=protected)
        [ rhs ] = rhs_term(obj, f_Q ) % �����Ҷ���
    end
end

