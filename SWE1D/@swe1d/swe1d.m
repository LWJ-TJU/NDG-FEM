classdef swe1d < ndg_lib.phys.phys1d
    %SWE1D һάǳˮ���������
    %   һά�غ�ǳˮ���̣���ˮ�� h������ q = hu Ϊ�Ա��������̰������������붯������
    %       dh/dt + dq/dx = 0
    %       dq/dt + d(uh^2 + 0.5gh^2)/dx = Sb + Sf
    %   ���� Sb �� Sf �ֱ�Ϊ����Դ����Ħ��Դ����� Sb = -ghdz/dx��Ħ��Դ��
    %   �� Manning ��ʽ�����Թ�ʽ������ʽ��
    %
    properties(Constant)
        Nfield = 2  % ������������
        gra = 9.81  % �������ٶ�
    end
    properties(Abstract, Constant)
        hmin % ��Сˮ�ֵ
    end
    
    properties(Abstract)
        M   % TVB ������ϵ��
    end

    properties(SetAccess=protected)
        bot     % ���¸߳�
        cfl     % CFL ��
        ftime   % ������ֹʱ��
        dt      % ����ʱ�䲽��
        wetflag % ʪ��Ԫ�߼�����
        slopelimiter % б��������
    end

    %% �麯��
    methods(Abstract)
        init(obj) % ��ʼ������
    end
    
    %% ˽�к���
    methods(Access=protected)
        [ E ] = flux_term( obj, f_Q ) % �����������ͨ���� F
        [ dflux ] = surf_term( obj, f_Q )
        [ rhs ] = rhs_term(obj, f_Q ) % �����Ҷ���
        [ S ] = topo_sour_term( obj, f_Q ) % ����Դ�� 
        [ f_Q ] = positive_preserve( obj, f_Q )
        
        function wetdry_detector(obj, f_Q)
            %hm = obj.mesh.cell_mean(f_Q(:,:,1)); % ���㵥Ԫƽ��ˮ��
            obj.wetflag = all(f_Q(:,:,1) > obj.hmin);
            %obj.wetflag = all( f_Q(:,:,1) > obj.hmin );
            % ����ƽ��ˮ��С�ڷ�ֵ�ĵ�Ԫ����Ϊ�ɵ�Ԫ
            obj.mesh.EToR( ~obj.wetflag ) = ndg_lib.mesh_type.Dry;
            obj.mesh.EToR( obj.wetflag ) = ndg_lib.mesh_type.Normal;
        end
        
        function spe = char_len(obj, f_Q)
            % ����ڵ��ſ˱�����ֵ
            h = f_Q(:,:,1);
            q = abs( f_Q(:,:,2) );
            spe = (q./h) + sqrt(obj.gra*h);
            spe(:, ~obj.wetflag) = eps;
        end
    end

    %% ��������
    methods
        [ dflux ] = hll_surf_term( obj, f_Q ) % ����߽����ͨ����ֵ (Fn - Fn*)
        [ dflux ] = roe_surf_term( obj, f_Q )
        
        function obj = swe1d(mesh)
            obj = obj@ndg_lib.phys.phys1d(mesh);
            obj.slopelimiter = ndg_utility.limiter.TVB(mesh);
        end
    end

end
