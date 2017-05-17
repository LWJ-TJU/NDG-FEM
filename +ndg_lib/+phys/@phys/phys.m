classdef phys < matlab.mixin.SetGet
    %PHYS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Abstract, Constant)
        Nfield  % ��������
    end
    
    properties(Hidden=true)
        draw_h  % �������ͼ����
    end
    
    properties(SetAccess=protected)
        mesh        % �������
        f_extQ      % �ⲿֵ
        obc_file    % ���߽��ļ�
        out_file    % ����ļ�
    end
    properties
        f_Q     % ����
    end
    %% �麯��
    methods(Abstract)
        draw(obj, field) % ���Ƴ�ͼ
        [ f_Q ] = init(obj) % ��ʼ��
    end
    
    methods(Abstract, Access=protected)
        [ E ] = flux_term( obj, f_Q ) % �����������ͨ���� F
        [ dflux ] = surf_term( obj, f_Q ) % ����߽����ͨ����ֵ (Fn - Fn*)
        [ rhs ] = rhs_term(obj, f_Q ) % �����Ҷ���
    end
    
    %% ��������
    methods
        function obj = phys(mesh)
            obj.mesh = mesh;
            obj.f_Q = zeros(mesh.cell.Np, mesh.K, obj.Nfield);
            obj.f_extQ = zeros(mesh.cell.Np, mesh.K, obj.Nfield);
        end% func
    end
    
    % �Ǻ㶨����ʱ����ɢ����
    methods
        f_Q = RK45_solve(obj) % Runge-Kutta 4th order 5 stages
    end
    
    % �ļ� I/O
    methods
        function obj = set_out_file(obj, filename, dt)
            % ��������ļ�����
            obj.out_file = ndg_lib.phys.out_file(filename, ...
                obj.mesh.cell.Np, obj.mesh.cell.K, dt);
        end% func
        
        function obj = set_obc_file(obj, filename)
            % ���ÿ��߽��ļ�����
            obj.obc_file = ndg_lib.phys.obc_file(filename);
        end% func
        
        function obj = update_ext(obj, stime)
            % ���ݿ��߽��ļ���������ⲿ����
            vert_extQ = obj.obc_file.get_extQ(obj.Nfield, stime);
            vertlist = obj.obc_file.vert;
            vert_Q = zeros(obj.mesh.Nv, obj.Nfield);
            for fld = 1:obj.Nfield
                vert_Q(vertlist + (fld-1)*obj.mesh.Nv ) = vert_extQ(:, fld);
            end
            obj.f_extQ = obj.mesh.proj_vert2node(vert_Q);
        end% func
        
        function obj = init_from_file(obj, filename)
            % ��ȡ�ļ����ݽ��г�ʼ��
            fp = fopen(filename);
            Num = fscanf(fp, '%d', 1);
            Nfld = fscanf(fp, '%d', 1); % read number of physical fields
            if ( ( (Num~=obj.mesh.K) && (Num~=obj.mesh.Nv) ) )
                error(['The number of values in file: ', ...
                    num2str(Num), ...
                    ' is neither element number: ', num2str(obj.mesh.K), ...
                    ' nor vertex number: ', num2str(obj.mesh.Nv)]);
            elseif (Nfld~=obj.Nfield)
                error(['The number of physical field in file: ', ...
                    num2str(Nfld), ...
                    ' is different from this phys object: ', ...
                    num2str(obj.Nfield)]);
            end
            fmtStr = ['%d ', repmat('%g ', 1, Nfld)];
            data = fscanf(fp, fmtStr, [Nfld+1, Num]);
            switch Num
                case obj.mesh.K
                    fprintf('\nInit with elemental averaged values.\n\n')
                case obj.mesh.Nv
                    fprintf('\nInit with vertex values.\n\n')
            end
            fclose(fp);
        end
    end
    
end