%% reorderTriNodeList
% ���ձ���Ԫ(this)�ڵ�˳�򣬷��ضԷ���Ԫ(next)�ڵ���
% 
% Usages
% 
%   list = StdRegions.Triangle.reorderTriNodeList(3, [3,2,1])
%   list = [10     9     7     4     8     6     3     5     2     1]';
% 
% thisVer = [C, B, A]; nextVer = [A, B, C];
% vOrder = [3,2,1]
% 
% <</Users/mac/Documents/MATLAB/NDG-FEM/+StdRegions/+Triangle/fig/reorderTriNodeList.png>>

function facelist = reorderTriNodeList(nOrder, vOrder)
% ���ձ���Ԫ(this)�ڵ�˳�򣬷��ضԷ���Ԫ(next)�ڵ���
% 
% Input: 
%   nOrder  - order of polynomial
%   vOrder  - �ڵ�˳��, nextVertice(vOrder) = thisVertice
% Output:
%   facelist    - 
% 
% ʹ�� thisElement ��׼��Ԫ�ֲ�����ϵ��Ϊ�����ζ�������
VerCoor.r = [-1; 1; -1];
VerCoor.s = [-1; -1; 1];

% nextElement ���������� thisElement �ж�Ӧ�ڵ�������ͬ
nextVerCoor.r = zeros(size(VerCoor.r));
nextVerCoor.s = zeros(size(VerCoor.s));
nextVerCoor.r(vOrder) = VerCoor.r(:);
nextVerCoor.s(vOrder) = VerCoor.s(:);

% ��� thisElement ��׼��Ԫ�ڵ�����
[x,y] = Nodes2D(nOrder);
[r, s] = xytors(x,y);
% �� thisElement �ڵ����� ͶӰ�� nextElement ��Ԫ
NodeCoor.r = 0.5*(-(r+s)*nextVerCoor.r(1)+(1+r)*nextVerCoor.r(2)+(1+s)*nextVerCoor.r(3));
NodeCoor.s = 0.5*(-(r+s)*nextVerCoor.s(1)+(1+r)*nextVerCoor.s(2)+(1+s)*nextVerCoor.s(3));

% ���ݽڵ�������㺯�� $f = r + M*s$
M = ceil(1./sqrt((NodeCoor.r(2)- NodeCoor.r(1)).^2 ...
    +(NodeCoor.s(2)- NodeCoor.s(1)).^2))+100;
nextf = NodeCoor.r + M* NodeCoor.s;

% �ڵ�Ԫ thisElement ����ֵ f ��ڵ�˳��������
% ��Ԫ nextElement �ڵ��� thisElement �໥��Ӧ, ��Ӧ�ڵ� f ֵ��ͬ
% ���� f ֵ��С�ɵñ���Ԫ�ڵ���, ���� f ��ñ���Ԫ�ڵ�˳��
% thisf = nextf(facelist)
[thisf,facelist] = sort(nextf);
end% func

function [x,y] = Nodes2D(N)
% total number of nodes
Np = (N+1)*(N+2)/2;
% Create equidistributed nodes on equilateral triangle
L1 = zeros(Np,1); L3 = zeros(Np,1); %L2 = zeros(Np,1); 
sk = 1;
for n=1:N+1
  for m=1:N+2-n
    L1(sk) = (n-1)/N; L3(sk) = (m-1)/N;
    sk = sk+1;
  end% for
end% for
L2 = 1.0-L1-L3;
x = -L2+L3; y = (-L2-L3+2*L1)/sqrt(3.0);
end% func

function [r,s] = xytors(x,y)
% From (x,y) in equilateral triangle to 
% (r,s) coordinates in standard triangle
L1 = (sqrt(3.0)*y+1.0)/3.0;
L2 = (-3.0*x - sqrt(3.0)*y + 2.0)/6.0;
L3 = ( 3.0*x - sqrt(3.0)*y + 2.0)/6.0;
r = -L2 + L3 - L1; s = -L2 - L3 + L1;
end% func