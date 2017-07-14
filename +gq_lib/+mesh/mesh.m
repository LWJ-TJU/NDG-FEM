classdef mesh < ndg_lib.mesh.mesh
    %MESH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess=protected)
        invM % inverse mass matrix of each element
        Jq, % ��ֵ�ڵ㴦�ſ˱�����ʽ
        rxwJq, rywJq, rzwJq % ���ֽڵ㴦�任ϵ���������Ȩ�أ�Jacobi ϵ��֮��
        sxwJq, sywJq, szwJq 
        txwJq, tywJq, tzwJq
        
        eidMq, eidPq
        eidtypeq,
        nxq, nyq, nzq % �߽���ֵ��ⷨ������
        wJsq % ��jacobiϵ��������ֽڵ�Ȩ�س˻�
    end
    
    methods
        
        function obj = mesh(cell, Nv, vx, vy, vz, K, EToV, EToR, EToBS)
            obj = obj@ndg_lib.mesh.mesh(cell, ...
                Nv, vx, vy, vz, K, EToV, EToR, EToBS);
            % ����ÿ������������
            obj.Jq = obj.cell.project_node2quad(obj.J);
            obj.invM = mass_matrix(obj);
            % ������ֽڵ㴦����ֱ任ϵ�������Ȩ��֮��
            obj.rxwJq = obj.vol_scal(obj.rx);
            obj.rywJq = obj.vol_scal(obj.ry);
            obj.rzwJq = obj.vol_scal(obj.rz);
            obj.sxwJq = obj.vol_scal(obj.sx);
            obj.sywJq = obj.vol_scal(obj.sy);
            obj.szwJq = obj.vol_scal(obj.sz);
            obj.txwJq = obj.vol_scal(obj.tx);
            obj.tywJq = obj.vol_scal(obj.ty);
            obj.tzwJq = obj.vol_scal(obj.tz);
            % �߽���ֽڵ㴦���������ſ˱�ϵ��
            [obj.nxq, obj.nyq, obj.nzq, obj.wJsq] ...
                = face_scal(obj, obj.vx, obj.vy, obj.vz, obj.EToV);
            [obj.eidMq, obj.eidPq, obj.eidtypeq] = connect_quad_node(obj);
        end
    end
    
    %% ˽�к���
    methods(Abstract, Hidden, Access=protected)
        [nxq, nyq, nzq, wJsq] = face_scal(obj, vx, vy, vz, EToV);
    end
    
    methods(Hidden, Access=protected)
        function [rxwq] = vol_scal(obj, rx)
            rxwq = bsxfun(@times, obj.cell.wq, ...
                obj.cell.project_node2quad(rx).*obj.Jq);
        end% func
        
        function invM = mass_matrix(obj)
            invM = zeros(obj.cell.Np, obj.cell.Np, obj.K);
            for k = 1:obj.K % ���㵥Ԫ��������
                JVq = bsxfun(@times, obj.cell.wq.*obj.Jq(:, k), ...
                    obj.cell.Vq);
                mass_mat = obj.cell.Vq'*JVq;
                invM(:, :, k) = inv(mass_mat);
            end
        end% func
        
        function [eidMq, eidPq, eidtypeq] = connect_quad_node(obj)
            % calculate the total nodes
            eidMq = zeros(obj.cell.Nfqtotal, obj.K); 
            eidPq = zeros(obj.cell.Nfqtotal, obj.K);
            eidtypeq = int8(zeros(obj.cell.Nfqtotal, obj.K));
            
            sk = 1; list = 1:obj.cell.Nfqtotal;
            for k1 = 1:obj.K
                xMq = obj.cell.project_node2surf_quad(obj.x(:, k1));
                yMq = obj.cell.project_node2surf_quad(obj.y(:, k1));
                zMq = obj.cell.project_node2surf_quad(obj.z(:, k1));
                
                nid = 1;
                for f1 = 1:obj.cell.Nface
                    k2 = obj.EToE(f1, k1);
                    xPq = obj.cell.project_node2surf_quad(obj.x(:, k2));
                    yPq = obj.cell.project_node2surf_quad(obj.y(:, k2));
                    zPq = obj.cell.project_node2surf_quad(obj.z(:, k2));
                    type = int8(obj.EToBS(f1, k1));
                    
                    Nfnode = obj.cell.Nfq(f1);
                    for n = 1:Nfnode
                        eidMq(sk) = (k1-1)*obj.cell.Nfqtotal + nid;

                        xpM = xMq(nid);
                        ypM = yMq(nid);
                        zpM = zMq(nid);

                        d12 = (xpM - xPq).^2 + (ypM - yPq).^2 + (zpM - zPq).^2;
                        m = (d12 < 3e-16);
                        try
                            eidPq(sk) = (k2-1)*obj.cell.Nfqtotal + list(m);
                        catch
                            keyboard;
                        end
                        eidtypeq(sk) = type;
                        sk = sk+1; nid = nid + 1;
                    end
                end
            end% for
        end
    end
end

