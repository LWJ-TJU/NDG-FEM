classdef limiter_vert
    %LIMITER_VERT The vertex-based limiter
    %   Detailed explanation goes here
    
    properties
        mesh % mesh object
        cell % cell object
        Kv  % number of elements for each vertex belongs to
        VToE % index of elements contain each vertex
    end
    
    methods(Hidden)
        function [Kv, VToE] =  vertex_connect(obj)
            % ͳ�ƶ����뵥Ԫ���ӹ�ϵ
            Kv = zeros(obj.mesh.Nv, 1);
            for k = 1:obj.mesh.K
                v = obj.mesh.EToV(:, k);
                Kv(v) = Kv(v) + 1;
            end
            maxNe = max(Kv); % ���ж�������൥Ԫ��
            VToE = zeros(maxNe, obj.mesh.Nv);
            Kv = zeros(obj.mesh.Nv, 1);
            for k = 1:obj.mesh.K
                v = obj.mesh.EToV(:, k);
                ind = Kv(v)+1 + (v-1)*maxNe;
                VToE(ind) = k;
                Kv(v) = Kv(v) + 1;
            end
        end
    end
    
    methods
        function obj = limiter_vert(mesh, cell)
            obj.mesh = mesh;
            obj.cell = cell;
            [obj.Kv, obj.VToE] = obj.vertex_connect();
        end
    end
    
end

