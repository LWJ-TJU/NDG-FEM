classdef point < ndg_lib.std_cell.std_cell
    %STD_POINT Summary of this class goes here
    %   Detailed explanation goes here
    %% ȫ������
    properties
        N   % ����������
    end
    
    % ��������
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
    
    % �������
    properties(SetAccess = private)
        Np      % �ڵ����
        r, s, t
        V
        M
        Dr, Ds, Dt
    end
    % ������
    properties(SetAccess = private)
        Fmask
        Nfp
        Nfptotal
        LIFT
    end
    
    methods(Access=protected)
        function [r,s,t] = node_coor_func(obj, N)
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
            obj.N = N;
            % volume
            obj.Np = 1;
            [obj.r, obj.s, obj.t] = obj.node_coor_func(N);
            obj.V = obj.Vandmode_Matrix(@obj.orthogonal_func);
            obj.M = obj.Mass_Matrix;
            [obj.Dr, obj.Ds, obj.Dt] = obj.Derivative_Matrix...
                (@obj.derivative_orthogonal_func);
            % face
            obj.Nfp = 1;
            obj.Nfptotal = sum(obj.Nfp);
            obj.Fmask = obj.Face_node;
            obj.LIFT = obj.Lift_Matrix;
        end
        
        function node_val = project_vert2node(obj, vert_val)
            node_val = vert_val;
        end
        
    end
    
end

