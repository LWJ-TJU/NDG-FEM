function [ mesh ] = uniform_mesh( N, M, type )
%UNIFORM_MESH �����ά���������λ��ı�������
%   ���ݸ��������������ͱ�׼��Ԫ���ͣ����ȹ����׼��Ԫ���� cell��������
%   ndg_utility.uniform_mesh �������ļ����ɶ�Ӧ�������������ı�������
%   ��������Χ���ݲ��� xmin/xmax �� ymin/ymax ȷ�������������ĸ��߽��
%   �������� face_type ָ����
% Input
%   N   - ����������
%   M   - xy ���ϵ�Ԫ��ʽ
%   type - ��׼��Ԫ���ͣ�������/�ı���
% Output:
%   mesh - �������
%
xmin = -100; xmax = 100; 
ymin = -100; ymax = 100;
face_type = [ndg_lib.bc_type.ZeroGrad,...
    ndg_lib.bc_type.ZeroGrad, ...
    ndg_lib.bc_type.ZeroGrad, ...
    ndg_lib.bc_type.ZeroGrad];

switch type
    case ndg_lib.std_cell_type.Tri
        cell = ndg_lib.ndg_cell(N, type);
        [K,EToV,Nv,VX,VY,EToBS,EToR] = ...
            ndg_utility.uniform_mesh.tri_mesh(M, M, ...
            xmin, xmax, ymin, ymax, face_type);
        mesh = ndg_lib.mesh.tri_mesh(cell, Nv, VX, VY, ...
            K, EToV, EToR, EToBS);
        
    case ndg_lib.std_cell_type.Quad
        cell = ndg_lib.ndg_cell(N, type);
        [K,EToV,Nv,VX,VY,EToBS,EToR] = ...
            ndg_utility.uniform_mesh.quad_mesh(M, M, ...
            xmin, xmax, ymin, ymax, face_type);
        mesh = ndg_lib.mesh.quad_mesh(cell, Nv, VX, VY, ...
            K, EToV, EToR, EToBS);
end

end

