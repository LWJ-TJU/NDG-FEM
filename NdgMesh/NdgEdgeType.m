%> @brief enumeration for edge types.
%
%> And here we can put some more detailed informations about the class.
% ======================================================================
%> This class is part of the NDGOM software. 
%> @author li12242, Tianjin University, li12242@tju.edu.cn
% ======================================================================
classdef NdgEdgeType < int8
    
    enumeration
        Inner           (0)
        GaussEdge       (1)
        SlipWall        (2)
        NonSlipWall     (3)
        ZeroGrad        (4)
        Clamped         (5)
        ClampedDepth    (6)
        ClampedVel      (7)
        Flather         (8)
        RefineEdge      (9)
    end
end