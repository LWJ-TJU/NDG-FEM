%> \brief 2-D Non-linear Shallow Water Equation

%> \details
%> This class descripe the conservation equations of the mass and
%> monuments, written as
%> \f$ \frac{\partial \mathbf{U}}{\partial t} + \nabla \cdot
%> \mathbf{F}(\mathbf{U}) = \mathbf{S}(\mathbf{U}), \f$
%> where \f$ \mathbf{U} = (h, hu, hv) \f$ are the conservative variables,
%> \f$ \mathbf{F}(\mathbf{U}) \f$ and \f$ \mathbf{S}(\mathbf{U}) \f$
%> are the flux terms and source term, respectively.
%> For the SWE model, the wet/dry (WD) probelm is addressed with the
%> methods fron Li (2018), which requires to determine the WD states of
%> each elements. The numerical flux
classdef SWEAbstract2d < NdgPhysMat
    
    properties(Abstract, Constant)
        %> wet/dry depth threshold
        hmin
        %> gravity acceleration
        gra
    end
    
    properties( Constant )
        %> number of physical field
        Nfield = 5
        %> number of variable field
        Nvar = 3
        %> index of variable in physical field
        varFieldIndex = [ 1, 2, 3 ]
    end
    
    properties( SetAccess = private )
        %> gradient of bottom elevation
        zGrad
        %> solver for coriolis source term
        coriolisSolver
        %> solver for friction source term
        frictionSolver
        %> solver for wind source term
        windSolver
        %> solver for unmerical flux
        numfluxSolver
        %> limiter type
        limiterSolver
    end
    
    methods
        draw( obj, varargin )
    end
    
    methods( Hidden, Abstract )
        [ E, G ] = matEvaluateFlux( obj, mesh, fphys );
    end
    
    methods( Hidden, Sealed )
        %> impose boundary condition and evaluate cell boundary values
        [ fM, fP ] = matEvaluateSurfaceValue( obj, mesh, fphys, fext );
        
        %> evaluate local boundary flux
        function [ fluxM ] = matEvaluateSurfFlux( obj, mesh, nx, ny, fm )
            [ fluxM ] = mxEvaluateSurfFlux( obj.hmin, obj.gra, nx, ny, fm);
        end% func
        
        %> evaluate boundary numerical flux
        function [ fluxS ] = matEvaluateSurfNumFlux( obj, mesh, nx, ny, fm, fp )
            [ fluxS ] = obj.numfluxSolver.evaluate( obj.hmin, obj.gra, nx, ny, fm, fp );
        end% func
    end
    
    methods( Abstract, Access = protected )
        matUpdateWetDryState(obj, fphys)
        
        %> evaluate topography source term
        [ ] = matEvaluateTopographySourceTerm( obj, fphys )
        
        %> evaluate post function
        [ fphys ] = matEvaluatePostFunc(obj, fphys)
    end
    
    methods( Access = protected, Sealed )
        [ fphys ] = matEvaluateLimiter( obj, fphys )
        
        %> determine time interval
        [ dt ] = matUpdateTimeInterval( obj, fphys )
        
        %> evaluate source term
        [ ] = matEvaluateSourceTerm( obj, fphys )
    end
    
end
