classdef (HandleCompatible = true) ndg_list
    %NDG_LIST ���ɶ�ά��������
    %   ��ά�����д洢
    %
    % Usages:
    %   ���ɰ���5����������������ÿ��Ԫ�ظ����ֱ�Ϊ[2,2,5,4,5]
    %   list = ndg_list([2,2,5,4,5]);
    %   
    %   ����ȡֵ�����ַ�ʽ���ֱ��ǰ�������źͰ�Ԫ����ţ���
    %   list(3)     % ���ص�����Ԫ��ֵ�����ڶ��е�һ��Ԫ��;
    %   list(2, 4)  % ���صڶ��е��ĸ�Ԫ��;
    %   ע�⣬���ǵ�4��ֻ��1��Ԫ�أ���ô˳������5��ȡ���һ��Ԫ��.
    %
    %   ����ֵ�����ַ�ʽ���ֱ���
    %   list = ndg_list([2,2,5]);
    %   list(3) = 1:7   % �ӵڶ���Ԫ�ؿ�ʼ����1:7�ֱ�ֵ������Ԫ����;
    %   list(2,2) = 1:6 % �ӵڶ��е�2�п�ʼ����1:6�ֱ�ֵ������Ԫ����;
    
    properties
        ndim; % ��������
        dim; % ����Ԫ����
        tol; % Ԫ������
        var; % Ԫ��ֵ
    end
    
    methods
        function obj = ndg_list(elenum)
            obj.ndim = numel(elenum);
            obj.tol = 0;
            obj.dim = zeros(obj.ndim, 1);
            for n = 1:obj.ndim
                obj.dim(n) = elenum(n);
                obj.tol = obj.tol + elenum(n);
            end
            obj.var = zeros(obj.tol, 1);
        end
        
        function disp(obj)
            sk = 1;
            for n = 1:obj.ndim
                disp(['list(:, ', num2str(n), ')']);
                disp( obj.var( sk:(sk+obj.dim(n)-1) ) );
                sk = sk + obj.dim(n);
            end
        end% func
        
        function b = subsref(a, s)
            switch s.type
                case '()'
                    num = numel(s.subs);
                    if(num == 1) 
                        b = a.var(s.subs{1}); % for b = a(4) type
                    elseif( num == 2 )
                        if ( s.subs{1} == ':' ) % for b = a(:, 2) type
                            sk = 1;
                            len = a.dim(s.subs{2});
                            for n = 1:(s.subs{2}-1)
                                sk = sk + a.dim(n);
                            end
                            ind = sk:(sk+len-1);
                            b = a.var(ind);
                        else
                            sk = s.subs{1}; % for b = a(1, 2) type
                            for n = 1:(s.subs{2}-1)
                                sk = sk + a.dim(n);
                            end
                            b = a.var(sk);
                        end
                    end
                case '{}'
                case '.'
            end% switch
        end
        
        function a = subsasgn(a, s, b)
            % change vector from row to colume
            if isrow(b) 
                b = b'; 
            end
            
            switch s.type
                case '()'
                    len = numel(b); % length of value
                    num = numel(s.subs); % dimension of index
                    if(num == 1) 
                        ind = s.subs{1}:(s.subs{1}+len-1);
                        a.var(ind) = b;
                    elseif( num == 2)
                        if ( s.subs{1} == ':' ) % for a(:, 2) = b type
                            sk = 1;
                            len = a.dim(s.subs{2});
                            for n = 1:(s.subs{2}-1)
                                sk = sk + a.dim(n);
                            end
                            ind = sk:(sk+len-1);
                            a.var(ind) = b;
                        else
                            sk = s.subs{1}; % for a(2) = b type
                            for n = 1:(s.subs{2}-1)
                                sk = sk + a.dim(n);
                            end
                            ind = sk:(sk+len-1);
                            a.var(ind) = b;
                        end
                    end
                case '{}'
                case '.'
            end
        end
    end
    
end

