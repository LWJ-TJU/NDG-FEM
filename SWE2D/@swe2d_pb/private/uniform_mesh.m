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
xlim = [-4000, 4000]; 
ylim = [-4000, 4000];
face_type = [ndg_lib.bc_type.ZeroGrad,...
    ndg_lib.bc_type.ZeroGrad, ...
    ndg_lib.bc_type.ZeroGrad, ...
    ndg_lib.bc_type.ZeroGrad];
switch type
    case ndg_lib.std_cell_type.Tri
        cell = ndg_lib.get_std_cell(N, type);
        mesh = ndg_lib.mesh.tri_mesh(cell, 'uniform', ...
            {xlim, ylim, M, M, face_type});
        
    case ndg_lib.std_cell_type.Quad
        cell = ndg_lib.get_std_cell(N, type);
        mesh = ndg_lib.mesh.quad_mesh(cell, 'uniform', ...
            {xlim, ylim, M, M, face_type});
end
end

