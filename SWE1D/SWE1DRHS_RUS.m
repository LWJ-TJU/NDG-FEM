function [rhsQ, lamda] = SWE1DRHS_RUS(mesh, Q, Nfp, Dr, Fmat, invM)
% 

% Interface function handles, Ŀ�ļ��ٶ������ʱ����API
% Nfp = @(x)mesh.Shape.nFaceNode;
% Dr = @(x)mesh.Shape.Dr;
% Fmat = @(x)mesh.Shape.FaceMassMatrixSmall;
% invM = @(x)mesh.Shape.invM;

h = Q(:,:,1); hu = Q(:,:,2);
g = 9.8;

%% flux
F = SWEFlux(Q);

%% numerical flux

hM  = zeros(Nfp(), mesh.nElement); hM(:) = h(mesh.vmapM);
hP  = zeros(Nfp(), mesh.nElement); hP(:) = h(mesh.vmapP); 
huM  = zeros(Nfp(), mesh.nElement); huM(:) = hu(mesh.vmapM); 
huP  = zeros(Nfp(), mesh.nElement); huP(:) = hu(mesh.vmapP);

% lamda = max{|u|+aL, |u|+aR}, aL=sqrt(g*hL)
% lamda = zeros(Nfp(), mesh.nElement);
lamda = abs(huM./hM) + sqrt(g.*hM);
lamda1= abs(huP./hP) + sqrt(g.*hP);
lamda(lamda1>lamda) = lamda1(lamda1>lamda);


QM(:,:,1) = hM; QM(:,:,2) = huM;
QP(:,:,1) = hP; QP(:,:,2) = huP;

FM = SWEFlux(QM); FP = SWEFlux(QP);

dF = zeros(Nfp(), mesh.nElement, 2);

dF(:,:,1) = mesh.nx.*(FM(:,:,1) - FP(:,:,1))./2 - lamda.*(QM(:,:,1) - QP(:,:,1))./2;
dF(:,:,2) = mesh.nx.*(FM(:,:,2) - FP(:,:,2))./2 - lamda.*(QM(:,:,2) - QP(:,:,2))./2;

%% RHS

rhsQ(:,:,1) = -mesh.rx.*(Dr()*F(:,:,1)) + invM()*(Fmat()*(mesh.fScale.*dF(:,:,1)));
rhsQ(:,:,2) = -mesh.rx.*(Dr()*F(:,:,2)) + invM()*(Fmat()*(mesh.fScale.*dF(:,:,2)));

end