classdef quad_fullquad < ndg_lib.std_cell.quad
    %QUAD_FULLQUADRATURE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Nq, Nfq % Gauss-Legrend �����������ֽڵ����
        zq, q % һά Gauss-Legrend �߽���ֽڵ㼰Ȩ��
        rbq, sbq, wbq % �߽��� Gauss-Legrend ���ֽڵ���Ȩ��
        rq, sq, wq  % Gauss-Legrend ���ֽڵ���Ȩ��
        Vq, Vbq % ����ֽڵ�������ֽڵ�ͶӰ������ÿ��Ϊһ���������ڸ��㺯��ֵ
        Drq, Dsq % ����ֽڵ㴦��ֵ����������ÿ��Ϊһ���������ڸ��㵼��
    end
    
    methods
        function obj = quad_fullquad(N)
            obj = obj@ndg_lib.std_cell.quad(N);
            Nq = obj.N+1; % ÿ��ά�Ȼ��ֽڵ����
            obj.Nq = Nq^2;
            obj.Nfq = Nq*obj.Nface;
            [obj.zq, obj.q] = Polylib.zwgl(Nq); % һά GL ���ֽڵ�
            [obj.rq, obj.sq, obj.wq, obj.rbq, obj.sbq, obj.wbq] ...
                = quadrature_point(obj, Nq, obj.zq, obj.q);
            obj.Vq = vandermonde_mat(obj, obj.rq, obj.sq);
            obj.Vbq = vandermonde_mat(obj, obj.rbq, obj.sbq);
            obj.Drq = obj.proj_node2quad(obj.Dr); 
            obj.Dsq = obj.proj_node2quad(obj.Ds);
            %obj.Drq = obj.Drq'; obj.Dsq = obj.Dsq';
        end
        
        function [rq, sq, w, rbq, sbq, wbq] = ...
                quadrature_point(obj, Nq, zq, wq)
            % ��Ԫ�� GL ���ֽڵ�
            np = numel(zq);
            % ���Ȱ���x����ѭ����Ȼ����y����ѭ��
            rq = zq*ones(1, np);
            sq = ones(np, 1)*zq';

            rq = rq(:); sq = sq(:); w = bsxfun(@times, wq, wq');
            w = w(:);
            % �߽� GL ���ֽڵ�
            rbq = zeros(Nq, obj.Nface);
            sbq = zeros(Nq, obj.Nface);
            wbq = zeros(Nq, obj.Nface);
            for f = 1:obj.Nface
                vind = obj.FToV(:, f);
                rv = obj.vr(vind);
                sv = obj.vs(vind);
                rbq(:, f) = 0.5*((1-zq)*rv(1) + (1+zq)*rv(2));
                sbq(:, f) = 0.5*((1-zq)*sv(1) + (1+zq)*sv(2));
                wbq(:, f) = wq;
            end
            rbq = rbq(:); sbq = sbq(:); wbq = wbq(:);
        end
                
        function [ V ] = vandermonde_mat(obj, r, s)
            Ng = numel(r);
            Vg = zeros(Ng, obj.Np);
            for n = 1:obj.Np
                Vg(:, n) = obj.orthogonal_func(obj.N, n, r, s, obj.t);
            end% for
            V = Vg/obj.V;
        end
        
        function [ fq_Q ] = proj_node2quad(obj, f_Q)
            % ���ݲ�ֵ�ڵ�ϵ������ guass ���ֵ㺯��ֵ
            fq_Q = obj.Vq*f_Q;
        end
        
        function [ fbq_Q ] = proj_node2surf_quad(obj, f_Q)
            % ���ݲ�ֵ�ڵ�ϵ������߽� gauss ���ֵ㺯��ֵ
            fbq_Q = obj.Vbq*f_Q;
        end
    end
    
end

