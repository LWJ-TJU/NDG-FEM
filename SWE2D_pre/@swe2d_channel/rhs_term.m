function [ rhs ] = rhs_term( obj, f_Q )
%RHS_TERM Summary of this function goes here
%   Detailed explanation goes here

[ dflux ] = hll_surf_term( obj, f_Q );
[ E, G ] = flux_term( obj, f_Q );
[ sb ] = topo_sour_term( obj, f_Q );

sigma = obj.mesh.cal_sponge_strength(500, 0.9/obj.dt);

rhs(:,:,1) = -obj.mesh.rx.*( obj.mesh.cell.Dr*E(:, :, 1) ) ...
    -obj.mesh.sx.*( obj.mesh.cell.Ds*E(:, :, 1) ) ...
    -obj.mesh.ry.*( obj.mesh.cell.Dr*G(:, :, 1) ) ...
    -obj.mesh.sy.*( obj.mesh.cell.Ds*G(:, :, 1) )  ...
    +obj.mesh.cell.LIFT*( obj.mesh.Js.*dflux(:,:,1) )./obj.mesh.J ...
    +sb(:, :, 1) - sigma.*(f_Q(:,:,1) - obj.f_extQ(:,:,1));

rhs(:,:,2) = -obj.mesh.rx.*( obj.mesh.cell.Dr*E(:, :, 2) ) ...
    -obj.mesh.sx.*( obj.mesh.cell.Ds*E(:, :, 2) ) ...
    -obj.mesh.ry.*( obj.mesh.cell.Dr*G(:, :, 2) ) ...
    -obj.mesh.sy.*( obj.mesh.cell.Ds*G(:, :, 2) )  ...
    +obj.mesh.cell.LIFT*( obj.mesh.Js.*dflux(:,:,2) )./obj.mesh.J ...
    +sb(:, :, 2) - sigma.*(f_Q(:,:,2) - obj.f_extQ(:,:,2));

rhs(:,:,3) = -obj.mesh.rx.*( obj.mesh.cell.Dr*E(:, :, 3) ) ...
    -obj.mesh.sx.*( obj.mesh.cell.Ds*E(:, :, 3) ) ...
    -obj.mesh.ry.*( obj.mesh.cell.Dr*G(:, :, 3) ) ...
    -obj.mesh.sy.*( obj.mesh.cell.Ds*G(:, :, 3) )  ...
    +obj.mesh.cell.LIFT*( obj.mesh.Js.*dflux(:,:,3) )./obj.mesh.J ...
    +sb(:, :, 3) - sigma.*(f_Q(:,:,3) - obj.f_extQ(:,:,3));
end

