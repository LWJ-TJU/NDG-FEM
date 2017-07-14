classdef gauss_quad_cell < ndg_lib.std_cell.std_cell
    %GAUSS_QUAD_CELL Gauss ��ֵ���ֵ�Ԫ��������
    %   Detailed explanation goes here
    
    properties(SetAccess = protected)
        Nq % ����ֽڵ����
        Nfq % ����ֽڵ����
        Nfqtotal % ����ֽڵ�����
    end
    % ���ֽڵ�����
    properties(SetAccess = protected)
        rq, sq, tq % ����ֽڵ�
        wq % ���ֽڵ�Ȩ��
        rbq, sbq, tbq % ����ֽڵ�
        wbq % �߽���ֽڵ�Ȩ��
    end
    
    % �������ڻ��ֽڵ㺯��ֵ����
    properties(SetAccess = protected)
        Vq % ���ֽڵ�ת������
        Vbq % �߽���ֽڵ�ת������
    end
    
    % �������ڻ��ֽڵ㵼��ֵ����
    properties(SetAccess = protected)
        Drq, Dsq, Dtq % ���ֽڵ㴦��������������
    end
    
    % ˽���麯��
    methods(Abstract, Access=protected) 
        [rq, sq, tq, wq] = gaussquad_vol_coor(obj, N);
        [rbq, sbq, tbq, wbq, Nfq] = gaussquad_surf_coor(obj, N);
    end
    
    methods
        function obj = gauss_quad_cell(N)
            obj = obj@ndg_lib.std_cell.std_cell(N);
            
            [obj.rq, obj.sq, obj.tq, obj.wq] = obj.gaussquad_vol_coor(N);
            try
            [obj.rbq, obj.sbq, obj.tbq, obj.wbq, obj.Nfq] ...
                = obj.gaussquad_surf_coor(N);
            catch 
                keyboard
            end
            
            obj.Nq = numel(obj.rq);
            obj.Nfqtotal = numel(obj.rbq);
            
            obj.Vq = vand_mat(obj, obj.rq, obj.sq);
            obj.Vbq = vand_mat(obj, obj.rbq, obj.sbq);
            obj.Drq = obj.project_node2quad(obj.Dr); 
            obj.Dsq = obj.project_node2quad(obj.Ds);
            obj.Dtq = obj.project_node2quad(obj.Dt);
        end
        
        function [ fq_Q ] = project_node2quad(obj, f_Q)
            % ���ݲ�ֵ�ڵ�ϵ������ guass ���ֵ㺯��ֵ
            fq_Q = obj.Vq*f_Q;
        end
        
        function [ fbq_Q ] = project_node2surf_quad(obj, f_Q)
            % ���ݲ�ֵ�ڵ�ϵ������߽� gauss ���ֵ㺯��ֵ
            fbq_Q = obj.Vbq*f_Q;
        end
    end
    
    methods
        function [ V ] = vand_mat(obj, r, s)
            % ����ڵ㴦��������ֵ
            Ng = numel(r);
            Vg = zeros(Ng, obj.Np);
            for n = 1:obj.Np % ÿ������Ϊ�� n ���������ڸ��ڵ㴦����ֵ
                Vg(:, n) = obj.orthogonal_func(obj.N, n, r, s, obj.t);
            end% for
            V = Vg/obj.V;
        end
    end
    
end

