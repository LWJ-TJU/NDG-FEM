classdef swe2d_cs < swe2d
    %SWE2D_CS ǳˮ����ģ�� Gaussian ������״ˮλ�ɾ��μ��������������ܴ�������
    %   ������Ϊ 20 m x 20 m ���Σ�����Ϊƽ�¡�����������þ�������ÿ��
    %   �����ϵ�Ԫ�������û�ָ����
    %   ��ʼ�ٶ�Ϊ0��ˮλΪ h = 2.4*exp( -( (x-10) + (y-10) )/4 )
    
    properties(Constant)
        hmin = 1e-4
    end
    
    methods
        function obj = swe2d_cs(varargin)
            switch nargin
                case 1
                    mesh = varargin(1);
                    if ( ~isa(mesh, 'ndg_lib.mesh.tri_mesh') || ...
                            ~isa(mesh, 'ndg_lib.mesh.quad_mesh') )
                        error(['The input is not a triangle or ',... 
                            'quadrilateral mesh object!']);
                    end
                case 3
                    N = varargin{1}; 
                    Mx = varargin{2}; 
                    type = varargin{3};
                    mesh = uniform_mesh( N, Mx, type );
                otherwise
                    error('The number of input variable is incorrect.');
            end% switch
            
            obj = obj@swe2d(mesh);
            obj.init;
            obj.ftime = 4;
        end
        
        function init(obj)
            f_Q = zeros(obj.mesh.cell.Np, obj.mesh.K, obj.Nfield);
            obj.bot = zeros(obj.mesh.cell.Np, obj.mesh.K);
            h = 2.4*(1+exp( -((obj.mesh.x - 10).^2 ...
                + (obj.mesh.y - 10).^2)/4 ));
            f_Q(:,:,1) = h;
            obj.f_Q = f_Q;
        end
    end
    
end

