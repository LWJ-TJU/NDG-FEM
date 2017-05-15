classdef point < ndg_lib.std_cell.std_cell
    %STD_POINT Summary of this class goes here
    %   Detailed explanation goes here
    %% ��������
    properties(Constant)
        type = ndg_lib.std_cell_type.Point % ��Ԫ����
        Nv = 1      % ��Ԫ�������
        vol = 0
        vr = 0      % ����x���꣬������
        vs = 0      % ����y���꣬������
        vt = 0      % ����z���꣬������
        Nfv = 1     % ÿ�����϶������
        FToV = 1    % ÿ�����Ӧ�Ķ����ţ�������
        Nface = 0
        faceType = ndg_lib.std_cell_type.Point
    end
    
    methods(Access=protected)
        function [Np,r,s,t] = node_coor_func(obj, N)
            Np = 1;
            r = 0;
            s = 0;
            t = 0;
        end
        
        function fun = orthogonal_func(obj, N, ind, r, s, t)
            fun = 1;
        end
        
        function [dr, ds, dt] = derivative_orthogonal_func(obj, N, ind, r, s, t)
            dr = 0;
            ds = 0;
            dt = 0;
        end
    end
    
    methods
        function obj = point(N)
            obj = obj@ndg_lib.std_cell.std_cell(N);
        end
        
        function node_val = project_vert2node(obj, vert_val)
            node_val = vert_val;
        end
        
    end
    
end

