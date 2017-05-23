classdef limiter_vert
    %LIMITER_VERT ���ڽڵ�ֵ��б����������
    %   Detailed explanation goes here
    
    properties
        mesh % �������
        cell % ��Ԫ����
        Kv  % ÿ���������ڵ�Ԫ����
        VToE % ÿ���������ڵ�Ԫ���
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

