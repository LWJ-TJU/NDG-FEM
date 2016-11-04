classdef Triangle < StdRegions.BaseElement
    %TRIANGLE ��ά��׼��Ԫ
    %   ��׼�����ε�Ԫ�����ýڵ��������nodal basis������Ӧ�ڵ�ΪLGL�ڵ�ֲ�
    %   ��Hesthaven and Warburton, 2008��
    
    properties
        r       % ��׼��Ԫ�ڵ�x����
        s       % ��׼��Ԫ�ڵ�y����
        V       % Vandermonde����
        invV    % Vandermonde�����
        M       % ��������
        Dr      % �ڵ��������r��
        Ds      % �ڵ��������s��
        Drw     % 
        Dsw
        Mes     % �߽���ֽڵ���������
        LIFT    % �߽�ͨ��ת������
        Fmask   % �߽��Ͻڵ���
    end
    
    methods
        function obj = Triangle(order)
            dim = 2; vertice = 3; face = 3;
            % �̳����԰����� 
            % nDim, nVertice, nOrder, nFace, nNode 
            obj = obj@StdRegions.BaseElement(dim,vertice,order,face);
            % �̳������趨
            obj.sName = 'Triangle';
            obj.nNode = (order+1)*(order+2)/2;
            
            % ��ȡ�ڵ㼯��
            [obj.r, obj.s] = GetCoor(order);
            % �߽��Ͻڵ���
            
            % Vandermonde����
            obj.V = obj.GetVandMatrix(order,obj.r,obj.s);
            obj.invV = inv(obj.V);
            % ��������
            obj.M = obj.invV'*obj.invV;
            % ��������
            [obj.Dr, obj.Ds] = GetGrandMatrix( order,obj.r,obj.s,obj.V );
            
        end% func
        
        % ����Vandermonde����
        V = GetVandMatrix(obj, order, r, s);
    end
    
end

