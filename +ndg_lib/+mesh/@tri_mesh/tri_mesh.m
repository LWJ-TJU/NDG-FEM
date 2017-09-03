classdef tri_mesh < ndg_lib.mesh.mesh2d
    %TRI_MESH triangular mesh object
    %   ��������������ɶ�Ӧ�ı���������󣬹����������ɷ���
    %   1. 'file' ͨ�������ļ����ɡ�
    %       �������Ϊ�ļ�������������׺���������ļ�������Ԫ�ڵ��ļ����ڵ������ļ���
    %       �߽�ڵ��ļ����ļ���ʽ��
    %       'ndg_lib/mesh/mesh2d/private/read_from_file.m'
    %
    %   2. 'variable' ͨ�����������������
    %       ����˳���������������
    %           Nv - ���������
    %           vx��vy��vz - �������ꣻ
    %           K - ��Ԫ������
    %           EToV - ��Ԫ�����ţ�
    %           EToR - ��Ԫ���ͣ�
    %           EToBS - ��Ԫ�߽����ͣ�
    %   3. 'uniform' ���ɾ����������
    %       ���������ξ����������ɳ����������������
    %           xlim��ylim - x��y ���귶Χ��
    %           Mx��My - x �� y ����Ԫ������
    %           facetype - �ײ����ϲ��������Ҳ�߽����ͣ�
    %
    
    methods(Static)
        [Nv, vx, vy, vz, K, EToV, EToR, EToBS] ...
            = uniform_mesh(xlim, ylim, zlim, Mx, My, Mz, facetype)
    end
    
    methods
        function obj = tri_mesh(cell, varargin)
            % check input element
            if( ne(cell.type, ndg_lib.std_cell_type.Tri) )
                error(['Input cell type ', cell.type, 'is not triangle!'])
            end
            
            obj = obj@ndg_lib.mesh.mesh2d(cell, varargin{:});
        end% func
        
        obj = refine(obj, multi_rate); % ��������
    end% methods
    
end