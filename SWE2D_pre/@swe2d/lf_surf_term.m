function [ dflux ] = lf_surf_term( obj, f_Q )
%LF_SURF_TERM 计算单元边界节点处法向通量项与 LF 数值通量之差
%   Detailed explanation goes here

dflux = zeros(obj.mesh.cell.Nfptotal, obj.mesh.K, obj.Nfield);

[dflux(:,:,1), dflux(:,:,2), dflux(:,:,3)] = lf_flux(...
    obj.hmin, obj.gra, ...
    f_Q(:,:,1), f_Q(:,:,2), f_Q(:,:,3), ...
    obj.f_extQ(:,:,1), obj.f_extQ(:,:,2), obj.f_extQ(:,:,3), ...
    obj.mesh.nx, obj.mesh.ny, ...
    obj.mesh.eidM, obj.mesh.eidP, obj.mesh.eidtype);
end

