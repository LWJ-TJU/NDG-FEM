classdef pbswe1d < ndg_lib.phys.phys1d
    %PBSWE1D һά Pre-Balanced ǳˮ���������
    %   Detailed explanation goes here

    properties(Constant)
        Nfield = 2  % ���� (eta, q)
        hmin = 1e-4
        gra = 9.81
    end
    
    properties(Abstract)
        M   % TVB ������ϵ��
    end

    properties(SetAccess=protected)
        h       % ��Ӧˮ��
        bot     % ���¸߳�
        cfl     % CFL ��
        ftime   % ������ֹʱ��
        dt      % ����ʱ�䲽��
        wetflag % ʪ��Ԫ�߼�����
        slopelimiter % б��������
    end

    %% �麯��
    methods(Abstract)
        init(obj)
    end
    
    %% ˽�к���
    methods(Access=protected)
        [ E ] = flux_term( obj, f_Q ) % �����������ͨ���� F
        [ dflux ] = surf_term( obj, f_Q )
        [ rhs ] = rhs_term(obj, f_Q ) % �����Ҷ���
        [ S ] = topo_sour_term( obj, f_Q ) % ����Դ�� 
        [ f_Q ] = positive_preserve( obj, f_Q )
        
        function wetdry_detector( obj, f_Q )
            obj.h = f_Q(:,:,1) - obj.bot;
            hm = obj.mesh.cell_mean( obj.h ); % ���㵥Ԫƽ��ˮ��
            obj.wetflag = ( hm > obj.hmin );
            % ����ƽ��ˮ��С�ڷ�ֵ�ĵ�Ԫ����Ϊ�ɵ�Ԫ
            obj.mesh.EToR( ~obj.wetflag ) = ndg_lib.mesh_type.Dry;
            obj.mesh.EToR( obj.wetflag ) = ndg_lib.mesh_type.Normal;
        end
        
        function dt = time_interval( obj )
            q = obj.f_Q(:,:,2);
            u = (q./obj.h) + sqrt(obj.gra*obj.h);
            s = bsxfun(@times, obj.mesh.vol/obj.mesh.cell.N, 1./u);
            dt = obj.cfl*min( min( s(:, obj.wetflag) ) );
        end
    end

    %% ��������
    methods
        [ dflux ] = hll_surf_term( obj, f_Q ) % ����߽����ͨ����ֵ (Fn - Fn*)
        [ dflux ] = roe_surf_term( obj, f_Q )
        
        function obj = pbswe1d(mesh)
            obj = obj@ndg_lib.phys.phys1d(mesh);
            obj.slopelimiter = ndg_utility.limiter.TVB(mesh);
        end
    end

end
