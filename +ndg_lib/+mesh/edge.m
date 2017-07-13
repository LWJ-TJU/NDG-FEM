classdef edge
    %EDGE �����ڱ߽����
    %   Detailed explanation goes here
    
    properties
        cell % ��׼��Ԫ
    end
    
    properties(SetAccess=protected)
        Nedge % �߽����
        Nnode % �߽�ڵ����
        kM, kP % �������൥Ԫ���
        fM, fP % ��������������Ԫ����
        ftype@int8 % ������
        idM, idP % �߽�������ڵ���
        fpM, fpP % �߽�������ڵ�����ڵ��оֲ����
        fscal % �ſ˱�����ʽ
        fnxM, fnyM, fnzM % ������
    end
    
    methods
        function obj = edge(cell, x, y, z, EToV, EToE, EToF, EToBS)
            
            obj.cell = cell;
            [obj.Nedge, obj.Nnode, obj.kM, obj.kP, obj.fM, obj.fP, obj.ftype] ...
                = obj.edge_connect(EToV, EToE, EToF, EToBS);
            
        end
    end
    
    methods(Access=protected)
        function [ Nedge, kM, kP, fM, fP, ftype ] ...
                = edge_connect(obj, EToV, EToE, EToF, EToBS)
            
        end
        
        function [Nnode, iM, iP, fpM, fpP] ...
                = node_connect(obj, x, y, z, Nedge, kM, kP, fM, fP)
        end
        
        
    end
end

