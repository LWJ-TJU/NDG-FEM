%% varGroup
% ���������
% 
classdef varGroup < handle
    properties(SetAccess = private)
        struc   % struct var to store variable
    end% properties
    
    methods
%% varGroup
% constructor function
        function obj = varGroup
        end% func
        
%% incert 
% �� group ��������ӱ���
% INPUT:
%   varName     - ��������
%   varData     - ����ֵ
        function obj = incert(obj, varName, varData)
            obj.struc.(varName) = varData;
        end% func
%% getVal
% ��ȡ group �����д���ı���
% INPUT:
%   varName     - ��������
% OUTPUT:
%   data        - ����ֵ
        function data = getVal(obj, varName)
            data = obj.struc.(varName);
        end% func
%% print
% show the variable stored in the group
        function print(obj)
            fieldnames(obj.struc)
        end% func
    end% method
end% class