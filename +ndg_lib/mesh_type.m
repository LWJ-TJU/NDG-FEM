classdef mesh_type < int8
    %MESH_TYPE ���㵥Ԫö������
    %   Detailed explanation goes here
    
    enumeration
        Normal      (0) % ��ͨ��Ԫ
        Sponge      (1) % sponge cell
        Refine      (2) % ϸ�ֵ�Ԫ
        Coarse      (3) % �ֵ�Ԫ��ϸ��
        Wet         (4) % ʪ��Ԫ
        Dry         (5) % �ɵ�Ԫ
    end
    
    methods
    end
    
end

