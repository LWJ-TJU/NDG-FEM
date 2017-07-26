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
            switch varargin{1}
                case 'file'
                    [Nv, vx, vy, K, EToV, EToR, EToBS] ...
                        = read_from_file( varargin{2} );
                case 'variable'
                    var = varargin{2};
                    Nv = var{1};
                    vx = var{2}; 
                    vy = var{3}; 
                    K  = var{4}; 
                    EToV = var{5};
                    EToR = int8(var{6}); 
                    EToBS = int8(var{7});
                case 'uniform'
                    var = varargin{2};
                    xlim = var{1};
                    ylim = var{2};
                    Mx = var{3};
                    My = var{4};
                    facetype = var{5};
                    [Nv, vx, vy, K, EToV, EToR, EToBS] ...
                        = uniform_mesh(xlim, ylim, Mx, My, facetype);
            end
            obj = obj@ndg_lib.mesh.mesh2d(cell, ...
                Nv, vx, vy, K, EToV, EToR, EToBS);
            
            % check input element
            if( ne(obj.cell.type, ndg_lib.std_cell_type.Tri) )
                error(['Input cell type ', cell.type, 'is not triangle!'])
            end
            
        end% func
        
        obj = refine(obj, multi_rate); % ��������
    end% methods
    
end

