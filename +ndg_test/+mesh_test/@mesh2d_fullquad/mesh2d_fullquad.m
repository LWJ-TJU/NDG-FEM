classdef mesh2d_fullquad < ndg_lib.mesh.mesh2d
    %MESH2D_FULLQUAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        invM % inverse mass matrix of each element
        Sx, Sy % ����ָնȾ��� $S_{x,ij} = J(\xi_j) d\varphi_i/dx|_{\xi_j}$
        Mes % �����ϵ������ Js \cdot \varphi_i(\xi_j)
        Jq, % ��ֵ�ڵ㴦�ſ˱�����ʽ
        rxq, ryq, rzq
        sxq, syq, szq
        txq, tyq, tzq
    end
    
    methods
        function obj = mesh2d_fullquad(cell, varargin)
            obj = obj@ndg_lib.mesh.mesh2d(cell, varargin{:});
            % ����ÿ������������
            obj.Jq = obj.cell.map2vol_quad_point(obj.J);
            obj.invM = mass_matrix(obj);
        end
    
        function invM = mass_matrix(obj)
            invM = zeros(obj.cell.Np, obj.cell.Np, obj.K);
            for k = 1:obj.K % ���㵥Ԫ��������
                JVq = bsxfun(@times, obj.cell.wq.*obj.Jq(:, k), ...
                    obj.cell.Vq);
                mass_mat = obj.cell.Vq'*JVq;
                invM(:, :, k) = inv(mass_mat);
            end
        end
        
        function [ Sx, Sy ] = stiff_matrix(obj)
            
        end
    end
end

