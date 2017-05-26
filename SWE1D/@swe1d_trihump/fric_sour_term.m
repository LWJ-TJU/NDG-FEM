function [ sf ] = fric_sour_term( obj, f_Q )
%FRIC_SOUR_TERM һάǳˮ����Ħ��Դ��
%   ʪ��ԪĦ������� manning ��ʽ���㣨ʪ��Ԫ���нڵ�ˮ���0����
%   �ɵ�ԪĦ��Դ��Ϊ 0��

sf(:,:,1) = zeros(obj.mesh.cell.Np, obj.mesh.K);
sf(:,:,2) = -obj.gra.*obj.n.*f_Q(:,:,2).*abs(f_Q(:,:,2))./f_Q(:,:,1).^(7/3);

sf(:, ~obj.wetflag, 2) = 0;
end

