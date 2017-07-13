classdef mesh < matlab.mixin.SetGet
    %@STD_MESH Summary of this class goes here
    %   Detailed explanation goes here
    
    %%
    properties
        cell
        K
        Nv
        EToV % element to vertex information
        EToR@int8
        EToBS
        vx, vy, vz
        J
    end
    
    % elemental volume infomation
    properties(SetAccess=protected)
        Eind % ÿ�����Ӧ�Ķ������
        EToE, EToF
        x, y, z
        rx, ry, rz
        sx, sy, sz
        tx, ty, tz
        vol, elen
        spg_delta % ��������߽�����
    end
    
    properties(SetAccess=protected)
        eidM, eidP
        eidtype@int8
        eidfscal
    end
    
    % elemental edge information
    properties(SetAccess=protected)
        nx, ny, nz
        Js
    end
    
%     % edge information
%     properties(SetAccess=protected)
%         Nedge
%         Nnode
%         kM, kP
%         fM, fP
%         ftype@int8
%         idM, idP
%         fpM, fpP
%         fscal
%         fnxM, fnyM, fnzM
%     end
    
    
    %% Abstract methods
    methods(Abstract, Hidden, Access = protected)
        ele_vol_factor(obj) % get volume infomation () of each element
        ele_suf_factor(obj) % get out normal vector of each elemental edges
%         edge_connect(obj) % get edge connection through element connection
        Eind = get_Eind(obj) % ��ȡ������������
    end
    
    methods(Abstract)
        draw(obj); 
    end
    
    %% public methods
    methods
        function nodeQ = proj_vert2node(obj, vertQ)
            % project scalars from mesh verts to nodes
            ele_vQ = vertQ(obj.EToV); % ÿ����Ԫ����ֵ
            nodeQ = obj.cell.project_vert2node(ele_vQ);
        end
        
        function c_m = cell_mean(obj, f_Q)
            % calculate the cell averaged values
            [ c_m ] = cell_mean( f_Q, obj.cell.w, obj.J );
        end
        
        function f_m = face_mean(obj, f_Q)
            % ���㵥Ԫ��ÿ�����ֵ
            par = bsxfun(@times, obj.cell.ws, obj.Js);
            f_m = zeros(obj.cell.Nface, obj.K);
            f_M = f_Q(obj.eidM);
            tmp = par.*f_M;
            st = 1;
            if (obj.cell.Nfp == 1)
                f_m = tmp;
            else
                for f = 1:obj.cell.Nface
                    sk = st + obj.cell.Nfp(f);
                    row = st:(sk-1);
                    f_m(f, :) = sum( tmp(row, :) )./sum(par(row, :));
                    st = sk;
                end
            end
        end
    end
    
    %% I/O methods
    methods(Abstract)
        % read mesh information from input file, I/O methods
        [Nv, vx, vy, vz, K, EToV, EToR, EToBS] = read_from_file(casename)
    end
    
    %% ���к���
    methods
        function obj = mesh(cell, Nv, vx, vy, vz, K, EToV, EToR, EToBS)
            % ���������������
            obj.cell = cell; 
            obj.Nv = Nv;
            obj.vx = vx; 
            obj.vy = vy; 
            obj.vz = vz;
            obj.K  = K; 
            obj.EToV = EToV;
            obj.EToR = int8(EToR); 
            obj.EToBS = int8(EToBS);
            
            % ��ȡÿ����Ԫ���ڵ�Ԫ���
            obj.Eind = obj.get_Eind();
            obj = ele_connect(obj, obj.Eind);
            obj = ele_node_project(obj, vx, vy, vz);
            
            [obj.rx, obj.ry, obj.rz, obj.sx, obj.sy, obj.sz, ...
                obj.tx, obj.ty, obj.tz, obj.J] = ele_vol_factor(obj);
            
            [obj.nx, obj.ny, obj.nz, obj.Js] ...
                = ele_suf_factor(obj, obj.vx, obj.vy, obj.EToV);
            
