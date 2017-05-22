classdef swe2d < ndg_lib.phys.phys2d
    %@SWE2D Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        Nfield = 3
        gra = 9.81
        hmin = 1e-4
    end
    
    properties(Abstract, SetAccess=protected)
        bot     % ���¸߳�
        cfl     % CFL ��
        ftime   % ������ֹʱ��
        dt      % ����ʱ�䲽��
        wetflag % ʪ��Ԫ�߼�����
        slopelimiter % б��������
    end
    properties
        m   % Manning ����
    end
    
    methods(Abstract)
        [h, qx, qy] = init(obj, x, y)
        [hP, qxP, qyP] = adj_node_val(obj, ... 
            hM, qxM, qyM, ...
            hP, qxP, qyP, ...
            nx, ny, ftype) % adjacent node value of each edges
    end
    
    methods
        rhs = swe_rhs(obj, h, qx, qy, time) % calculate r.h.s.
        [E,G] = swe_node_flux(obj, h, qx, qy) % get flux terms
        flux = swe_num_flux(obj, h, qx, qy) % get numerical flux on edges
    end
    
end

