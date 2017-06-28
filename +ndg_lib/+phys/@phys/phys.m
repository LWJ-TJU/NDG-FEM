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
        f_extQ      % �ⲿֵ
        obc_file    % ���߽��ļ�
        out_file    % ����ļ�
    end
    properties
        mesh        % �������
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
    
    % �������
    methods
        function err = norm_err2(obj, time)
            % ����1������
            % ���棬���ô˺���ʱ��Ҫ���ȶ��徫ȷ�⺯����
            %   f_ext = ext_func(obj, time)
            % ext_func ��������ʱ�䷵�ظ��ڵ㾫ȷ�⡣
            f_ext = ext_func(obj, time); 
            err = zeros(obj.Nfield, 1);
            f_abs = obj.f_Q - f_ext;
            area = sum(obj.mesh.vol);
            for fld = 1:obj.Nfield
                temp = f_abs(:,:,fld).*f_abs(:,:,fld);
                err(fld) = sqrt( sum( ...
                    obj.mesh.cell_mean(temp).*obj.mesh.vol ) )./area;
            end
        end
        
        function err = norm_err1(obj, time)
            % ����2������
            % ���棬���ô˺���ʱ��Ҫ���ȶ��徫ȷ�⺯����
            %   f_ext = ext_func(obj, time)
            % ext_func ��������ʱ�䷵�ظ��ڵ㾫ȷ�⡣
            f_ext = ext_func(obj, time);
            err = zeros(obj.Nfield, 1);
            f_abs = obj.f_Q - f_ext;
            area = sum(obj.mesh.vol);
            for fld = 1:obj.Nfield
                temp = abs( f_abs(:,:,fld) );
                err(fld) = sum( ...
                    obj.mesh.cell_mean(temp).*obj.mesh.vol )./area;
            end
        end
        
        function err = norm_errInf(obj, time)
            % �����������
            % ���棬���ô˺���ʱ��Ҫ���ȶ��徫ȷ�⺯����
            %   f_ext = ext_func(obj, time)
            % ext_func ��������ʱ�䷵�ظ��ڵ㾫ȷ�⡣
            f_ext = ext_func(obj, time);
            err = zeros(obj.Nfield, 1);
            f_abs = obj.f_Q - f_ext;
            for fld = 1:obj.Nfield
                temp = abs( f_abs(:,:,fld) );
                err(fld) = max( obj.mesh.cell_mean(temp) );
            end
        end
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
            vert_extQ = obj.obc_file.get_extQ(stime);
            vertlist = obj.obc_file.vert;
            for fld = 1:obj.Nfield % map vertex values to nodes
                vert_Q = zeros(obj.mesh.Nv, 1);
                vert_Q( vertlist ) = vert_extQ(:, fld);
                obj.f_extQ(:,:,fld) = obj.mesh.proj_vert2node(vert_Q);
            end
            
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