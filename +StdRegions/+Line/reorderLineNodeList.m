%% reorderLineNodeList


function facelist = reorderLineNodeList(nOrder, vOrder)
% ���ձ���Ԫ(this)�ڵ�˳�򣬷��ضԷ���Ԫ(next)�ڵ���
% 
% Input: 
%   nOrder  - order of polynomial
%   vOrder  - �ڵ�˳��, nextVertice(vOrder) = thisVertice
% Output:
%   facelist    - 
% 
% ʹ�� thisElement ��׼��Ԫ�ֲ�������Ϊֱ�߶�������
VerCoor = [-1; 1];

% nextElement ��Ӧ��������
nextVerCoor = zeros(size(VerCoor));
nextVerCoor(vOrder) = VerCoor(:);

% ��� thisElement ��׼��Ԫ�ڵ�����
thisNodeCoor = Node1D(nOrder+1);
% �� thisElement �ڵ����� ͶӰ�� nextElement ��Ԫ
NodeCoor = (1-thisNodeCoor)/2.*nextVerCoor(1) + (1+thisNodeCoor)/2.*nextVerCoor(2);

% ���ݽڵ�������㺯�� $f = r$
nextf = NodeCoor;

% �ڵ�Ԫ thisElement ����ֵ f ��ڵ�˳��������
% ��Ԫ thisElement �ڵ��� nextElement �໥��Ӧ, ��Ӧ�ڵ� f ֵ��ͬ
% ���� f ֵ��С�ɵñ���Ԫ�ڵ���, ���� f ��ñ���Ԫ�ڵ�˳��
% thisf = nextf(facelist)
[thisf, facelist] = sort(nextf);
end% func

function Coor = Node1D(nNode)
Coor = linspace(-1, 1, nNode);
end% func