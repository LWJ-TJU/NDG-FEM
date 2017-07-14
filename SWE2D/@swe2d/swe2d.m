classdef swe2d < ndg_lib.phys.phys2d
    %@SWE2D ��άǳˮ���������
    %   Detailed explanation goes here
    
    properties(Constant)
        Nfield = 3 % �����������ֱ�Ϊ h��qx=hu��qy=hv
        gra = 9.81 % �������ٶ�
    end
    
    properties(Abstract, Constant)
        hmin
    end
    
    properties(SetAccess=protected)
        bot % ���¸߳�
        bx, by % ���¸߳��ݶ�
        ftime % ������ֹʱ��
        dt % ����ʱ�䲽��
        wetflag % ʪ��Ԫ�߼�ֵ
        slopelimiter
    end
    
    methods(Access=protected)
        function spe = character_len(obj, f_Q)
            % ����ʱ�䲽��
            h = f_Q(:,:,1);
            q = sqrt( f_Q(:,:,2).^2 + f_Q(:,:,3).^2 );
            spe = (q./h) + sqrt(obj.gra*h);
            spe(:, ~obj.wetflag) = eps;
        end
        
        function wetdry_detector(obj, f_Q)
            % �жϵ�Ԫ��ʪ״̬
            % ��������ˮ����ڷ�ֵ�ĵ�Ԫ����Ϊʪ��Ԫ
            obj.wetflag = all( f_Q(:,:,1) > obj.hmin );
            obj.mesh.EToR( ~obj.wetflag ) = ndg_lib.mesh_type.Dry;
            obj.mesh.EToR( obj.wetflag ) = ndg_lib.mesh_type.Normal;
        end
        
        function topo_grad_term(obj)
            % ���ڵ��²����ģ�ͣ�Ԥ�ȼ�������ݶȽ��ټ�����
            obj.bx = obj.mesh.rx.*(obj.mesh.cell.Dr*obj.bot) ...
               + obj.mesh.sx.*(obj.mesh.cell.Ds*obj.bot);
            obj.by = obj.mesh.ry.*(obj.mesh.cell.Dr*obj.bot) ...
               + obj.mesh.sy.*(obj.mesh.cell.Ds*obj.bot);
        end
        
        [ rhs ] = rhs_term(obj, f_Q ) % �����Ҷ���
        [ dflux ] = surf_term(obj, f_Q ) % ���㵥Ԫ�߽���ֵͨ��
        [ E,G ] = flux_term(obj, f_Q ) % ����ͨ����
    end
    methods(Abstract)
        [ f_Q ] = init(obj)
    end
    
    methods
        [ sb ] = topo_sour_term( obj, f_Q );
        [ dflux ] = hll_surf_term(obj, f_Q ) % ���� hll ��ֵͨ������
        [ dflux ] = lf_surf_term(obj, f_Q ) % ���� hll ��ֵͨ������
        [hP, qxP, qyP] = adj_node_val(obj, hM, qxM, qyM, hP, qxP, qyP, ...
            nx, ny, ftype) % ��ȡ���ڵ�Ԫ�߽�ֵ
        
        function obj = swe2d(mesh)
            obj = obj@ndg_lib.phys.phys2d(mesh);
            obj.slopelimiter = ndg_utility.limiter.VB.VB_2d(mesh);
        end
    end
    
end

