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
                    [Nv, vx, vy, K, EToV, EToR, EToBS] ...
                        = check_user_input(var);
                case 'uniform'
                    var = varargin{2};
                    xlim = var{1};
                    ylim = var{2};
                    Mx = var{3};
                    My = var{4};
                    facetype = var{5};
                    [Nv, vx, vy, K, EToV, EToR, EToBS] ...
                        = uniform_mesh(xlim, ylim, Mx, My, facetype);
                otherwise
                    
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

function [Nv, vx, vy, K, EToV, EToR, EToBS] = check_user_input(input)
% check the input variables for initlizing the mesh object.
Nv = input{1};
vx = input{2}; 
vy = input{3}; 
K  = input{4}; 
EToV = input{5};
EToR = int8(input{6}); 
EToBS = int8(input{7});

% check the # of the vertex
if ( numel(vx) ~= Nv ) || ( numel(vy) ~= Nv )
    error(['The length of input vertex coordinate "vx" or "vy" ', ...
        'is not equal to Nv']);
end% func

% check the # of the elements
if ( size(EToV, 2) ~= K )||( size(EToBS, 2) ~= K ) ||( numel(EToR) ~= K )
    error(['The length of input "EToV", "EToR" or "EToBS" ', ...
        'is not equal to K']);
end% func

if ( size(EToV, 1) ~= size(EToBS, 1) )
    error('The numbers of vertex in "EToV" and "EToBS" are not equal');
end% func

end% func
