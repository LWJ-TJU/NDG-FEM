function [ EToBS ] = uniform_bc( Mx, My, EToV, face_type )
%UNIFORM_BC ���þ��������ϱ߽�ڵ㼰�߽�������
%   �ھ��������У�Ĭ�Ͻڵ��Ŵ����½ǿ�ʼ�������� x �����ѭ�������ر߽����
%   �ײ����ϲ��������Ҳ��ĸ��������ѭ�������� EToBS �У�ÿ�У������߽�����
%   �����ڵ�����߽����͡�
% Input:
%   Mx, My      - x��y �᷽���ϱ߽��������
%   face_type   - �ײ����ϲ��������Ҳ�߽�������
% Output:
%   BSToV       - ÿ���߽����϶�����ֵ��
% Usages:
% 

% ͳ��ÿ�����߽綥�����
BSToV = ones((Mx+My)*2, 3);
Nx = Mx + 1; Ny = My + 1; % x �� y �������϶������
Nv = Nx * Ny;
% �ײ��߽�
st = 1; 
se = st + Mx - 1;
BSToV(st:se,[1,2]) = [1:(Nx-1); 2:Nx]';
BSToV(st:se, 3) = face_type(1); % �߽�����
% �ϲ��߽�
st = se + 1; 
se = st + Mx - 1;
vs = Nx*(Ny-1)+1; 
ve = Nx*Ny;
BSToV(st:se,[1,2]) = [vs:(ve-1); (vs+1):ve]';
BSToV(st:se, 3) = face_type(2); % �߽�����
% ���߽�
st = se + 1; 
se = st + My - 1;
vs = 1; 
ve = Nx*(Ny-1)+1; 
vstrid = Nx;
BSToV(st:se,[1,2]) = [vs:vstrid:(ve-vstrid); (vs+vstrid):vstrid:ve]';
BSToV(st:se, 3) = face_type(3); % �߽�����
% �Ҳ�߽�
st = se + 1; 
se = st + My - 1;
vs = Nx; 
ve = Nx*Ny; 
vstrid = Nx;
BSToV(st:se,[1,2]) = [vs:vstrid:(ve-vstrid); (vs+vstrid):vstrid:ve]';
BSToV(st:se, 3) = face_type(4); % �߽�����

% ��ÿ���߽��渳����
ind = min( BSToV(:, [1,2]), [], 2)*Nv + max( BSToV(:, [1,2]), [], 2);
ftype = BSToV(:, 3);

% ת��Ϊ��Ԫ�߽����� EToBS
[Nface, K] = size(EToV);
EToBS = int8(ones(Nface, K)).*ndg_lib.bc_type.Inner; % initialize
for k = 1:K
    for f = 1:Nface
        v1 = EToV(f, k);
        v2 = EToV(mod(f, Nface)+1, k);
        t = min(v1, v2)*Nv + max(v1, v2);
        tnd = find( abs(ind - t)<1e-10 );
        if isempty(tnd)
            continue
        else
            EToBS(f, k) = ftype(tnd);
        end
    end
end
end

