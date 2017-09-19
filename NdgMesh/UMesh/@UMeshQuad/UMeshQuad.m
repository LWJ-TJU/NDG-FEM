classdef UMeshQuad < UMeshUnion2d
    %QUAD_MESH �ı���������
    %   ��������������ɶ�Ӧ�ı���������󣬹����������ɷ���
    %   1. 'file' ͨ�������ļ����ɡ�
    %       �������Ϊ�ļ�������������׺���������ļ�������Ԫ�ڵ��ļ����ڵ������ļ���
    %       �߽�ڵ��ļ����ļ���ʽ��
    %       'ndg_lib/mesh/mesh2d/private/read_from_file.m'
    %       
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
    %       �����ı��ξ����������ɳ����������������
    %           xlim��ylim - x��y ���귶Χ��
    %           Mx��My - x �� y ����Ԫ������
    %           facetype - �ײ����ϲ��������Ҳ�߽����ͣ�
    %
    
    methods(Static)
        [Nv, vx, vy, vz, K, EToV, EToR, EToBS] ...
            = uniform_mesh(xlim, ylim, zlim, Mx, My, Mz, facetype)
    end
    
    methods
        function obj = UMeshQuad(cell, varargin)
            % check input element
            if( ne(cell.type, ndg_lib.std_cell_type.Quad) )
                error(['Input cell type ', cell.type, ...
                    'is not quadrilateral!'])
            end
            
            obj = obj@UMeshUnion2d(cell, varargin{:});
                        
        end% func
        
        obj = refine(obj, multi_rate); % ��������
    end% methods
    
end

