function [nx, ny, nz, Js] = ele_suf_factor(obj, vx, vy, EToV)
%MESH_EDGE_FACTOR ���㵥Ԫ�ڸ������ⷨ��������Jacobian�任ϵ��
%   ���㵥Ԫ�߽�Ӧ��Ϊֱ�ߣ�ÿ�����ϸ����ڵ��ⷨ������ֻ��Ψһֵ
%

nx = zeros(obj.cell.Nface, obj.K);
ny = zeros(obj.cell.Nface, obj.K);
nz = zeros(obj.cell.Nface, obj.K);

for f = 1:obj.cell.Nface
    face_x1 = vx(EToV(obj.cell.FToV(1,f), :));
    face_x2 = vx(EToV(obj.cell.FToV(2,f), :));
    face_y1 = vy(EToV(obj.cell.FToV(1,f), :));
    face_y2 = vy(EToV(obj.cell.FToV(2,f), :));
    
    nx(f, :) =  (face_y2 - face_y1);
    ny(f, :) = -(face_x2 - face_x1);
end

% normalise
Js = sqrt(nx.*nx+ny.*ny); 
nx = nx./Js; 
ny = ny./Js;
Js = Js.*0.5;
end