%             [obj.Nedge, obj.Nnode, ...
%                 obj.kM, obj.kP, obj.fM, obj.fP, obj.ftype, ...
%                 obj.idM, obj.idP, obj.fpM, obj.fpP, obj.fscal, ...
%                 obj.fnxM, obj.fnyM, obj.fnzM] ...
%                 = edge_connect(obj, obj.EToV, obj.EToE, obj.EToF, obj.EToBS);
            
            obj = ele_node_connect(obj);
            
            obj = ele_scale(obj);
        end% func
    end
    
    %% ˽�к���
    methods(Hidden, Access=protected)
        
        function obj = ele_connect(obj, Eind)
            % ��ȡ��Ԫ���ڵ�Ԫ��ţ�EToE�������ţ�EToF��
            etoe = ones(obj.cell.Nface, 1)*(1:obj.K);
            etof = (1:obj.cell.Nface)'*ones(1,obj.K);

            for n = 1:(obj.cell.Nface*obj.K)
                m = find( abs(Eind - Eind(n))<1e-10 );
                t = m( m ~= n );
                if( ~isempty(t) )
                    etoe(n) = fix( (t-1)./obj.cell.Nface )+1;
                    etof(n) = rem(t-1, obj.cell.Nface)+1;
                end
            end
            obj.EToE = etoe;
            obj.EToF = etof;
        end
        
        function obj = ele_scale(obj)
            len = sum( bsxfun(@times, obj.cell.w, obj.J) );
            
            par = bsxfun(@times, obj.cell.ws, obj.Js);
            eglen = zeros(obj.cell.Nface, obj.K);
            if (obj.cell.Nfp == 1)
                eglen = par;
            else
                st = 1;
                for f = 1:obj.cell.Nface
                    sk = st + obj.cell.Nfp(f);
                    row = st:(sk-1);
                    eglen(f, :) = sum(par(row, :));
                    st = sk;
                end
            end
            obj.vol = len;
            obj.elen = eglen;
        end% func
        
        function obj = ele_node_project(obj, vx, vy, vz)
            % ���㵥Ԫ�ڽڵ�����
            obj.x = obj.proj_vert2node(vx);
            obj.y = obj.proj_vert2node(vy);
            obj.z = obj.proj_vert2node(vz);
        end% func
        
        function obj = ele_node_connect(obj)
            % ��ȡ�߽��ϱ���Ԫ�����ڵ�Ԫ�ڵ���
            Nfptotal = obj.cell.Nfptotal;
            idm = zeros(Nfptotal, obj.K);
            idp = zeros(Nfptotal, obj.K);
            type = int8(zeros(Nfptotal, obj.K));
            
            Np = obj.cell.Np;
            for k1 = 1:obj.K
                idm(:, k1) = (k1-1)*Np + obj.cell.Fmask(:);
                f1 = 1; nfp1 = 1; % ��Ԫ����ڵ�����������ֲ��ڵ���
                for n = 1:Nfptotal
                    if nfp1 > obj.cell.Nfp(f1) % ����ڵ��ų���f1��ڵ�����
                        nfp1 = 1;
                        f1 = f1 + 1; % ����+1
                    end
                    type(n, k1) = int8(obj.EToBS(f1, k1));
                    
                    k2 = obj.EToE(f1, k1); % ���ڵ�Ԫ
                    f2 = obj.EToF(f1, k1); % ������
                    
                    xpM = obj.x(idm(n, k1)); % ����Ԫ�߽�ڵ�����
                    ypM = obj.y(idm(n, k1));
                    zpM = obj.z(idm(n, k1));
                    % �����������нڵ�����
                    ind2 = (k2-1)*Np + obj.cell.Fmask(:, f2); 
                    xP = obj.x( ind2 );
                    yP = obj.y( ind2 );
                    zP = obj.z( ind2 );
                    d12 = (xpM - xP).^2 + (ypM - yP).^2 + (zpM - zP).^2;
                    m = (d12 < 3e-16);
                    idp(n, k1) = (k2-1)*Np + obj.cell.Fmask(m, f2);
                    nfp1 = nfp1 + 1;
                end
            end
            obj.eidM = idm;
            obj.eidP = idp;
            obj.eidtype = type;
            
        end
    end
    
end

