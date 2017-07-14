classdef conv2d < ndg_lib.phys.phys2d
    %CONV2D ��ά�������������
    %   ��ά���������������
    
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
        function obj = conv2d(varargin)
            switch varargin{1}
                case 'file' % ��ȡ�ļ�
                    var2 = varargin{2};
                    
                    N = var2{1};
                    cell_type = var2{2};
                    casename = var2{3};
                    [ mesh ] = read_mesh_file(N, cell_type, casename);
                case 'mesh'
                    var2 = varargin{2};
                    mesh = var2{1};
                case 'uniform'
                    var2 = varargin{2};
                    
                    N = var2{1};
                    cell_type = var2{2};
                    xlim = var2{3};
                    ylim = var2{4};
                    Mx = var2{5};
                    My = var2{6};
                    bc_type = var2{7};
                    [ mesh ] = uniform_mesh(N, cell_type, ...
                        xlim, ylim, Mx, My, bc_type);
            end
            
            obj = obj@ndg_lib.phys.phys2d(mesh);
        end
        
        f_Q = RK45_solve(obj) % Runge-Kutta 4th order 5 stages
        refine_mesh(obj, multi_ratio) % refined mesh
    end
    
end

