function [K,EToV,Nv,VX,VY,EToBS,EToR] = tri_mesh(Mx, My, ...
    xmin, xmax, ymin, ymax, bc_type)
%TRI_MESH  ���ɾ�������������
%    ����������������� [xmin, xmax] x [ymin, ymax] ȷ�������� x��y ÿ������
%    ��Ԫ�����ֱ�Ϊ Mx �� My������������Ϊֱ�������Σ����ı����ضԽ��߷ָ���ɣ�
%    flag ����ȷ���Խ��߷ָ��
% 
% Parameters
%    Mx, My     - x��y �������ϵ�Ԫ������
%    xmin,xmax  - x �����᷶Χ
%    ymin,ymax  - y �����᷶Χ
%    flag       - �����λ��ַ��� [flag=0, "\", flag=1, "/"]
flag = 0;
%
% Author(s)
%    li12242 Tianjin University

%% Parameters
Nx = Mx + 1; % number of nodes along x coordinate
Ny = My + 1;
K  = Mx * My * 2;
Nv = Nx * Ny;
EToR = int8( ones(K, 1) )*ndg_lib.mesh_type.Normal;

%% Define vertex
% The vertex is sorted along x coordinate. (x coordinate counts first)
VX   = linspace(xmin, xmax, Nx) ;
VY   = linspace(ymin, ymax, Ny)'; 
VX   = repmat(VX, 1, Ny) ;
VY   = repmat(VY, 1, Nx)'; 
VX   = VX(:);
VY   = VY(:);

%% Define EToV
% The element is conuting along x coordinate
EToV = zeros(3, 2*Mx*My);
for i = 1:My % each row
    for j = 1:Mx
        % element index
        ind1 = 2*Mx*(i-1) + j;
        ind2 = 2*Mx*(i-1)+Mx+j;
        % vertex index
        v1 = Nx*(i-1) + j;
        v2 = Nx*(i-1) + j + 1;
        v3 = Nx*i + j;
        v4 = Nx*i + j + 1;
        % Counterclockwise
        if flag % '/' divided
            EToV(:, ind1) = [v1, v4, v3]';
            EToV(:, ind2) = [v1, v2, v4]';
        else    % '\' divided
            EToV(:, ind1) = [v1, v2, v3]';
            EToV(:, ind2) = [v2, v4, v3]';
        end% if
    end
end

[ EToBS ] = ndg_utility.uniform_mesh.uniform_bc( Mx, My, EToV, bc_type );
end