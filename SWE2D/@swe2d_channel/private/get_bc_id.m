function [ EToB ] = get_bc_id( obj )
%GET_BC_ID ��ȡÿ����Ԫ��Ӧ�ı߽����
%   Detailed explanation goes here

EToB = obj.mesh.EToBS;
EToB( EToB == 2 ) = 1;
EToB( EToB == 4 ) = 2;
EToB( EToB == 5 ) = 3;
end
