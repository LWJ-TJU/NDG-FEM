classdef limiter_cell
    %LIMITER_CELL ���ڵ�Ԫ�ݶ����Ƶ�б��������
    %   ��Ԫб��������������Χ��Ԫ��ֵ��ÿ����Ԫ���Ա������ݶȽ������ƣ����Ҹ������ƺ�
    %   ���ݶȽ����ع������������ĵ�Ԫֵ��
    
    properties
        phys
        mesh
        cell
    end
    
    methods
        function obj = limiter_cell(mesh, cell)
            obj.mesh = mesh;
            obj.cell = cell;
        end
    end
    
end

