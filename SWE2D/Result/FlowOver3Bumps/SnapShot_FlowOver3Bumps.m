function SnapShot_FlowOver3Bumps
% Parameter
T        = 20;
casename = 'SWE2D_FlowOver3BumpsUniform_';
meshtype = 'quad';
filename = {[casename, meshtype, '_100.nc']};
order    = 1;
Postpro  = Utilities.PostProcess.Postprocess(filename, meshtype, order);
fileID   = 1;
time     = (0:0.005:1)*T;

% plot bottom topography
bot = Postpro.NcFile(1).GetVarData('bot');
bh = Postpro.SnapshotConst2D('bot',fileID);
set(bh, 'FaceColor', [0.4, 0.4, .4]);

hold on;
box on;
grid on;

% plot water level
cmap = colormap('winter');
p_h = Postpro.Snapshot2D(...
    'h',time(1)+eps, 1,'value', ...
    cmap(end,:), cmap(1, :), [0, 1.875],...
    'EdgeColor', 'none',... % ������������������ɫ��͸���ȵ�
    'FaceAlpha', 0.8);

% set axes properties
set(gca, 'DataAspectRatio', [10,10,1])
zlim([0, 5]);
zlabel('\eta (m)','FontSize', 14);
xlabel('x (m)','FontSize', 14);
ylabel('y (m)','FontSize', 14);
view(-40, 24);

% Update water level
x = Postpro.NcFile(fileID).GetVarData('x');
y = Postpro.NcFile(fileID).GetVarData('y');
for i = 1:numel(time)
    val = Postpro.GetVarData('h', time(i), fileID);
    val(val<1e-2) = nan;
    % ���� patch ����� vertex ���ԣ��������νڵ�����˳���������
    vertex = [x(:), y(:), val(:)+bot(:)];
    % ͬʱ���½ڵ���ɫ
    set(p_h, 'Vertices', vertex,...
        'FaceVertexCData', val(:)+bot(:));
    drawnow;
end% for
end% func