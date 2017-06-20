classdef phys2d_test < ndg_lib.phys.phys2d
    %PHYS2D_TEST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        Nfield = 1
    end
    
    methods(Access=protected)
        function [ E ] = flux_term( obj, f_Q ) % �����������ͨ���� F
        end
        function [ dflux ] = surf_term( obj, f_Q ) % ����߽����ͨ����ֵ (Fn - Fn*)
        end
        function [ rhs ] = rhs_term(obj, f_Q ) % �����Ҷ���
        end
    end
    
    methods
        function obj = phys2d_test(mesh)
            obj = obj@ndg_lib.phys.phys2d(mesh);
        end
        
        function init(obj)
            obj.f_Q = obj.mesh.x + obj.mesh.y;
        end
    end
    
end

