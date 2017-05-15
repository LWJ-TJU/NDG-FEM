classdef swe1d < ndg_lib.phys.phys1d
    %SWE1D Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        Nfield = 2
        hmin = 1e-3
    end
    
    properties
        bot     % ���¸߳�
        cfl     % CFL ��
        ftime   % ������ֹʱ��
        dt      % ����ʱ�䲽��
    end
    
    %% �麯��
    methods(Abstract)
        init(obj)
    end
    
    %% ��������
    methods
        [ dflux ] = hll_surf_term( obj, f_Q )
        [ dflux ] = roe_surf_term( obj, f_Q )
        [ rhs ] = rhs_term( obj, f_Q )
        [ E ] = flux_term( obj, f_Q )
        [ S ] = source_term( obj, f_Q )
    end
    
end

