classdef conv2d < ndg_lib.phys.phys2d
    %CONV2D Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        Nfield = 1  % ��������
    end
    
    properties
        ftime   % ������ֹʱ��
        dt      % ����ʱ�䲽��
        u,v     % �ٶȳ�
    end
    
    %% �麯��
    methods(Abstract)
        [ spe ] = character_len(obj, f_Q) % get the time interval dt
    end
    
    %% ˽�к���
    methods(Access=protected) % private 
        [ E, G ] = flux_term( obj, f_Q ) % get the flux terms
        [ dflux ] = surf_term( obj, f_Q ) % get flux deviation
        [ rhs ] = rhs_term(obj, f_Q ) % get the r.h.s term
    end
    
    %% ��������
    methods
        function obj = conv2d(mesh)
            obj = obj@ndg_lib.phys.phys2d(mesh);
        end
        
        f_Q = RK45_solve(obj) % Runge-Kutta 4th order 5 stages
        refine_mesh(obj, multi_ratio) % refined mesh
    end
    
end

